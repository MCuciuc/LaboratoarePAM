import 'package:lab2/domain/entities/medical_feed.dart';

abstract class MedicalRepository {
  Future<MedicalFeed> load();
}
