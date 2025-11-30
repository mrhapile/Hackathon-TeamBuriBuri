import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme.dart';
import '../services/post_service.dart';
import '../services/story_service.dart';
import '../services/auth_service.dart';
import '../models/post_model.dart';
import '../models/story_model.dart';
import '../widgets/story_circle.dart';
import '../widgets/post_card.dart';
import '../widgets/filter_chip.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final PostService _postService = PostService();
  final StoryService _storyService = StoryService();
  
  List<PostModel> _posts = [];
  List<StoryModel> _stories = [];
  bool _isLoading = true;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Web Dev', 'AI/ML', 'App Dev', 'DSA', 'Cloud', 'Backend', 'Python'];

  late final RealtimeChannel _postsChannel;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _setupRealtime();
  }

  Future<void> _fetchData() async {
    try {
      final postsData = await _postService.fetchPosts();
      final storiesData = await _storyService.fetchStories();

      if (mounted) {
        setState(() {
          _posts = postsData.map((json) => PostModel.fromJson(json)).toList();
          _stories = storiesData.map((json) => StoryModel.fromJson(json)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading feed: $e')),
        );
      }
    }
  }

  void _setupRealtime() {
    _postsChannel = Supabase.instance.client.channel('realtime:posts')
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'posts',
        callback: (payload) {
          _fetchData(); // Refresh on any change
        },
      )
      .subscribe();
  }

  Future<void> _onRefresh() async {
    await _fetchData();
  }

  @override
  void dispose() {
    Supabase.instance.client.removeChannel(_postsChannel);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniRankTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Text('Feed', style: UniRankTheme.heading(28)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 28),
                    color: UniRankTheme.textMain,
                    onPressed: () => Navigator.pushNamed(context, '/create-post'),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_horiz_rounded, size: 28, color: UniRankTheme.textMain),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onSelected: (value) async {
                      if (value == 'logout') {
                        await AuthService().signOut();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                        }
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'logout',
                        child: Row(
                          children: [
                            const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
                            const SizedBox(width: 12),
                            Text('Log Out', style: UniRankTheme.body(14).copyWith(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Segmented Tabs (Visual only for now)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildTab('We recommend', true),
                  const SizedBox(width: 20),
                  _buildTab('Subscriptions', false),
                  const SizedBox(width: 20),
                  _buildTab('Friends', false),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: UniRankTheme.accent,
                child: CustomScrollView(
                  slivers: [
                    // Stories Row
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 100,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: _stories.length + 1,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return GestureDetector(
                                onTap: () {
                                  // TODO: Implement add story
                                },
                                child: const StoryCircle(isAdd: true),
                              );
                            }
                            return StoryCircle(story: _stories[index - 1]);
                          },
                        ),
                      ),
                    ),

                    // Filter Chips
                    SliverToBoxAdapter(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        child: Row(
                          children: _filters.map((filter) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: FilterChipWidget(
                                label: filter,
                                isSelected: _selectedFilter == filter,
                                onTap: () => setState(() => _selectedFilter = filter),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    // Feed Posts
                    if (_isLoading)
                       const SliverToBoxAdapter(
                         child: Padding(
                           padding: EdgeInsets.all(40),
                           child: Center(child: CircularProgressIndicator(color: UniRankTheme.accent)),
                         ),
                       )
                    else if (_posts.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Center(
                            child: Text(
                              'No posts yet',
                              style: UniRankTheme.body(16).copyWith(color: UniRankTheme.textSecondary),
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final post = _posts[index];
                              return PostCard(
                                post: post,
                                onTap: () {
                                  if (post.user != null) {
                                    Navigator.pushNamed(context, '/profile', arguments: post.user!.id);
                                  }
                                },
                              );
                            },
                            childCount: _posts.length,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text, bool isActive) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            color: isActive ? UniRankTheme.textMain : UniRankTheme.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 4),
        if (isActive)
          Container(
            width: 20,
            height: 2,
            decoration: BoxDecoration(
              color: UniRankTheme.accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    );
  }
}
