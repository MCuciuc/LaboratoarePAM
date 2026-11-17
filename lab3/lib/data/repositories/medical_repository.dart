import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:lab2/data/models/medical_data.dart';

class MedicalRepository {
  const MedicalRepository({
    this.delay = const Duration(milliseconds: 800),
    this.assetPath = 'assets/lab v2.json',
  });

  /// Keeps the loading indicator on screen; the JSON itself is read locally.
  final Duration delay;
  final String assetPath;

  Future<MedicalData> load({bool fail = false}) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    if (fail) {
      throw Exception('Simulated failure while loading the JSON asset.');
    }

    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      throw const FormatException('The asset is not a JSON object.');
    }
    return MedicalData.fromJson(Map<String, dynamic>.from(decoded));
  }
}
