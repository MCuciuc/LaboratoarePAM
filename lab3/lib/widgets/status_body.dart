import 'package:flutter/material.dart';
import 'package:lab2/core/app_colors.dart';
import 'package:lab2/state/medical_state.dart';

class StatusBody extends StatelessWidget {
  const StatusBody({
    super.key,
    required this.status,
    required this.child,
    this.message,
    this.onRetry,
    this.onClear,
    this.fill = true,
  });

  final PageStatus status;
  final Widget child;
  final String? message;
  final VoidCallback? onRetry;
  final VoidCallback? onClear;
  final bool fill;

  @override
  Widget build(BuildContext context) {
    if (status == PageStatus.success) return child;
    final content = _StatusMessage(
      status: status,
      message: message,
      onRetry: onRetry,
      onClear: onClear,
    );
    if (!fill) return content;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: content),
          ),
        );
      },
    );
  }
}

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({
    required this.status,
    this.message,
    this.onRetry,
    this.onClear,
  });

  final PageStatus status;
  final String? message;
  final VoidCallback? onRetry;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color color, String title) = switch (status) {
      PageStatus.loading => (Icons.hourglass_top, AppColors.primary, 'Loading data...'),
      PageStatus.empty => (Icons.search_off, AppColors.muted, 'No results'),
      PageStatus.error => (Icons.error_outline, Colors.redAccent, 'Could not load data'),
      PageStatus.success => (Icons.check_circle_outline, AppColors.primary, ''),
    };

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == PageStatus.loading)
            const CircularProgressIndicator()
          else
            Icon(icon, color: color, size: 48),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          if (message != null && message!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, height: 1.4),
            ),
          ],
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
          if (onClear != null) ...[
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onClear, child: const Text('Clear filters')),
          ],
        ],
      ),
    );
  }
}
