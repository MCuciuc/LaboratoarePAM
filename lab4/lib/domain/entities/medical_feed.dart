import 'package:lab2/domain/entities/appointment.dart';
import 'package:lab2/domain/entities/doctor.dart';
import 'package:lab2/domain/entities/health_service.dart';
import 'package:lab2/domain/entities/user_profile.dart';

class MedicalFeed {
  const MedicalFeed({
    required this.user,
    required this.hasUnreadNotifications,
    required this.searchHint,
    required this.appointment,
    required this.details,
    required this.services,
    required this.doctors,
  });

  final UserProfile user;
  final bool hasUnreadNotifications;
  final String searchHint;
  final AppointmentSummary appointment;
  final AppointmentDetails details;
  final List<HealthService> services;
  final List<Doctor> doctors;
}
