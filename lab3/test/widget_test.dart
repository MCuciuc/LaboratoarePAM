import 'package:flutter_test/flutter_test.dart';
import 'package:lab2/data/models/appointment.dart';
import 'package:lab2/data/repositories/medical_repository.dart';
import 'package:lab2/state/medical_cubit.dart';
import 'package:lab2/state/medical_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const repository = MedicalRepository(delay: Duration.zero);

  test('JSON asset is parsed into medical data', () async {
    final data = await repository.load();

    expect(data.user.greeting, 'Hi, Jonathan');
    expect(data.user.subtitle, 'May you always be healthy!');
    expect(data.hasUnreadNotifications, isTrue);
    expect(data.services, hasLength(4));
    expect(data.doctors, hasLength(2));
    expect(data.doctors.first.distanceMeters, 500);
    expect(data.doctors.last.distanceMeters, 753);
    expect(data.details.priceLabel, '\$120.00');
    expect(data.details.bookLabel, 'Book an Appointment');
    expect(
      data.details.hours.firstWhere((SlotOption slot) => slot.selectedInitially).id,
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
