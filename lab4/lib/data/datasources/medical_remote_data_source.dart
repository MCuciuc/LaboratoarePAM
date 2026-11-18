import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lab2/core/api_exception.dart';
import 'package:lab2/data/models/feed_dto.dart';

class MedicalRemoteDataSource {
  MedicalRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  static const feedUrl = 'https://test-api-jlbn.onrender.com/lab2026/v2/feed';
  static const detailsUrl = 'https://test-api-jlbn.onrender.com/lab2026/v2/feed/details';

  final http.Client _client;

  Future<FeedDto> fetchFeed() async {
    final json = await _get(feedUrl);
    return FeedDto.fromJson(json);
  }

  Future<AppointmentDetailsDto> fetchDetails() async {
    final json = await _get(detailsUrl);
    return AppointmentDetailsDto.fromJson(json);
  }

  Future<Map<String, dynamic>> _get(String url) async {
    final http.Response response;
    try {
      response = await _client.get(Uri.parse(url)).timeout(const Duration(seconds: 45));
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException('Could not reach the medical service. $error');
    }

    if (response.statusCode != 200) {
      throw ApiException('The medical service returned ${response.statusCode}.');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    throw ApiException('The medical service returned an unexpected response.');
  }
}
