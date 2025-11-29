import 'package:flutter/material.dart';
import '../widgets/green_heatmap.dart';
import '../services/profile_service.dart';
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
        child: FutureBuilder<Map<DateTime, int>>(
          future: ProfileService().getCurrentProfile().then((user) {
            if (user != null) {
              return ProfileService().fetchContributions(user.id);
            }
            return {};
          }),
          builder: (context, snapshot) {
            final data = snapshot.data;
            return Column(
              children: [
                GreenHeatmap(title: 'Coding Activity', data: data),
                const SizedBox(height: 20),
                // Placeholder for other heatmaps or same data
                GreenHeatmap(title: 'Design Contributions', data: {}), 
                const SizedBox(height: 20),
                GreenHeatmap(title: 'Research Papers', data: {}),
              ],
            );
          }
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
