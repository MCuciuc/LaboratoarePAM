import 'package:lab2/domain/entities/appointment.dart';
import 'package:lab2/domain/entities/doctor.dart';
import 'package:lab2/domain/entities/health_service.dart';
import 'package:lab2/domain/entities/user_profile.dart';

enum PageStatus { loading, success, empty, error }

enum BookingStatus { idle, submitting, success, failure }

enum DoctorSort {
  nameAsc('Name (A–Z)'),
  nameDesc('Name (Z–A)'),
  distanceAsc('Nearest'),
  specialtyAsc('Specialty');

  const DoctorSort(this.label);
  final String label;
}

const _serviceKeywords = <String, List<String>>{
  'tooth': ['dental', 'tooth', 'dentist'],
  'eye': ['eye', 'ophthal', 'vision'],
  'lungs': ['lung', 'pulmon', 'respiratory'],
  'ear': ['ear', 'otol', 'hearing'],
};

class MedicalState {
  const MedicalState({
    this.status = PageStatus.loading,
    this.errorMessage,
    this.user,
    this.hasUnreadNotifications = false,
    this.searchHint = 'Search something',
    this.appointment,
    this.details,
    this.services = const [],
    this.doctors = const [],
    this.query = '',
    this.specialtyFilter,
    this.serviceFilter,
    this.sort = DoctorSort.nameAsc,
    this.favoritesOnly = false,
    this.selectedTimeSlotId,
    this.selectedDateSlotId,
    this.bookingStatus = BookingStatus.idle,
    this.bookingMessage,
  });

  final PageStatus status;
  final String? errorMessage;
  final UserProfile? user;
  final bool hasUnreadNotifications;
  final String searchHint;
  final AppointmentSummary? appointment;
  final AppointmentDetails? details;
  final List<HealthService> services;
  final List<Doctor> doctors;
  final String query;
  final String? specialtyFilter;
  final String? serviceFilter;
  final DoctorSort sort;
  final bool favoritesOnly;
  final String? selectedTimeSlotId;
  final String? selectedDateSlotId;
  final BookingStatus bookingStatus;
  final String? bookingMessage;

  List<String> get specialties {
    final values = doctors.map((doctor) => doctor.specialty).toSet().toList();
    values.sort();
    return values;
  }

  bool get hasActiveFilters =>
      query.trim().isNotEmpty ||
      specialtyFilter != null ||
      serviceFilter != null ||
      favoritesOnly ||
      sort != DoctorSort.nameAsc;

  String? get activeServiceName {
    final id = serviceFilter;
    if (id == null) return null;
    for (final service in services) {
      if (service.id == id) return service.name;
    }
    return id;
  }

  Doctor? doctorById(String id) {
    for (final doctor in doctors) {
      if (doctor.id == id) return doctor;
    }
    return null;
  }

  List<Doctor> get visibleDoctors {
    final searched = query.trim().toLowerCase();
    final result = doctors.where((doctor) {
      final matchesQuery = searched.isEmpty ||
          doctor.name.toLowerCase().contains(searched) ||
          doctor.specialty.toLowerCase().contains(searched) ||
          doctor.distance.toLowerCase().contains(searched);
      final matchesSpecialty = specialtyFilter == null || doctor.specialty == specialtyFilter;
      final matchesFavorite = !favoritesOnly || doctor.isFavorite;
      final matchesService = serviceFilter == null || _matchesService(doctor, serviceFilter!);
      return matchesQuery && matchesSpecialty && matchesFavorite && matchesService;
    }).toList();

    switch (sort) {
      case DoctorSort.nameAsc:
        result.sort((a, b) => a.name.compareTo(b.name));
      case DoctorSort.nameDesc:
        result.sort((a, b) => b.name.compareTo(a.name));
      case DoctorSort.distanceAsc:
        result.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
      case DoctorSort.specialtyAsc:
        result.sort((a, b) => a.specialty.compareTo(b.specialty));
    }
    return result;
  }

  PageStatus get catalogStatus {
    if (status == PageStatus.loading || status == PageStatus.error) return status;
    return visibleDoctors.isEmpty ? PageStatus.empty : PageStatus.success;
  }

  String get emptyMessage {
    if (favoritesOnly && query.trim().isEmpty && specialtyFilter == null && serviceFilter == null) {
      return 'No favorite doctors yet. Tap the heart on a doctor to save one.';
    }
    final searched = query.trim();
    if (searched.isNotEmpty) return 'No doctors match "$searched".';
    final serviceName = activeServiceName;
    if (serviceName != null) return 'No doctors available for $serviceName.';
    if (specialtyFilter != null) return 'No doctors in $specialtyFilter.';
    return 'No doctors to show.';
  }

  MedicalState copyWith({
    PageStatus? status,
    String? errorMessage,
    bool clearError = false,
    UserProfile? user,
    bool? hasUnreadNotifications,
    String? searchHint,
    AppointmentSummary? appointment,
    AppointmentDetails? details,
    List<HealthService>? services,
    List<Doctor>? doctors,
    String? query,
    String? specialtyFilter,
    bool clearSpecialty = false,
    String? serviceFilter,
    bool clearService = false,
    DoctorSort? sort,
    bool? favoritesOnly,
    String? selectedTimeSlotId,
    String? selectedDateSlotId,
    BookingStatus? bookingStatus,
    String? bookingMessage,
    bool clearBookingMessage = false,
  }) {
    return MedicalState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      user: user ?? this.user,
      hasUnreadNotifications: hasUnreadNotifications ?? this.hasUnreadNotifications,
      searchHint: searchHint ?? this.searchHint,
      appointment: appointment ?? this.appointment,
      details: details ?? this.details,
      services: services ?? this.services,
      doctors: doctors ?? this.doctors,
      query: query ?? this.query,
      specialtyFilter: clearSpecialty ? null : (specialtyFilter ?? this.specialtyFilter),
      serviceFilter: clearService ? null : (serviceFilter ?? this.serviceFilter),
      sort: sort ?? this.sort,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      selectedTimeSlotId: selectedTimeSlotId ?? this.selectedTimeSlotId,
      selectedDateSlotId: selectedDateSlotId ?? this.selectedDateSlotId,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      bookingMessage: clearBookingMessage ? null : (bookingMessage ?? this.bookingMessage),
    );
  }
}

bool _matchesService(Doctor doctor, String serviceId) {
  final keys = _serviceKeywords[serviceId] ?? [serviceId];
  final specialty = doctor.specialty.toLowerCase();
  for (final key in keys) {
    if (specialty.contains(key)) return true;
  }
  return false;
}
