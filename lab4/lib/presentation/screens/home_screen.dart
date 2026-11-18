import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab2/core/app_colors.dart';
import 'package:lab2/presentation/screens/appointment_screen.dart';
import 'package:lab2/presentation/screens/doctor_details_screen.dart';
import 'package:lab2/presentation/screens/doctors_screen.dart';
import 'package:lab2/presentation/state/medical_cubit.dart';
import 'package:lab2/presentation/state/medical_state.dart';
import 'package:lab2/presentation/widgets/app_search_field.dart';
import 'package:lab2/presentation/widgets/appointment_card.dart';
import 'package:lab2/presentation/widgets/doctor_card.dart';
import 'package:lab2/presentation/widgets/doctor_filter_sheet.dart';
import 'package:lab2/presentation/widgets/remote_avatar.dart';
import 'package:lab2/presentation/widgets/section_header.dart';
import 'package:lab2/presentation/widgets/service_tile.dart';
import 'package:lab2/presentation/widgets/status_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<MedicalCubit, MedicalState>(
          builder: (context, state) {
            if (state.status == PageStatus.loading) {
              return const StatusBody(status: PageStatus.loading, child: SizedBox.shrink());
            }
            if (state.status == PageStatus.error) {
              return StatusBody(
                status: PageStatus.error,
                message: state.errorMessage,
                onRetry: () => context.read<MedicalCubit>().load(),
                child: const SizedBox.shrink(),
              );
            }
            return const _HomeContent();
          },
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicalCubit, MedicalState>(
      builder: (context, state) {
        final user = state.user;
        final appointment = state.appointment;
        if (user == null || appointment == null) {
          return StatusBody(
            status: PageStatus.error,
            message: 'The server response is missing the home screen data.',
            onRetry: () => context.read<MedicalCubit>().load(),
            child: const SizedBox.shrink(),
          );
        }

        final cubit = context.read<MedicalCubit>();
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                RemoteAvatar(
                  name: user.name,
                  url: user.avatarUrl,
                  width: 44,
                  height: 44,
                  borderRadius: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.greeting,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Reload. Hold to simulate an error.',
                  onPressed: cubit.load,
                  onLongPress: () => cubit.load(fail: true),
                  icon: const Icon(Icons.refresh, color: Colors.black87),
                ),
                _NotificationButton(hasUnread: state.hasUnreadNotifications),
              ],
            ),
            const SizedBox(height: 20),
            AppSearchField(
              hint: state.searchHint,
              query: state.query,
              onChanged: cubit.setQuery,
              onFilter: () => showDoctorFilters(context),
            ),
            if (state.hasActiveFilters) ...[
              const SizedBox(height: 12),
              _ActiveFiltersBanner(onClear: cubit.clearFilters),
            ],
            const SizedBox(height: 20),
            AppointmentCard(
              appointment: appointment,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (_) => const AppointmentScreen()),
              ),
            ),
            const SizedBox(height: 24),
            SectionHeader(
              title: 'Health Services',
              actionLabel: 'See All',
              onAction: () {
                cubit.clearService();
                _openDoctors(context);
              },
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final service in state.services) ...[
                    ServiceTile(
                      service: service,
                      selected: state.serviceFilter == service.id,
                      onTap: () {
                        cubit.setService(service.id);
                        _openDoctors(context);
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            SectionHeader(
              title: 'Nearby Doctor',
              actionLabel: 'See All',
              onAction: () {
                cubit.clearService();
                _openDoctors(context);
              },
            ),
            const SizedBox(height: 10),
            if (state.catalogStatus == PageStatus.empty)
              StatusBody(
                status: PageStatus.empty,
                fill: false,
                message: state.emptyMessage,
                onClear: state.hasActiveFilters ? cubit.clearFilters : null,
                child: const SizedBox.shrink(),
              )
            else
              for (final doctor in state.visibleDoctors)
                DoctorCard(
                  doctor: doctor,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => DoctorDetailsScreen(doctorId: doctor.id),
                    ),
                  ),
                  onFavorite: () => cubit.toggleFavorite(doctor.id),
                ),
          ],
        );
      },
    );
  }

  void _openDoctors(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const DoctorsScreen()),
    );
  }
}

class _ActiveFiltersBanner extends StatelessWidget {
  const _ActiveFiltersBanner({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        dense: true,
        title: const Text('Filters are active'),
        trailing: TextButton(onPressed: onClear, child: const Text('Clear')),
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({required this.hasUnread});

  final bool hasUnread;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        children: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Notifications'),
                  content: Text(
                    hasUnread
                        ? 'You have a new update about your appointment.'
                        : 'You are all caught up.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
          ),
          if (hasUnread)
            const Positioned(
              right: 12,
              top: 12,
              child: SizedBox(
                width: 8,
                height: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
