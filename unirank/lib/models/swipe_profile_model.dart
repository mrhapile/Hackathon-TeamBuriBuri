class SwipeProfileModel {
  final String id;
  final String name;
  final String? branch;
  final String? year;
  final String? college;
  final String? avatarUrl;
  final String? postImage;
  final String? postDesc;
  final List<String> postTags;

  SwipeProfileModel({
    required this.id,
    required this.name,
    this.branch,
    this.year,
    this.college,
    this.avatarUrl,
    this.postImage,
    this.postDesc,
    required this.postTags,
  });

  factory SwipeProfileModel.fromJson(Map<String, dynamic> json) {
    return SwipeProfileModel(
      id: json['profile_id'] as String,
      name: json['name'] as String,
      branch: json['branch'] as String?,
      year: json['year'] as String?,
      college: json['college'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      postImage: json['post_image'] as String?,
      postDesc: json['post_desc'] as String?,
      postTags: (json['post_tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }
}
