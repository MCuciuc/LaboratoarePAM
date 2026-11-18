import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab2/core/app_colors.dart';
import 'package:lab2/presentation/state/medical_cubit.dart';
import 'package:lab2/presentation/state/medical_state.dart';
import 'package:lab2/presentation/widgets/remote_avatar.dart';
import 'package:lab2/presentation/widgets/section_header.dart';
import 'package:lab2/presentation/widgets/slot_selector.dart';
import 'package:lab2/presentation/widgets/status_body.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedicalCubit, MedicalState>(
      listenWhen: (previous, current) =>
          previous.bookingStatus != current.bookingStatus &&
          (current.bookingStatus == BookingStatus.success ||
              current.bookingStatus == BookingStatus.failure),
      listener: (context, state) {
        final message = state.bookingMessage;
        if (message != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        }
        context.read<MedicalCubit>().acknowledgeBooking();
      },
      builder: (context, state) {
        final details = state.details;
        return Scaffold(
          appBar: AppBar(title: Text(details?.title ?? 'Appointment')),
          body: state.status == PageStatus.loading
              ? const StatusBody(status: PageStatus.loading, child: SizedBox.shrink())
              : details == null
              ? StatusBody(
                  status: PageStatus.error,
                  message: 'Appointment details are missing from the server response.',
                  onRetry: () => context.read<MedicalCubit>().load(),
                  child: const SizedBox.shrink(),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RemoteAvatar(
                          name: details.doctorName,
                          url: details.avatarUrl,
                          width: 80,
                          height: 90,
                          borderRadius: 15,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      details.doctorName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  if (details.canMessage)
                                    _RoundAction(
                                      icon: Icons.chat_bubble_outline,
                                      tooltip: 'Message',
                                      onPressed: () => _notify(context, 'Message ${details.doctorName}'),
                                    ),
                                  if (details.canCall)
                                    _RoundAction(
                                      icon: Icons.phone_outlined,
                                      tooltip: 'Call',
                                      onPressed: () => _notify(context, 'Call ${details.clinic}'),
                                    ),
                                  if (details.canVideoCall)
                                    _RoundAction(
                                      icon: Icons.videocam_outlined,
                                      tooltip: 'Video call',
                                      onPressed: () => _notify(context, 'Video call ${details.doctorName}'),
                                    ),
                                ],
                              ),
                              Text(
                                details.clinic,
                                style: const TextStyle(color: AppColors.primary, fontSize: 12),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      details.paymentLabel,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    details.priceLabel,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      details.detailsTitle,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      details.description,
                      style: const TextStyle(color: AppColors.muted, height: 1.4),
                    ),
                    const SizedBox(height: 24),
                    SectionHeader(
                      title: details.hoursTitle,
                      actionLabel: details.showAllHours ? 'See All' : null,
                      onAction: () => _showSlots(
                        context,
                        title: details.hoursTitle,
                        labels: [for (final slot in details.hours) (slot.id, slot.label)],
                        selectedId: state.selectedTimeSlotId,
                        onSelected: context.read<MedicalCubit>().selectTime,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SlotSelector(
                      slots: details.hours,
                      selectedId: state.selectedTimeSlotId,
                      onSelected: context.read<MedicalCubit>().selectTime,
                    ),
                    const SizedBox(height: 24),
                    SectionHeader(
                      title: details.dateTitle,
                      actionLabel: details.showAllDates ? 'See All' : null,
                      onAction: () => _showSlots(
                        context,
                        title: details.dateTitle,
                        labels: [for (final slot in details.dates) (slot.id, slot.label)],
                        selectedId: state.selectedDateSlotId,
                        onSelected: context.read<MedicalCubit>().selectDate,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SlotSelector(
                      slots: details.dates,
                      selectedId: state.selectedDateSlotId,
                      onSelected: context.read<MedicalCubit>().selectDate,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _summary(state),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: details.bookEnabled
                          ? () => context.read<MedicalCubit>().bookAppointment()
                          : null,
                      child: state.bookingStatus == BookingStatus.submitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text(details.bookLabel),
                    ),
                  ],
                ),
        );
      },
    );
  }

  String _summary(MedicalState state) {
    final details = state.details;
    if (details == null) return '';
    final date = details.dateLabel(state.selectedDateSlotId);
    final time = details.hourLabel(state.selectedTimeSlotId);
    if (date == null || time == null) return 'Select a date and a working hour.';
    return '$date · $time · ${details.priceLabel}';
  }
}

void _notify(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

void _showSlots(
  BuildContext context, {
  required String title,
  required List<(String, String)> labels,
  required String? selectedId,
  required ValueChanged<String> onSelected,
}) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            for (final (id, label) in labels)
              ListTile(
                title: Text(label),
                trailing: id == selectedId
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  onSelected(id);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      );
    },
  );
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xFFEFEFEF),
        foregroundColor: Colors.black87,
        fixedSize: const Size(34, 34),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
