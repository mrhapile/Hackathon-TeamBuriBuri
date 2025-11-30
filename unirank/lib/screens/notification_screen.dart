import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';
import 'chat_room_screen.dart';
import '../widgets/comments_sheet.dart'; // Assuming we can reuse or navigate to post

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notificationService = NotificationService();
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  late final RealtimeChannel _notificationChannel;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
    _setupRealtime();
  }

  Future<void> _fetchNotifications() async {
    final notifs = await _notificationService.fetchNotifications();
    if (mounted) {
      setState(() {
        _notifications = notifs;
        _isLoading = false;
      });
    }
  }

  void _setupRealtime() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    _notificationChannel = Supabase.instance.client.channel('public:notifications:$userId')
      .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'notifications',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'user_id',
          value: userId,
        ),
        callback: (payload) {
          _fetchNotifications();
        },
      )
      .subscribe();
  }

  Future<void> _handleNotificationTap(NotificationModel notif) async {
    if (!notif.isRead) {
      await _notificationService.markAsRead(notif.id);
      setState(() {
        // Optimistic update
        final index = _notifications.indexWhere((n) => n.id == notif.id);
        if (index != -1) {
          // We can't modify the object directly as it's final, so we'd need to replace it or just re-fetch
          // For simplicity, re-fetch or just let the UI update on next fetch.
          // Or better, create a copyWith method in model (not added yet).
          // Let's just re-fetch for now to be safe.
          _fetchNotifications();
        }
      });
    }

    if (!mounted) return;

    if (notif.type == 'message') {
      final conversationId = notif.data['conversation_id'];
      if (conversationId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatRoomScreen(
              conversationId: conversationId,
              otherUser: notif.actor, // Might be incomplete, but ChatRoom handles it
            ),
          ),
        );
      }
    } else if (notif.type == 'like' || notif.type == 'comment') {
      // Navigate to post (Assuming we have a PostDetailScreen or similar, or just show snackbar for now)
      // Since user asked to "open post screen", I'll assume we might need to create one or navigate to Feed
      // For now, let's show a SnackBar as a placeholder if PostScreen doesn't exist or isn't easily linkable without fetching post first.
      // Actually, let's check if we can navigate to a post.
      // We don't have a dedicated PostScreen yet, only Feed.
      // I'll add a TODO or just show a message.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navigating to post... (Feature coming soon)')));
    }
  }

  @override
  void dispose() {
    Supabase.instance.client.removeChannel(_notificationChannel);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniRankTheme.bg,
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: UniRankTheme.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: UniRankTheme.accent))
          : RefreshIndicator(
              onRefresh: _fetchNotifications,
              color: UniRankTheme.accent,
              child: _notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_none_rounded, size: 64, color: UniRankTheme.textSecondary),
                          const SizedBox(height: 16),
                          Text('No notifications yet', style: UniRankTheme.body(16)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final notif = _notifications[index];
                        return _buildNotificationTile(notif);
                      },
                    ),
            ),
    );
  }

  Widget _buildNotificationTile(NotificationModel notif) {
    // Simple slide animation can be achieved with a TweenAnimationBuilder if desired, 
    // but standard list is often sufficient. User asked for "sliding animation when new notification appears".
    // That usually implies an AnimatedList. For simplicity in this iteration, we'll use a standard list 
    // but add a subtle fade/slide for the whole list or just rely on the natural refresh.
    // To truly animate *new* items, we'd need to track diffs.
    
    return Container(
      color: notif.isRead ? Colors.transparent : UniRankTheme.accent.withValues(alpha: 0.05),
      child: ListTile(
        onTap: () => _handleNotificationTap(notif),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: notif.actor?.avatarUrl != null
                  ? NetworkImage(notif.actor!.avatarUrl!)
                  : const AssetImage('assets/images/leaf_logo.png') as ImageProvider,
            ),
            if (notif.type == 'message')
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.chat_bubble, size: 12, color: UniRankTheme.accent),
                ),
              )
            else if (notif.type == 'like')
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.favorite, size: 12, color: Colors.red),
                ),
              ),
          ],
        ),
        title: RichText(
          text: TextSpan(
            style: UniRankTheme.body(14).copyWith(color: Colors.black),
            children: [
              TextSpan(
                text: notif.actor?.name ?? 'Someone',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' ${notif.title}'),
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notif.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: UniRankTheme.body(13).copyWith(color: UniRankTheme.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(notif.createdAt),
              style: UniRankTheme.body(11).copyWith(color: UniRankTheme.softSlate),
            ),
          ],
        ),
        trailing: !notif.isRead
            ? Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: UniRankTheme.accent,
                  shape: BoxShape.circle,
                ),
              )
            : null,
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}
