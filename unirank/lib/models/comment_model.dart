import 'profile_model.dart';

class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String text;
  final DateTime createdAt;
  final ProfileModel? user;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.text,
    required this.createdAt,
    this.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      userId: json['user_id'] as String,
      text: json['text'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      user: json['profiles'] != null ? ProfileModel.fromJson(json['profiles']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'text': text,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
