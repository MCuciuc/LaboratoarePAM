class Doctor {
  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.distance,
    required this.avatarUrl,
    required this.isFavorite,
  });

  final String id;
  final String name;
  final String specialty;
  final String distance;
  final String avatarUrl;
  final bool isFavorite;

  int get distanceMeters {
    final matches = RegExp(r'(\d+)\s*m', caseSensitive: false).allMatches(distance);
    if (matches.isEmpty) return 1 << 30;
    return int.tryParse(matches.last.group(1) ?? '') ?? (1 << 30);
  }

  Doctor copyWith({bool? isFavorite}) {
    return Doctor(
      id: id,
      name: name,
      specialty: specialty,
      distance: distance,
      avatarUrl: avatarUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
