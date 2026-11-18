class SlotOption {
  const SlotOption({
    required this.id,
    required this.label,
    required this.selectedInitially,
  });

  final String id;
  final String label;
  final bool selectedInitially;
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
    required this.priceLabel,
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
  final String priceLabel;
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

  static String? initialId(List<SlotOption> slots) {
    for (final slot in slots) {
      if (slot.selectedInitially) return slot.id;
    }
    if (slots.isEmpty) return null;
    return slots.first.id;
  }

  String? hourLabel(String? id) => _label(hours, id);

  String? dateLabel(String? id) => _label(dates, id);

  String? _label(List<SlotOption> slots, String? id) {
    if (id == null) return null;
    for (final slot in slots) {
      if (slot.id == id) return slot.label;
    }
    return null;
  }
}
