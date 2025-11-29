class UserProfile {
  final String id;
  final String fullName;
  final String? avatarUrl;
  final String? college;
  final String? branch;
  final String? year;

  UserProfile({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    this.college,
    this.branch,
    this.year,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? 'Unknown',
      avatarUrl: json['avatar_url'] as String?,
      college: json['college'] as String?,
      branch: json['branch'] as String?,
      year: json['year'] as String?,
    );
  }
}
