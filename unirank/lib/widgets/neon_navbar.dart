import 'package:flutter/material.dart';
import '../theme.dart';

class NeonNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  const NeonNavBar({super.key, this.selectedIndex = 0, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: UniRankTheme.glassDecoration.copyWith(
        borderRadius: BorderRadius.circular(32),
        color: Colors.black.withOpacity(0.6),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => onTap(0),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: UniRankTheme.purpleGradient,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [UniRankTheme.neonGlow],
                      ),
                      child: const Icon(Icons.school, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Text('UniRank', style: UniRankTheme.heading(20)),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              _navButton(context, 'Discover', 0),
              const SizedBox(width: 12),
              _navButton(context, 'Messages', 1),
              const SizedBox(width: 12),
              _navButton(context, 'Settings', 2),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => onTap(10), // chat index
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _navButton(BuildContext context, String title, int index) {
    bool isActive = selectedIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: isActive
            ? BoxDecoration(
                gradient: UniRankTheme.purpleGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: UniRankTheme.neonPurple1.withOpacity(0.4),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  )
                ],
              )
            : BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
        child: Text(
          title,
          style: isActive
              ? UniRankTheme.heading(14)
              : UniRankTheme.body(14).copyWith(color: Colors.white60),
        ),
      ),
    );
  }
}
