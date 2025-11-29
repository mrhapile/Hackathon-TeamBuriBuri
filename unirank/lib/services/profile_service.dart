import 'package:supabase_flutter/supabase_flutter.dart';
import '../profile/user_profile.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<UserProfile?> fetchProfile(String userId) async {
    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return UserProfile.fromJson(data);
    } catch (e) {
      // Return null or rethrow depending on how we want to handle it
      return null;
    }
  }

  Future<UserProfile?> getCurrentProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    return fetchProfile(user.id);
  }

  Future<Map<DateTime, int>> fetchContributions(String userId) async {
    try {
      final response = await _supabase
          .from('contributions')
          .select()
          .eq('user_id', userId);
      
      final data = response as List<dynamic>;
      final Map<DateTime, int> contributions = {};
      for (var item in data) {
        final date = DateTime.parse(item['date'] as String);
        final count = item['count'] as int;
        final normalizedDate = DateTime(date.year, date.month, date.day);
        contributions[normalizedDate] = (contributions[normalizedDate] ?? 0) + count;
      }
      return contributions;
    } catch (e) {
      print('Error fetching contributions: $e');
      return {};
    }
  }
}
