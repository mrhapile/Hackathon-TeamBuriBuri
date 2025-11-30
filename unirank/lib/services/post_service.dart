import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post_model.dart';

class PostService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchPosts() async {
    try {
      final response = await _supabase
          .from('posts')
          .select('*, profiles(*), likes(count), comments(count)')
          .order('created_at', ascending: false);
      
      // Supabase returns a List<dynamic>. We cast it to List<Map<String, dynamic>>
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }

  Future<void> createPost({
    required String title,
    required String description,
    required String? mediaUrl,
    required String college,
    required String category,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await _supabase.from('posts').insert({
      'user_id': user.id,
      'college': college,
      'category': category,
      'title': title,
      'description': description,
      'media_url': mediaUrl,
    });
  }
}
