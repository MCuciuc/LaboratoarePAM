import 'package:lab2/core/api_exception.dart';
import 'package:lab2/domain/entities/appointment.dart';
import 'package:lab2/domain/entities/doctor.dart';
import 'package:lab2/domain/entities/health_service.dart';
import 'package:lab2/domain/entities/user_profile.dart';

class FeedDto {
  const FeedDto({
    required this.user,
    required this.hasUnreadNotifications,
    required this.searchHint,
    required this.appointment,
    required this.services,
    required this.doctors,
  });

  final UserProfile user;
  final bool hasUnreadNotifications;
  final String searchHint;
  final AppointmentSummary appointment;
  final List<HealthService> services;
  final List<Doctor> doctors;

  factory FeedDto.fromJson(Map<String, dynamic> json) {
    final user = _object(json['user'], 'user');
    final notifications = _object(json['notifications'], 'notifications');
    final search = _object(json['search'], 'search');
    final appointment = _object(json['appointment'], 'appointment');
    final doctor = _object(appointment['doctor'], 'appointment.doctor');

    return FeedDto(
      user: UserProfile(
        name: _string(user['name'], 'user.name'),
        greeting: _string(user['greeting'], 'user.greeting'),
        subtitle: _string(user['subtitle'], 'user.subtitle'),
        avatarUrl: _string(user['avatarUrl'], 'user.avatarUrl'),
      ),
      hasUnreadNotifications: _bool(notifications['hasUnread'], 'notifications.hasUnread'),
      searchHint: _string(search['hint'], 'search.hint'),
      appointment: AppointmentSummary(
        title: _string(appointment['title'], 'appointment.title'),
        date: _string(appointment['date'], 'appointment.date'),
        time: _string(appointment['time'], 'appointment.time'),
        doctorName: _string(doctor['name'], 'appointment.doctor.name'),
        specialty: _string(doctor['specialty'], 'appointment.doctor.specialty'),
        avatarUrl: _string(doctor['avatarUrl'], 'appointment.doctor.avatarUrl'),
      ),
      services: [
        for (final item in _list(json['healthServices'], 'healthServices'))
          HealthService(
            id: _string(item['id'], 'healthServices.id'),
            name: _string(item['name'], 'healthServices.name'),
            iconUrl: _string(item['iconUrl'], 'healthServices.iconUrl'),
          ),
      ],
      doctors: [
        for (final item in _list(json['nearbyDoctors'], 'nearbyDoctors'))
          Doctor(
            id: _string(item['id'], 'nearbyDoctors.id'),
            name: _string(item['name'], 'nearbyDoctors.name'),
            specialty: _string(item['specialty'], 'nearbyDoctors.specialty'),
            distance: _string(item['distance'], 'nearbyDoctors.distance'),
            avatarUrl: _string(item['avatarUrl'], 'nearbyDoctors.avatarUrl'),
            isFavorite: _bool(item['isFavorite'], 'nearbyDoctors.isFavorite'),
          ),
      ],
    );
  }
}

class AppointmentDetailsDto {
  const AppointmentDetailsDto(this.details);

  final AppointmentDetails details;

  factory AppointmentDetailsDto.fromJson(Map<String, dynamic> json) {
    final doctor = _object(json['doctor'], 'doctor');
    final actions = _object(doctor['actions'], 'doctor.actions');
    final payment = _object(json['payment'], 'payment');
    final details = _object(json['details'], 'details');
    final hours = _object(json['workingHours'], 'workingHours');
    final date = _object(json['date'], 'date');
    final rootActions = _object(json['actions'], 'actions');
    final book = _object(rootActions['bookAppointment'], 'actions.bookAppointment');

    return AppointmentDetailsDto(
      AppointmentDetails(
        title: _string(json['title'], 'title'),
        doctorName: _string(doctor['name'], 'doctor.name'),
        clinic: _string(doctor['clinic'], 'doctor.clinic'),
        avatarUrl: _string(doctor['avatarUrl'], 'doctor.avatarUrl'),
        canMessage: _bool(actions['message'], 'doctor.actions.message'),
        canCall: _bool(actions['call'], 'doctor.actions.call'),
        canVideoCall: _bool(actions['videoCall'], 'doctor.actions.videoCall'),
        paymentLabel: _string(payment['label'], 'payment.label'),
        priceLabel: _string(payment['formatted'], 'payment.formatted'),
        detailsTitle: _string(details['title'], 'details.title'),
        description: _string(details['description'], 'details.description'),
        hoursTitle: _string(hours['title'], 'workingHours.title'),
        showAllHours: _bool(hours['showAll'], 'workingHours.showAll'),
        hours: _slots(hours['slots'], 'workingHours.slots'),
        dateTitle: _string(date['title'], 'date.title'),
        showAllDates: _bool(date['showAll'], 'date.showAll'),
        dates: _slots(date['slots'], 'date.slots'),
        bookLabel: _string(book['label'], 'actions.bookAppointment.label'),
        bookEnabled: _bool(book['enabled'], 'actions.bookAppointment.enabled'),
      ),
    );
  }
}

List<SlotOption> _slots(Object? value, String field) {
  return [
    for (final item in _list(value, field))
      SlotOption(
        id: _string(item['id'], '$field.id'),
        label: _string(item['label'], '$field.label'),
        selectedInitially: _bool(item['selected'], '$field.selected'),
      ),
  ];
}

Map<String, dynamic> _object(Object? value, String field) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  throw ApiException('The server response is missing "$field".');
}

List<Map<String, dynamic>> _list(Object? value, String field) {
  if (value is! List) {
    throw ApiException('The server response is missing "$field".');
  }
  return [
    for (final item in value) _object(item, field),
  ];
}

String _string(Object? value, String field) {
  if (value is String) return value;
  throw ApiException('The server response is missing "$field".');
}

bool _bool(Object? value, String field) {
  if (value is bool) return value;
  throw ApiException('The server response is missing "$field".');
}
