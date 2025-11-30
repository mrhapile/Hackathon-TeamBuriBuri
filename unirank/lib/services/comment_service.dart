import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/comment_model.dart';

class CommentService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchComments(String postId) async {
    try {
      final response = await _supabase
          .from('comments')
          .select('*, profiles(*)')
          .eq('post_id', postId)
          .order('created_at', ascending: true);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching comments: $e');
      return [];
    }
  }

  Future<void> addComment(String postId, String text) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await _supabase.from('comments').insert({
      'post_id': postId,
      'user_id': user.id,
      'text': text,
    });
  }
}
