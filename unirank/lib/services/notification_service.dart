import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notification_model.dart';

class NotificationService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<NotificationModel>> fetchNotifications() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    try {
      final response = await _supabase
          .from('notifications')
          .select('*, profiles!notifications_actor_id_fkey(*)') // Join with actor profile
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      final data = response as List<dynamic>;
      return data.map((json) => NotificationModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  Future<int> getUnreadCount() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return 0;

    try {
      final response = await _supabase
          .from('notifications')
          .count(CountOption.exact)
          .eq('user_id', user.id)
          .eq('is_read', false);
      
      return response;
    } catch (e) {
      print('Error counting unread notifications: $e');
      return 0;
    }
  }
}
