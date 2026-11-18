import 'package:lab2/core/api_exception.dart';
import 'package:lab2/data/datasources/medical_remote_data_source.dart';
import 'package:lab2/domain/entities/medical_feed.dart';
import 'package:lab2/domain/repositories/medical_repository.dart';

class MedicalRepositoryImpl implements MedicalRepository {
  MedicalRepositoryImpl(this._remote);

  final MedicalRemoteDataSource _remote;

  @override
  Future<MedicalFeed> load() async {
    try {
      final (feed, details) = await (_remote.fetchFeed(), _remote.fetchDetails()).wait;
      return MedicalFeed(
        user: feed.user,
        hasUnreadNotifications: feed.hasUnreadNotifications,
        searchHint: feed.searchHint,
        appointment: feed.appointment,
        details: details.details,
        services: feed.services,
        doctors: feed.doctors,
      );
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException('Could not load medical data. $error');
    }
  }
}
