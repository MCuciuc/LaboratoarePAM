import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab2/core/app_colors.dart';
import 'package:lab2/presentation/screens/doctor_details_screen.dart';
import 'package:lab2/presentation/state/medical_cubit.dart';
import 'package:lab2/presentation/state/medical_state.dart';
import 'package:lab2/presentation/widgets/app_search_field.dart';
import 'package:lab2/presentation/widgets/doctor_card.dart';
import 'package:lab2/presentation/widgets/doctor_filter_sheet.dart';
import 'package:lab2/presentation/widgets/status_body.dart';

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors'),
        actions: [
          BlocBuilder<MedicalCubit, MedicalState>(
            builder: (context, state) {
              final cubit = context.read<MedicalCubit>();
              return Row(
                children: [
                  IconButton(
                    tooltip: 'Favorites',
                    onPressed: () => cubit.setFavoritesOnly(!state.favoritesOnly),
                    icon: Icon(
                      state.favoritesOnly ? Icons.favorite : Icons.favorite_border,
                      color: state.favoritesOnly ? Colors.redAccent : AppColors.primary,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Filter and sort',
                    onPressed: () => showDoctorFilters(context),
                    icon: const Icon(Icons.tune),
                  ),
                  IconButton(
                    tooltip: 'Reload. Hold to simulate an error.',
                    onPressed: cubit.load,
                    onLongPress: () => cubit.load(fail: true),
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<MedicalCubit, MedicalState>(
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

          final cubit = context.read<MedicalCubit>();
          final doctors = state.visibleDoctors;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: AppSearchField(
                  hint: state.searchHint,
                  query: state.query,
                  onChanged: cubit.setQuery,
                  onFilter: () => showDoctorFilters(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Text(
                  '${doctors.length} doctors · Sorted by ${state.sort.label}',
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ),
              if (state.specialtyFilter != null || state.serviceFilter != null || state.favoritesOnly)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (state.specialtyFilter != null)
                        InputChip(
                          label: Text(state.specialtyFilter!),
                          onDeleted: () => cubit.setSpecialty(null),
                        ),
                      if (state.activeServiceName != null)
                        InputChip(
                          label: Text(state.activeServiceName!),
                          onDeleted: () => cubit.setService(null),
                        ),
                      if (state.favoritesOnly)
                        InputChip(
                          label: const Text('Favorites'),
                          onDeleted: () => cubit.setFavoritesOnly(false),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              Expanded(
                child: state.catalogStatus == PageStatus.empty
                    ? StatusBody(
                        status: PageStatus.empty,
                        message: state.emptyMessage,
                        onClear: state.hasActiveFilters ? cubit.clearFilters : null,
                        child: const SizedBox.shrink(),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        children: [
                          for (final doctor in doctors)
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
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
