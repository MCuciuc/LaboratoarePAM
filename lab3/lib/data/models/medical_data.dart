import 'package:lab2/data/models/appointment.dart';
import 'package:lab2/data/models/doctor.dart';
import 'package:lab2/data/models/health_service.dart';
import 'package:lab2/data/models/json_utils.dart';
import 'package:lab2/data/models/user_profile.dart';

class MedicalData {
  const MedicalData({
    required this.user,
    required this.hasUnreadNotifications,
    required this.searchHint,
    required this.appointment,
    required this.services,
    required this.doctors,
    required this.details,
  });

  final UserProfile user;
  final bool hasUnreadNotifications;
  final String searchHint;
  final AppointmentSummary appointment;
  final List<HealthService> services;
  final List<Doctor> doctors;
  final AppointmentDetails details;

  factory MedicalData.fromJson(Map<String, dynamic> json) {
    final home = asMap(json['homeScreen']);
    final notifications = asMap(home['notifications']);
    final search = asMap(home['search']);
    return MedicalData(
      user: UserProfile.fromJson(asMap(home['user'])),
      hasUnreadNotifications: notifications['hasUnread'] as bool? ?? false,
      searchHint: search['hint'] as String? ?? 'Search',
      appointment: AppointmentSummary.fromJson(asMap(home['appointment'])),
      services: [
        for (final item in asMapList(home['healthServices'])) HealthService.fromJson(item),
      ],
      doctors: [
        for (final item in asMapList(home['nearbyDoctors'])) Doctor.fromJson(item),
      ],
      details: AppointmentDetails.fromJson(asMap(json['appointmentDetails'])),
    );
  }
}
