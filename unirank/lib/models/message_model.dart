import 'profile_model.dart';

class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String? text;
  final String? imageUrl;
  final bool seen;
  final DateTime createdAt;
  final ProfileModel? sender;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.text,
    this.imageUrl,
    required this.seen,
    required this.createdAt,
    this.sender,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      senderId: json['sender_id'] as String,
      text: json['text'] as String?,
      imageUrl: json['image_url'] as String?,
      seen: json['seen'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      sender: json['profiles'] != null ? ProfileModel.fromJson(json['profiles']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'text': text,
      'image_url': imageUrl,
      'seen': seen,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
