import 'profile_model.dart';

class PostModel {
  final String id;
  final String userId;
  final String? college;
  final String? category;
  final String title;
  final String description;
  final String? mediaUrl;
  final DateTime createdAt;
  final ProfileModel? user;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;

  PostModel({
    required this.id,
    required this.userId,
    this.college,
    this.category,
    required this.title,
    required this.description,
    this.mediaUrl,
    required this.createdAt,
    this.user,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      college: json['college'] as String?,
      category: json['category'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      mediaUrl: json['media_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      user: json['profiles'] != null ? ProfileModel.fromJson(json['profiles']) : null,
      likesCount: json['likes'] is List ? (json['likes'] as List).length : (json['likes'] is Map ? (json['likes']['count'] as int? ?? 0) : 0),
      commentsCount: json['comments'] is List ? (json['comments'] as List).length : (json['comments'] is Map ? (json['comments']['count'] as int? ?? 0) : 0),
      // isLiked logic usually requires checking a separate list or the join, for now default false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'college': college,
      'category': category,
      'title': title,
      'description': description,
      'media_url': mediaUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
  String? get imageUrl => mediaUrl;
}
