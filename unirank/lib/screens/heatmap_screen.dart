import 'package:flutter/material.dart';
import '../widgets/heatmap_card.dart';
import '../theme.dart';
import '../widgets/neon_bottom_nav.dart';

class HeatmapScreen extends StatelessWidget {
  const HeatmapScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniRankTheme.bg,
      appBar: AppBar(title: Text('Heatmap', style: UniRankTheme.heading(20))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            HeatmapCard(title: 'Coding Activity', color: UniRankTheme.accent),
            const SizedBox(height: 20),
            HeatmapCard(title: 'Design Contributions', color: Colors.blue),
            const SizedBox(height: 20),
            HeatmapCard(title: 'Research Papers', color: Colors.orange),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 2,
        onTap: (i) {
          if (i == 0) Navigator.pushNamed(context, '/');
          if (i == 1) Navigator.pushNamed(context, '/dashboard');
        },
      ),
    );
  }
}
