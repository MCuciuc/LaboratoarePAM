class Doctor {
  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.distance,
    required this.avatarUrl,
    required this.isFavorite,
    required this.distanceMeters,
  });

  final String id;
  final String name;
  final String specialty;
  final String distance;
  final String avatarUrl;
  final bool isFavorite;
  final int distanceMeters;

  factory Doctor.fromJson(Map<String, dynamic> json) {
    final distance = json['distance'] as String? ?? '';
    return Doctor(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      specialty: json['specialty'] as String? ?? '',
      distance: distance,
      avatarUrl: json['avatarUrl'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
      distanceMeters: metersFromDistance(distance),
    );
  }

  static int metersFromDistance(String distance) {
    final match = RegExp(r'(\d+)\s*m', caseSensitive: false).firstMatch(distance);
    return int.tryParse(match?.group(1) ?? '') ?? 1 << 30;
  }

  Doctor copyWith({bool? isFavorite}) {
    return Doctor(
      id: id,
      name: name,
      specialty: specialty,
      distance: distance,
      avatarUrl: avatarUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      distanceMeters: distanceMeters,
    );
  }
}
