import 'package:flutter/material.dart';
import '../widgets/heatmap_card.dart';
import '../widgets/neon_tag.dart';
import '../theme.dart';
import '../widgets/neon_bottom_nav.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniRankTheme.bg,
      appBar: AppBar(title: Text('Dashboard', style: UniRankTheme.heading(20))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pro Score Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: UniRankTheme.cardBg,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [UniRankTheme.softShadow],
              ),
              child: Column(
                children: [
                  Text('Your Pro Score', style: UniRankTheme.body(16)),
                  const SizedBox(height: 10),
                  Text('850', style: UniRankTheme.heading(48).copyWith(color: UniRankTheme.accent)),
                  const SizedBox(height: 10),
                  Text('Top 5% of Students', style: UniRankTheme.body(14)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Activity Heatmap', style: UniRankTheme.heading(18)),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  HeatmapCard(title: 'Coding', color: UniRankTheme.accent),
                  const SizedBox(width: 16),
                  HeatmapCard(title: 'Design', color: Colors.blue),
                  const SizedBox(width: 16),
                  HeatmapCard(title: 'Research', color: Colors.orange),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Hobbies & Interests', style: UniRankTheme.heading(18)),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: UniRankTheme.cardBg,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [UniRankTheme.softShadow],
              ),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  NeonTag('Photography'),
                  NeonTag('Gaming'),
                  NeonTag('Traveling'),
                  NeonTag('Music'),
                  NeonTag('Open Source'),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 1,
        onTap: (i) {
          if (i == 0) Navigator.pushNamed(context, '/');
          if (i == 2) Navigator.pushNamed(context, '/heatmap');
        },
      ),
    );
  }
}
