import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/conversation_service.dart';
import '../models/conversation_model.dart';
import '../services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'chat_room_screen.dart';
import '../widgets/empty_chat_view.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ConversationService _conversationService = ConversationService();
  List<ConversationModel> _conversations = [];
  bool _isLoading = true;

  late final RealtimeChannel _conversationsChannel;

  @override
  void initState() {
    super.initState();
    _fetchConversations();
    _setupRealtime();
  }

  void _setupRealtime() {
    _conversationsChannel = Supabase.instance.client.channel('public:conversations')
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'conversations',
        callback: (payload) {
          _fetchConversations();
        },
      )
      .subscribe();
  }

  Future<void> _fetchConversations() async {
    final convs = await _conversationService.fetchMyConversations();
    if (mounted) {
      setState(() {
        _conversations = convs;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    Supabase.instance.client.removeChannel(_conversationsChannel);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniRankTheme.bg,
      appBar: AppBar(
        title: const Text('Messages', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28)),
        backgroundColor: UniRankTheme.bg,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: UniRankTheme.accent))
          : Column(
              children: [
                // Active Users (Stories Style)
                if (_conversations.isNotEmpty)
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _conversations.length,
                      itemBuilder: (context, index) {
                        final conv = _conversations[index];
                        final otherUser = conv.otherUser;
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: UniRankTheme.accent, width: 2),
                                ),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: otherUser?.avatarUrl != null
                                      ? NetworkImage(otherUser!.avatarUrl!)
                                      : const AssetImage('assets/images/leaf_logo.png') as ImageProvider,
                                ),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: 70,
                                child: Text(
                                  otherUser?.name.split(' ').first ?? 'User',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: UniRankTheme.body(12).copyWith(color: Colors.black, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                
                // Chat List
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                    ),
                    child: _conversations.isEmpty
                        ? const EmptyChatView()
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 80),
                            itemCount: _conversations.length,
                            itemBuilder: (context, index) {
                              final conv = _conversations[index];
                              final otherUser = conv.otherUser;
                              
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChatRoomScreen(
                                        conversationId: conv.id,
                                        otherUser: otherUser,
                                      ),
                                    ),
                                  ).then((_) => _fetchConversations());
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 28,
                                        backgroundImage: otherUser?.avatarUrl != null
                                            ? NetworkImage(otherUser!.avatarUrl!)
                                            : const AssetImage('assets/images/leaf_logo.png') as ImageProvider,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  otherUser?.name ?? 'Unknown User',
                                                  style: UniRankTheme.heading(16),
                                                ),
                                                Text(
                                                  _formatDate(conv.updatedAt),
                                                  style: UniRankTheme.body(12).copyWith(color: UniRankTheme.softSlate),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    conv.lastMessage ?? 'Start chatting...',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: UniRankTheme.body(14).copyWith(
                                                      color: UniRankTheme.textSecondary,
                                                    ),
                                                  ),
                                                ),
                                                // Unread indicator (mock logic for now as 'seen' is on messages)
                                                // In a real app, we'd check count of unseen messages
                                                Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: const BoxDecoration(
                                                    color: UniRankTheme.accent,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic to start new chat (e.g. show user list)
          // For now, just show a snackbar or navigate to a user search screen if it existed
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a user from Profile or Search')));
        },
        backgroundColor: UniRankTheme.accent,
        child: const Icon(Icons.add_comment_rounded, color: Colors.white),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
    return '${date.day}/${date.month}';
  }
}
