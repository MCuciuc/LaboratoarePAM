import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lab2/data/models/feed_dto.dart';
import 'package:lab2/domain/entities/appointment.dart';
import 'package:lab2/domain/entities/medical_feed.dart';
import 'package:lab2/domain/repositories/medical_repository.dart';
import 'package:lab2/presentation/state/medical_cubit.dart';
import 'package:lab2/presentation/state/medical_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final repository = _FakeRepository();

  test('feed and details JSON are deserialized into domain data', () {
    final feed = FeedDto.fromJson(jsonDecode(_feedJson) as Map<String, dynamic>);
    final details = AppointmentDetailsDto.fromJson(jsonDecode(_detailsJson) as Map<String, dynamic>);

    expect(feed.user.greeting, 'Hi, Jonathan');
    expect(feed.user.subtitle, 'May you always be healthy!');
    expect(feed.hasUnreadNotifications, isTrue);
    expect(feed.services, hasLength(4));
    expect(feed.doctors, hasLength(2));
    expect(feed.doctors.first.distanceMeters, 500);
    expect(feed.doctors.last.distanceMeters, 753);
    expect(details.details.priceLabel, '\$120.00');
    expect(details.details.bookLabel, 'Book an Appointment');
    expect(
      details.details.hours.firstWhere((SlotOption slot) => slot.selectedInitially).id,
      '11am',
    );
  });

  test('cubit searches, filters, sorts and toggles favorites', () async {
    final cubit = MedicalCubit(repository, bookingDelay: Duration.zero);
    addTearDown(cubit.close);
    await cubit.load();

    expect(cubit.state.status, PageStatus.success);
    expect(cubit.state.catalogStatus, PageStatus.success);
    expect(cubit.state.selectedTimeSlotId, '11am');
    expect(cubit.state.selectedDateSlotId, 'sun-4');

    cubit.setQuery('emmly');
    expect(cubit.state.visibleDoctors.single.name, contains('Emmly'));

    cubit.setQuery('zzzz-not-a-doctor');
    expect(cubit.state.catalogStatus, PageStatus.empty);

    cubit.clearFilters();
    cubit.setService('tooth');
    expect(cubit.state.visibleDoctors.single.specialty, 'Dental Specialist');

    cubit.setService('eye');
    expect(cubit.state.catalogStatus, PageStatus.empty);
    expect(cubit.state.emptyMessage, contains('Eye'));

    cubit.clearFilters();
    cubit.setSort(DoctorSort.distanceAsc);
    expect(cubit.state.visibleDoctors.first.distanceMeters, 500);
    cubit.setSort(DoctorSort.nameDesc);
    expect(cubit.state.visibleDoctors.first.name, contains('Sonja'));

    cubit.toggleFavorite('doctor-001');
    expect(cubit.state.doctorById('doctor-001')?.isFavorite, isTrue);
    cubit.setFavoritesOnly(true);
    expect(cubit.state.visibleDoctors.single.id, 'doctor-001');
    cubit.toggleFavorite('doctor-001');
    expect(cubit.state.catalogStatus, PageStatus.empty);
  });

  test('booking waits and then reports success', () async {
    final cubit = MedicalCubit(repository, bookingDelay: Duration.zero);
    addTearDown(cubit.close);
    await cubit.load();

    final booking = cubit.bookAppointment();
    expect(cubit.state.bookingStatus, BookingStatus.submitting);
    await booking;
    expect(cubit.state.bookingStatus, BookingStatus.success);
    expect(cubit.state.bookingMessage, 'Appointment booked for Sun 4 at 11.00 AM.');
  });

  test('a failed load exposes the error state and retry recovers', () async {
    final cubit = MedicalCubit(repository, bookingDelay: Duration.zero);
    addTearDown(cubit.close);
    final statuses = <PageStatus>[];
    final subscription = cubit.stream.listen((state) => statuses.add(state.status));
    addTearDown(subscription.cancel);

    await cubit.load(fail: true);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.status, PageStatus.error);
    expect(cubit.state.errorMessage, contains('Simulated failure'));
    expect(statuses, [PageStatus.loading, PageStatus.error]);

    await cubit.load();
    expect(cubit.state.status, PageStatus.success);
    expect(cubit.state.catalogStatus, PageStatus.success);
    expect(cubit.state.doctors, hasLength(2));
  });
}

class _FakeRepository implements MedicalRepository {
  @override
  Future<MedicalFeed> load() async {
    final feed = FeedDto.fromJson(jsonDecode(_feedJson) as Map<String, dynamic>);
    final details = AppointmentDetailsDto.fromJson(jsonDecode(_detailsJson) as Map<String, dynamic>);
    return MedicalFeed(
      user: feed.user,
      hasUnreadNotifications: feed.hasUnreadNotifications,
      searchHint: feed.searchHint,
      appointment: feed.appointment,
      details: details.details,
      services: feed.services,
      doctors: feed.doctors,
    );
  }
}

const _feedJson = '''
{
  "user": {"name": "Jonathan", "greeting": "Hi, Jonathan", "subtitle": "May you always be healthy!", "avatarUrl": "https://example.com/jonathan.jpg"},
  "notifications": {"hasUnread": true},
  "search": {"hint": "Search something"},
  "appointment": {
    "title": "Appointment",
    "date": "22 October, 2023",
    "time": "08:00 AM - 10.30 AM",
    "doctor": {"name": "Dr. Richar Kandowen", "specialty": "Child Specialist", "avatarUrl": "https://example.com/richar.jpg"}
  },
  "healthServices": [
    {"id": "tooth", "name": "Tooth", "iconUrl": "https://example.com/tooth.svg"},
    {"id": "eye", "name": "Eye", "iconUrl": "https://example.com/eye.svg"},
    {"id": "lungs", "name": "Lungs", "iconUrl": "https://example.com/lungs.svg"},
    {"id": "ear", "name": "Ear", "iconUrl": "https://example.com/ear.svg"}
  ],
  "nearbyDoctors": [
    {"id": "doctor-001", "name": "Dr. Emmly Lestiryno", "specialty": "General Practitioner", "distance": "3167 Durgan Shores - 500M from you", "avatarUrl": "https://example.com/emmly.jpg", "isFavorite": false},
    {"id": "doctor-002", "name": "Dr. Sonja Litel", "specialty": "Dental Specialist", "distance": "950 Sigrid Port - 753M from you", "avatarUrl": "https://example.com/sonja.jpg", "isFavorite": false}
  ]
}
''';

const _detailsJson = '''
{
  "title": "Appointment",
  "doctor": {
    "name": "Dr.Upul",
    "clinic": "Denteeth",
    "avatarUrl": "https://example.com/upul.jpg",
    "actions": {"message": true, "call": true, "videoCall": true}
  },
  "payment": {"label": "Payment", "amount": 120.0, "currency": "USD", "formatted": "\$120.00"},
  "details": {"title": "Details", "description": "Worem ipsum dolor sit amet."},
  "workingHours": {
    "title": "Working Hours",
    "showAll": true,
    "slots": [
      {"id": "10am", "label": "10.00 AM", "selected": false},
      {"id": "11am", "label": "11.00 AM", "selected": true},
      {"id": "12pm", "label": "12.00 PM", "selected": false}
    ]
  },
  "date": {
    "title": "Date",
    "showAll": true,
    "slots": [
      {"id": "sun-4", "label": "Sun 4", "selected": true},
      {"id": "mon-5", "label": "Mon 5", "selected": false},
      {"id": "tue-6", "label": "Tue 6", "selected": false}
    ]
  },
  "actions": {"bookAppointment": {"label": "Book an Appointment", "enabled": true}}
}
''';
