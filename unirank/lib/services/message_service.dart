import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/message_model.dart';

class MessageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<MessageModel>> fetchMessages(String conversationId) async {
    try {
      final response = await _supabase
          .from('messages')
          .select('*, profiles(*)')
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: true); // Oldest first for chat history

      final data = response as List<dynamic>;
      return data.map((json) => MessageModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching messages: $e');
      return [];
    }
  }

  Future<void> sendMessage({
    required String conversationId,
    String? text,
    File? imageFile,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');
    if (text == null && imageFile == null) return;

    String? imageUrl;
    if (imageFile != null) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${user.id}.jpg';
      await _supabase.storage.from('chat_images').upload(fileName, imageFile);
      imageUrl = _supabase.storage.from('chat_images').getPublicUrl(fileName);
    }

    await _supabase.from('messages').insert({
      'conversation_id': conversationId,
      'sender_id': user.id,
      'text': text,
      'image_url': imageUrl,
    });
  }

  Future<void> markAsSeen(String conversationId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    // Mark all messages in this conversation sent by the OTHER user as seen
    // We can't easily filter by "not me" in a simple update without a where clause
    // So we update where conversation_id matches and sender_id != me
    
    await _supabase
        .from('messages')
        .update({'seen': true})
        .eq('conversation_id', conversationId)
        .neq('sender_id', user.id)
        .eq('seen', false);
  }
}
