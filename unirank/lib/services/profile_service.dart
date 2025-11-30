import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<ProfileModel?> fetchProfile(String userId) async {
    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return ProfileModel.fromJson(data);
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  Future<ProfileModel?> getCurrentProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    return fetchProfile(user.id);
  }

  Future<void> updateProfile(ProfileModel profile) async {
    await _supabase.from('profiles').update(profile.toJson()).eq('id', profile.id);
  }
}
