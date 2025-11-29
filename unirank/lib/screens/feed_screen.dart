import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/sample_data.dart';
import '../widgets/story_circle.dart';
import '../widgets/post_card.dart';
import '../widgets/neon_bottom_nav.dart'; // Renamed class inside, file name kept for simplicity
import '../widgets/filter_chip.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _navIndex = 0;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Web Dev', 'AI/ML', 'App Dev', 'DSA', 'Cloud', 'Backend', 'Python'];

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
                  IconButton(
                    icon: const Icon(Icons.more_horiz_rounded, size: 28),
                    color: UniRankTheme.textMain,
                    onPressed: () {},
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
              child: CustomScrollView(
                slivers: [
                  // Stories Row
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 100,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: sampleUsers.length + 1,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/create-post'),
                              child: StoryCircle(user: sampleUsers[0], isAdd: true),
                            );
                          }
                          return StoryCircle(user: sampleUsers[index - 1]);
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
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final post = samplePosts[index];
                          final user = sampleUsers.firstWhere((u) => u.id == post.userId);
                          return PostCard(
                            post: post,
                            user: user,
                            onTap: () => Navigator.pushNamed(context, '/profile', arguments: user),
                          );
                        },
                        childCount: samplePosts.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _navIndex,
        onTap: (index) {
          setState(() => _navIndex = index);
          if (index == 3) Navigator.pushNamed(context, '/profile', arguments: sampleUsers[0]);
        },
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
