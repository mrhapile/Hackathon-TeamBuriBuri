import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/story_model.dart';

class StoryService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchStories() async {
    try {
      final response = await _supabase
          .from('stories')
          .select('*, profiles(*)')
          .gt('expires_at', DateTime.now().toIso8601String())
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching stories: $e');
      return [];
    }
  }

  Future<void> addStory(String mediaUrl) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    final createdAt = DateTime.now();
    final expiresAt = createdAt.add(const Duration(hours: 24));

    await _supabase.from('stories').insert({
      'user_id': user.id,
      'media_url': mediaUrl,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
    });
  }
}
