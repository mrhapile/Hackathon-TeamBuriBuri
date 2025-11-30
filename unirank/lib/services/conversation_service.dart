import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/conversation_model.dart';
import '../models/profile_model.dart';

class ConversationService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get or create a conversation between the current user and another user
  Future<String> getOrCreateConversation(String otherUserId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    // Ensure user1 < user2 for uniqueness
    final String user1 = (user.id.compareTo(otherUserId) < 0) ? user.id : otherUserId;
    final String user2 = (user.id.compareTo(otherUserId) < 0) ? otherUserId : user.id;

    // Check if conversation exists
    final existing = await _supabase
        .from('conversations')
        .select()
        .eq('user1', user1)
        .eq('user2', user2)
        .maybeSingle();

    if (existing != null) {
      return existing['id'] as String;
    }

    // Create new conversation
    final newConv = await _supabase
        .from('conversations')
        .insert({
          'user1': user1,
          'user2': user2,
        })
        .select()
        .single();

    return newConv['id'] as String;
  }

  // Fetch all conversations for the current user
  Future<List<ConversationModel>> fetchMyConversations() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    try {
      // Fetch conversations where current user is user1 OR user2
      final response = await _supabase
          .from('conversations')
          .select('''
            *,
            user1_profile:profiles!conversations_user1_fkey(*),
            user2_profile:profiles!conversations_user2_fkey(*)
          ''')
          .or('user1.eq.${user.id},user2.eq.${user.id}')
          .order('updated_at', ascending: false);

      final data = response as List<dynamic>;
      
      // We also need to fetch the last message for each conversation to show in the list
      // Ideally this would be a view or a joined query, but for simplicity we can fetch separately or rely on client-side logic if needed.
      // However, for a good UI, we need the last message.
      // Let's try to fetch the last message for each conversation.
      // A better approach for scalability is a DB function or view, but let's iterate.
      
      List<ConversationModel> conversations = [];

      for (var item in data) {
        final convId = item['id'] as String;
        final user1Id = item['user1'] as String;
        
        // Determine which profile is the "other" user
        final isUser1 = user.id == user1Id;
        final otherProfileJson = isUser1 ? item['user2_profile'] : item['user1_profile'];
        final otherProfile = otherProfileJson != null ? ProfileModel.fromJson(otherProfileJson) : null;

        // Fetch last message
        final lastMsgRes = await _supabase
            .from('messages')
            .select('text, image_url, created_at')
            .eq('conversation_id', convId)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle();
        
        String? lastMsgPreview;
        if (lastMsgRes != null) {
          if (lastMsgRes['text'] != null && (lastMsgRes['text'] as String).isNotEmpty) {
            lastMsgPreview = lastMsgRes['text'] as String;
          } else if (lastMsgRes['image_url'] != null) {
            lastMsgPreview = '📷 Image';
          }
        }

        conversations.add(ConversationModel(
          id: convId,
          user1: item['user1'],
          user2: item['user2'],
          createdAt: DateTime.parse(item['created_at']),
          updatedAt: DateTime.parse(item['updated_at']),
          otherUser: otherProfile,
          lastMessage: lastMsgPreview,
        ));
      }

      return conversations;
    } catch (e) {
      print('Error fetching conversations: $e');
      return [];
    }
  }
}
