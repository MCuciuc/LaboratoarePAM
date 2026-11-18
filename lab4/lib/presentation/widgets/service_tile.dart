import 'package:flutter/material.dart';
import 'package:lab2/core/app_colors.dart';
import 'package:lab2/domain/entities/health_service.dart';

class ServiceTile extends StatelessWidget {
  const ServiceTile({
    super.key,
    required this.service,
    required this.selected,
    required this.onTap,
  });

  final HealthService service;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary.withValues(alpha: 0.12) : AppColors.chip,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: selected ? AppColors.primary : Colors.transparent),
              ),
              child: Icon(_iconForService(service.id), color: Colors.orangeAccent),
            ),
            const SizedBox(height: 8),
            Text(
              service.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

/// The JSON stores remote SVG urls, which Flutter cannot paint without an extra package.
IconData _iconForService(String id) {
  switch (id) {
    case 'tooth':
      return Icons.cleaning_services_outlined;
    case 'eye':
      return Icons.remove_red_eye_outlined;
    case 'lungs':
      return Icons.air;
    case 'ear':
      return Icons.hearing_outlined;
    default:
      return Icons.medical_services_outlined;
  }
}
