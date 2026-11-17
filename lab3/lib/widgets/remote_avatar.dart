import 'package:flutter/material.dart';
import 'package:lab2/core/app_colors.dart';

class RemoteAvatar extends StatelessWidget {
  const RemoteAvatar({
    super.key,
    required this.name,
    required this.url,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  final String name;
  final String url;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final asset = _fallbackAssetFor(name);
    final image = url.isEmpty
        ? _assetOrInitials(asset)
        : Image.network(
            url,
            width: width,
            height: height,
            fit: BoxFit.cover,
            semanticLabel: name,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const ColoredBox(color: Color(0xFFE8EEF0));
            },
            errorBuilder: (context, error, stackTrace) => _assetOrInitials(asset),
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(width: width, height: height, child: image),
    );
  }

  Widget _assetOrInitials(String? asset) {
    if (asset == null) return _initialsBox();
    return Image.asset(
      asset,
      width: width,
      height: height,
      fit: BoxFit.cover,
      semanticLabel: name,
      errorBuilder: (context, error, stackTrace) => _initialsBox(),
    );
  }

  Widget _initialsBox() {
    return ColoredBox(
      color: const Color(0xFFE8EEF0),
      child: Center(
        child: Text(
          _initials(name),
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
      ),
    );
  }
}

String? _fallbackAssetFor(String name) {
  final value = name.toLowerCase();
  if (value.contains('jonathan')) return 'assets/frame.png';
  if (value.contains('emmly')) return 'assets/Ellipse 142.png';
  if (value.contains('sonja')) return 'assets/Ellipse 142 (1).png';
  if (value.contains('richar')) return 'assets/Rectangle 22454.png';
  if (value.contains('upul')) return 'assets/Rectangle 35.png';
  return null;
}

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty);
  final buffer = StringBuffer();
  for (final part in parts) {
    buffer.write(part[0]);
    if (buffer.length == 2) break;
  }
  final text = buffer.toString().toUpperCase();
  return text.isEmpty ? '?' : text;
}
