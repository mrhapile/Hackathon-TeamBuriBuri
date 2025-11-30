import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/contribution_model.dart';

class ContributionService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<ContributionModel>> fetchContributions(String userId) async {
    try {
      final response = await _supabase
          .from('contributions')
          .select()
          .eq('user_id', userId);
      
      final data = response as List<dynamic>;
      return data.map((json) => ContributionModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching contributions: $e');
      return [];
    }
  }
}
