import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab2/core/app_colors.dart';
import 'package:lab2/state/medical_cubit.dart';
import 'package:lab2/state/medical_state.dart';

Future<void> showDoctorFilters(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => const DoctorFilterSheet(),
  );
}

class DoctorFilterSheet extends StatelessWidget {
  const DoctorFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicalCubit, MedicalState>(
      builder: (context, state) {
        final cubit = context.read<MedicalCubit>();
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.75,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Filter and sort',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                    children: [
                      const _SheetLabel('Sort'),
                      for (final option in DoctorSort.values)
                        _FilterOption(
                          label: option.label,
                          selected: state.sort == option,
                          onTap: () => cubit.setSort(option),
                        ),
                      const _SheetLabel('Specialty'),
                      _FilterOption(
                        label: 'All specialties',
                        selected: state.specialtyFilter == null,
                        onTap: () => cubit.setSpecialty(null),
                      ),
                      for (final specialty in state.specialties)
                        _FilterOption(
                          label: specialty,
                          selected: state.specialtyFilter == specialty,
                          onTap: () => cubit.setSpecialty(specialty),
                        ),
                      const _SheetLabel('Service'),
                      _FilterOption(
                        label: 'All services',
                        selected: state.serviceFilter == null,
                        onTap: () => cubit.setService(null),
                      ),
                      for (final service in state.services)
                        _FilterOption(
                          label: service.name,
                          selected: state.serviceFilter == service.id,
                          onTap: () => cubit.setService(service.id),
                        ),
                      SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        title: const Text('Favorites only'),
                        value: state.favoritesOnly,
                        activeThumbColor: AppColors.primary,
                        onChanged: cubit.setFavoritesOnly,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: state.hasActiveFilters ? cubit.clearFilters : null,
                          child: const Text('Clear'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Done'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SheetLabel extends StatelessWidget {
  const _SheetLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

class _FilterOption extends StatelessWidget {
  const _FilterOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(
        selected ? Icons.check_circle : Icons.circle_outlined,
        color: selected ? AppColors.primary : AppColors.muted,
      ),
      title: Text(label),
      onTap: onTap,
    );
  }
}
