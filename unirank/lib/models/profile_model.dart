class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? branch;
  final int? year;
  final String? college;
  final int attendance;
  final String? githubUsername;
  final String? leetcodeId;
  final String? codeforcesId;
  final DateTime createdAt;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.branch,
    this.year,
    this.college,
    this.attendance = 0,
    this.githubUsername,
    this.leetcodeId,
    this.codeforcesId,
    required this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unknown',
      email: json['email'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
      branch: json['branch'] as String?,
      year: json['year'] as int?,
      college: json['college'] as String?,
      attendance: json['attendance'] as int? ?? 0,
      githubUsername: json['github_username'] as String?,
      leetcodeId: json['leetcode_id'] as String?,
      codeforcesId: json['codeforces_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
      'branch': branch,
      'year': year,
      'college': college,
      'attendance': attendance,
      'github_username': githubUsername,
      'leetcode_id': leetcodeId,
      'codeforces_id': codeforcesId,
      'created_at': createdAt.toIso8601String(),
    };
  }
  String get fullName => name;
}
