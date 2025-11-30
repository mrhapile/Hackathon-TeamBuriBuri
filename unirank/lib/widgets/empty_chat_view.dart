import 'package:flutter/material.dart';
import '../theme.dart';
import '../screens/swipe_feed_screen.dart';
import '../widgets/neon_navbar.dart'; // To potentially switch tabs if needed, though Navigator push is safer for now

class EmptyChatView extends StatelessWidget {
  const EmptyChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: UniRankTheme.bg,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background bubble
                  Icon(
                    Icons.chat_bubble_rounded,
                    size: 80,
                    color: UniRankTheme.accent.withValues(alpha: 0.1),
                  ),
                  // Foreground icon
                  const Icon(
                    Icons.question_answer_rounded,
                    size: 40,
                    color: UniRankTheme.accent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Primary Text
            Text(
              'No messages yet',
              style: UniRankTheme.heading(24).copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Secondary Text
            Text(
              'Start a conversation with a student from your college.',
              textAlign: TextAlign.center,
              style: UniRankTheme.body(16).copyWith(
                color: UniRankTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),

            // Action Buttons
            _buildActionButton(
              context,
              label: 'Find Students',
              icon: Icons.people_outline_rounded,
              onTap: () {
                // Navigate to Swipe Feed (Discover)
                // Since we are likely inside a tab, we might want to switch tabs or push.
                // Pushing is safer to avoid messing with Navbar state from here without a provider.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SwipeFeedScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              context,
              label: 'Search Users',
              icon: Icons.search_rounded,
              isSecondary: true,
              onTap: () {
                // Placeholder for search
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Search feature coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool isSecondary = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isSecondary ? UniRankTheme.softGray : UniRankTheme.accent,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: isSecondary ? Colors.transparent : Colors.white,
          elevation: isSecondary ? 0 : 2,
          shadowColor: Colors.black.withValues(alpha: 0.05),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSecondary ? UniRankTheme.textSecondary : UniRankTheme.accent,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSecondary ? UniRankTheme.textSecondary : UniRankTheme.accent,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
