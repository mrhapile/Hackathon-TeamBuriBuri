import 'profile_model.dart';

class StoryModel {
  final String id;
  final String userId;
  final String? mediaUrl;
  final DateTime createdAt;
  final DateTime expiresAt;
  final ProfileModel? user;

  StoryModel({
    required this.id,
    required this.userId,
    this.mediaUrl,
    required this.createdAt,
    required this.expiresAt,
    this.user,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      mediaUrl: json['media_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      user: json['profiles'] != null ? ProfileModel.fromJson(json['profiles']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'media_url': mediaUrl,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
    };
  }
}
