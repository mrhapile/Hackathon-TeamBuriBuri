import '../profile/user_profile.dart';

class Post {
  final String id;
  final String userId;
  final String collegeId;
  final String imageUrl;
  final String title;
  final String description;
  final List<String> tags;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  final UserProfile? user;
  final bool isLiked; // For UI state

  Post({
    required this.id,
    required this.userId,
    required this.collegeId,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.tags,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
    this.user,
    this.isLiked = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      collegeId: json['college_id'] as String,
      imageUrl: json['image_url'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      tags: List<String>.from(json['tags'] ?? []),
      likesCount: json['likes_count'] as int? ?? 0,
      commentsCount: json['comments_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      user: json['profiles'] != null ? UserProfile.fromJson(json['profiles']) : null,
      isLiked: json['is_liked'] as bool? ?? false,
    );
  }
}

class Story {
  final String id;
  final UserProfile user;
  final String imageUrl;

  Story({
    required this.id,
    required this.user,
    required this.imageUrl,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] as String,
      user: UserProfile.fromJson(json['profiles']),
      imageUrl: json['image_url'] as String,
    );
  }
}

class Comment {
  final String id;
  final String postId;
  final UserProfile user;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.postId,
    required this.user,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      user: UserProfile.fromJson(json['profiles']),
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
