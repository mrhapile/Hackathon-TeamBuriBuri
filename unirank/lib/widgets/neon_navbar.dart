import 'package:flutter/material.dart';
import '../theme.dart';
import '../feed/feed_screen.dart';
import '../feed/dashboard_screen.dart';
import '../screens/chat_screen.dart';
import '../profile/profile_screen.dart';
import '../screens/swipe_feed_screen.dart';

class NeonNavbar extends StatefulWidget {
  const NeonNavbar({super.key});

  @override
  State<NeonNavbar> createState() => _NeonNavbarState();
}

class _NeonNavbarState extends State<NeonNavbar> {
  int currentIndex = 0;
  final List<Widget> pages = [
    const SwipeFeedScreen(),
    const DashboardScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniRankTheme.bg,
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: UniRankTheme.border)),
        ),
        child: SafeArea(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_filled, 'Feed', 0),
                _buildNavItem(Icons.dashboard_outlined, 'Dashboard', 1),
                _buildNavItem(Icons.chat_bubble_outline_rounded, 'Chat', 2),
                _buildNavItem(Icons.person_outline_rounded, 'Profile', 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF3CB371) : UniRankTheme.textSecondary,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF3CB371) : UniRankTheme.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
