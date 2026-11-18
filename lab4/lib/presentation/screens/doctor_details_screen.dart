import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab2/core/app_colors.dart';
import 'package:lab2/presentation/screens/appointment_screen.dart';
import 'package:lab2/presentation/state/medical_cubit.dart';
import 'package:lab2/presentation/state/medical_state.dart';
import 'package:lab2/presentation/widgets/remote_avatar.dart';
import 'package:lab2/presentation/widgets/status_body.dart';

class DoctorDetailsScreen extends StatelessWidget {
  const DoctorDetailsScreen({super.key, required this.doctorId});

  final String doctorId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor')),
      body: BlocBuilder<MedicalCubit, MedicalState>(
        builder: (context, state) {
          final doctor = state.doctorById(doctorId);
          if (doctor == null) {
            return const StatusBody(
              status: PageStatus.empty,
              message: 'This doctor is not in the loaded list.',
              child: SizedBox.shrink(),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: RemoteAvatar(
                  name: doctor.name,
                  url: doctor.avatarUrl,
                  width: 120,
                  height: 120,
                  borderRadius: 24,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                doctor.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                doctor.specialty,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.location_on, color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(doctor.distance)),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '${doctor.name} is a ${doctor.specialty}. '
                'Save the profile if you want it in favorites, or continue to the clinic appointment.',
                style: const TextStyle(color: AppColors.muted, height: 1.4),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => context.read<MedicalCubit>().toggleFavorite(doctor.id),
                icon: Icon(
                  doctor.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: doctor.isFavorite ? Colors.redAccent : AppColors.primary,
                ),
                label: Text(doctor.isFavorite ? 'Remove from favorites' : 'Add to favorites'),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => const AppointmentScreen()),
                ),
                child: const Text('Book an Appointment'),
              ),
            ],
          );
        },
      ),
    );
  }
}
