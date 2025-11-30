import 'package:supabase_flutter/supabase_flutter.dart';

class LikeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> toggleLike(String postId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final existing = await _supabase
        .from('likes')
        .select()
        .eq('post_id', postId)
        .eq('user_id', user.id)
        .maybeSingle();

    if (existing != null) {
      await _supabase
          .from('likes')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', user.id);
    } else {
      await _supabase.from('likes').insert({
        'post_id': postId,
        'user_id': user.id,
      });
    }
  }

  Future<bool> hasLiked(String postId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    final response = await _supabase
        .from('likes')
        .select()
        .eq('post_id', postId)
        .eq('user_id', user.id)
        .maybeSingle();
    
    return response != null;
  }
}
