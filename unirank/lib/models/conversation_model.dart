import 'profile_model.dart';

class ConversationModel {
  final String id;
  final String user1;
  final String user2;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProfileModel? otherUser; // Helper to store the other participant's details
  final String? lastMessage; // Helper for UI preview

  ConversationModel({
    required this.id,
    required this.user1,
    required this.user2,
    required this.createdAt,
    required this.updatedAt,
    this.otherUser,
    this.lastMessage,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json, {String? currentUserId}) {
    ProfileModel? otherUserProfile;
    
    // Logic to extract the "other" user from the joined profile data
    // Supabase join usually returns `user1:profiles(...)` or similar if aliased, 
    // or we might fetch it separately. For now, let's assume standard join structure 
    // or that we will populate it in the service.
    
    return ConversationModel(
      id: json['id'] as String,
      user1: json['user1'] as String,
      user2: json['user2'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      // otherUser will be populated by the service
    );
  }
}
