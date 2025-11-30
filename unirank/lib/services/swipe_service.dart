import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/swipe_profile_model.dart';

class SwipeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<SwipeProfileModel>> fetchFeed() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    try {
      final response = await _supabase.rpc('get_swipe_feed', params: {
        'current_user_id': user.id,
      });

      final data = response as List<dynamic>;
      return data.map((json) => SwipeProfileModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching swipe feed: $e');
      return [];
    }
  }

  Future<bool> swipe({required String swipedId, required bool isLike}) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    try {
      // 1. Insert swipe
      await _supabase.from('swipes').insert({
        'swiper_id': user.id,
        'swiped_id': swipedId,
        'is_like': isLike,
      });

      // 2. Check for match if it's a like
      if (isLike) {
        final response = await _supabase
            .from('swipes')
            .select()
            .eq('swiper_id', swipedId)
            .eq('swiped_id', user.id)
            .eq('is_like', true)
            .maybeSingle();

        if (response != null) {
          // It's a match! Create conversation
          // Sort IDs to ensure consistent order for unique constraint
          final user1 = user.id.compareTo(swipedId) < 0 ? user.id : swipedId;
          final user2 = user.id.compareTo(swipedId) < 0 ? swipedId : user.id;

          await _supabase.from('conversations').insert({
            'user1': user1,
            'user2': user2,
          });
          
          return true; // Match found
        }
      }
    } catch (e) {
      print('Error processing swipe: $e');
    }
    return false; // No match
  }
}
