class UserProfile {
  const UserProfile({
    required this.name,
    required this.greeting,
    required this.subtitle,
    required this.avatarUrl,
  });

  final String name;
  final String greeting;
  final String subtitle;
  final String avatarUrl;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? '',
      greeting: json['greeting'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
    );
  }
}
