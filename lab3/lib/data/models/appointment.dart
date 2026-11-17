import 'package:lab2/data/models/json_utils.dart';

class SlotOption {
  const SlotOption({
    required this.id,
    required this.label,
    required this.selectedInitially,
  });

  final String id;
  final String label;
  final bool selectedInitially;

  factory SlotOption.fromJson(Map<String, dynamic> json) {
    return SlotOption(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
      selectedInitially: json['selected'] as bool? ?? false,
    );
  }
}

class AppointmentSummary {
  const AppointmentSummary({
    required this.title,
    required this.date,
    required this.time,
    required this.doctorName,
    required this.specialty,
    required this.avatarUrl,
  });

  final String title;
  final String date;
  final String time;
  final String doctorName;
  final String specialty;
  final String avatarUrl;

  factory AppointmentSummary.fromJson(Map<String, dynamic> json) {
    final doctor = asMap(json['doctor']);
    return AppointmentSummary(
      title: json['title'] as String? ?? 'Appointment',
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
      doctorName: doctor['name'] as String? ?? '',
      specialty: doctor['specialty'] as String? ?? '',
      avatarUrl: doctor['avatarUrl'] as String? ?? '',
    );
  }
}

class AppointmentDetails {
  const AppointmentDetails({
    required this.title,
    required this.doctorName,
    required this.clinic,
    required this.avatarUrl,
    required this.canMessage,
    required this.canCall,
    required this.canVideoCall,
    required this.paymentLabel,
    required this.amount,
    required this.currency,
    required this.formatted,
    required this.detailsTitle,
    required this.description,
    required this.hoursTitle,
    required this.showAllHours,
    required this.hours,
    required this.dateTitle,
    required this.showAllDates,
    required this.dates,
    required this.bookLabel,
    required this.bookEnabled,
  });

  final String title;
  final String doctorName;
  final String clinic;
  final String avatarUrl;
  final bool canMessage;
  final bool canCall;
  final bool canVideoCall;
  final String paymentLabel;
  final double amount;
  final String currency;
  final String formatted;
  final String detailsTitle;
  final String description;
  final String hoursTitle;
  final bool showAllHours;
  final List<SlotOption> hours;
  final String dateTitle;
  final bool showAllDates;
  final List<SlotOption> dates;
  final String bookLabel;
  final bool bookEnabled;

  String get priceLabel {
    if (formatted.isNotEmpty) return formatted;
    return '$currency ${amount.toStringAsFixed(2)}';
  }

  String? hourLabel(String? id) => _label(hours, id);

  String? dateLabel(String? id) => _label(dates, id);

  static String? initialId(List<SlotOption> slots) {
    for (final slot in slots) {
      if (slot.selectedInitially && slot.id.isNotEmpty) return slot.id;
    }
    for (final slot in slots) {
      if (slot.id.isNotEmpty) return slot.id;
    }
    return null;
  }

  static String? _label(List<SlotOption> slots, String? id) {
    if (id == null) return null;
    for (final slot in slots) {
      if (slot.id == id) return slot.label;
    }
    return null;
  }

  factory AppointmentDetails.fromJson(Map<String, dynamic> json) {
    final doctor = asMap(json['doctor']);
    final actions = asMap(doctor['actions']);
    final payment = asMap(json['payment']);
    final details = asMap(json['details']);
    final hours = asMap(json['workingHours']);
    final date = asMap(json['date']);
    final book = asMap(asMap(json['actions'])['bookAppointment']);
    return AppointmentDetails(
      title: json['title'] as String? ?? 'Appointment',
      doctorName: doctor['name'] as String? ?? '',
      clinic: doctor['clinic'] as String? ?? '',
      avatarUrl: doctor['avatarUrl'] as String? ?? '',
      canMessage: actions['message'] as bool? ?? false,
      canCall: actions['call'] as bool? ?? false,
      canVideoCall: actions['videoCall'] as bool? ?? false,
      paymentLabel: payment['label'] as String? ?? 'Payment',
      amount: (payment['amount'] as num?)?.toDouble() ?? 0,
      currency: payment['currency'] as String? ?? '',
      formatted: payment['formatted'] as String? ?? '',
      detailsTitle: details['title'] as String? ?? 'Details',
      description: details['description'] as String? ?? '',
      hoursTitle: hours['title'] as String? ?? 'Working Hours',
      showAllHours: hours['showAll'] as bool? ?? false,
      hours: [for (final item in asMapList(hours['slots'])) SlotOption.fromJson(item)],
      dateTitle: date['title'] as String? ?? 'Date',
      showAllDates: date['showAll'] as bool? ?? false,
      dates: [for (final item in asMapList(date['slots'])) SlotOption.fromJson(item)],
      bookLabel: book['label'] as String? ?? 'Book an Appointment',
      bookEnabled: book['enabled'] as bool? ?? true,
    );
  }
}
