import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import '../models/swipe_profile_model.dart';
import '../services/swipe_service.dart';
import '../widgets/swipe_card.dart';
import '../theme.dart';
import 'chat_room_screen.dart';

class SwipeFeedScreen extends StatefulWidget {
  const SwipeFeedScreen({super.key});

  @override
  State<SwipeFeedScreen> createState() => _SwipeFeedScreenState();
}

class _SwipeFeedScreenState extends State<SwipeFeedScreen> {
  final AppinioSwiperController _swiperController = AppinioSwiperController();
  final SwipeService _swipeService = SwipeService();
  
  List<SwipeProfileModel> _profiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Use local dummy profiles for instant UI testing (no backend)
    _loadDummyProfiles();
  }

  void _loadDummyProfiles() {
    // Local dummy profiles replacing backend feed. Keys align with SwipeProfileModel.fromJson
    List<Map<String, dynamic>> dummyProfiles = [
      {
        "profile_id": "dummy_1",
        "name": "Aarav Sharma",
        "age": 21,
        "branch": "CSE",
        "college": "College 1",
        "avatar_url": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=800",
        "about": "Loves coding, football & coffee.",
        "post_tags": ["Web Dev", "Python", "Flutter"],
        "post_image": "https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800",
        "post_desc": "Hackathon vibes! 💻",
      },
      {
        "profile_id": "dummy_2",
        "name": "Priya Mehta",
        "age": 22,
        "branch": "AI/ML",
        "college": "College 1",
        "avatar_url": "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=800",
        "about": "ML enthusiast & dancer.",
        "post_tags": ["AI", "ML", "TensorFlow"],
        "post_image": "https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?w=800",
        "post_desc": "Building the future with AI 🤖",
      },
      {
        "profile_id": "dummy_3",
        "name": "Vivaan Gupta",
        "age": 23,
        "branch": "ECE",
        "college": "College 2",
        "avatar_url": "https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=800",
        "about": "Music, coding & travel.",
        "post_tags": ["Java", "App Dev", "UI/UX"],
        "post_image": "https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=800",
        "post_desc": "Jamming session 🎸",
      },
    ];

    setState(() {
      _profiles = dummyProfiles.map((data) => SwipeProfileModel.fromJson(data)).toList();
      _isLoading = false;
    });
  }

  /*
  Future<void> _fetchFeed() async {
    final profiles = await _swipeService.fetchFeed();
    if (mounted) {
      setState(() {
        _profiles = profiles;
        _isLoading = false;
      });
    }
  }
  */

  Future<void> _handleSwipe(SwipeProfileModel profile, bool isLike) async {
    final isMatch = await _swipeService.swipe(swipedId: profile.id, isLike: isLike);
    if (isMatch && mounted) {
      _showMatchDialog(profile);
    }
  }

  void _showMatchDialog(SwipeProfileModel profile) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('It\'s a Match!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: UniRankTheme.accent)),
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 50,
                backgroundImage: profile.avatarUrl != null ? NetworkImage(profile.avatarUrl!) : null,
                child: profile.avatarUrl == null ? const Icon(Icons.person, size: 50) : null,
              ),
              const SizedBox(height: 16),
              Text('You and ${profile.name} liked each other.', textAlign: TextAlign.center, style: UniRankTheme.body(16)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to chat? Need conversation ID, but we just created it. 
                  // For now just close dialog or go to chat list.
                  // Ideally backend returns conversation ID on match.
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: UniRankTheme.accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Send Message', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Keep Swiping', style: TextStyle(color: UniRankTheme.textSecondary)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniRankTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header (optional, or just use Navbar)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Discover', style: UniRankTheme.heading(24)),
                  IconButton(
                    icon: const Icon(Icons.tune_rounded, color: Colors.black),
                    onPressed: () {}, // Filter
                  ),
                ],
              ),
            ),

            // Card Stack
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: UniRankTheme.accent))
                  : _profiles.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.style_outlined, size: 64, color: UniRankTheme.textSecondary),
                              const SizedBox(height: 16),
                              Text('No more profiles', style: UniRankTheme.body(16)),
                              TextButton(
                                onPressed: _loadDummyProfiles,
                                child: const Text('Refresh', style: TextStyle(color: UniRankTheme.accent)),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: AppinioSwiper(
                            cardCount: _profiles.length,
                            cardBuilder: (BuildContext context, int index) {
                              final p = _profiles[index];
                              return SwipeCard(profile: p);
                            },
                            onSwipeEnd: (previousIndex, targetIndex, activity) async {
                              if (targetIndex == null) return;
                              final profile = _profiles[previousIndex];
                              final isLike = activity.direction == AxisDirection.right;
                              await _handleSwipe(profile, isLike);
                            },
                            onEnd: () {
                              setState(() {
                                _profiles.clear();
                              });
                            },
                          ),
                        ),
            ),

            // Bottom Action Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.replay,
                    color: Colors.orange,
                    size: 20,
                    padding: 12,
                    onTap: () => _swiperController.unswipe(),
                  ),
                  _buildActionButton(
                    icon: Icons.close,
                    color: Colors.red,
                    size: 30,
                    padding: 16,
                    onTap: () => _swiperController.swipeLeft(),
                  ),
                  _buildActionButton(
                    icon: Icons.star,
                    color: Colors.blue,
                    size: 20,
                    padding: 12,
                    onTap: () {}, // Save/Super Like
                  ),
                  _buildActionButton(
                    icon: Icons.favorite,
                    color: UniRankTheme.accent,
                    size: 30,
                    padding: 16,
                    onTap: () => _swiperController.swipeRight(),
                    isGlow: true,
                  ),
                  _buildActionButton(
                    icon: Icons.flash_on,
                    color: Colors.purple,
                    size: 20,
                    padding: 12,
                    onTap: () {}, // Boost
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required double size,
    required double padding,
    required VoidCallback onTap,
    bool isGlow = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: isGlow ? color.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.1),
              blurRadius: isGlow ? 20 : 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: size),
      ),
    );
  }
}
