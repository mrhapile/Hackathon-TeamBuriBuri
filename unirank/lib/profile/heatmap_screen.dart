import 'package:flutter/material.dart';
import '../widgets/green_heatmap.dart';
import '../services/profile_service.dart';
import '../services/contribution_service.dart';
import '../theme.dart';
import '../widgets/neon_bottom_nav.dart';

class HeatmapScreen extends StatefulWidget {
  const HeatmapScreen({super.key});

  @override
  State<HeatmapScreen> createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends State<HeatmapScreen> {
  Map<DateTime, int> heatmapData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadContributions();
  }

  Future<void> loadContributions() async {
    final user = await ProfileService().getCurrentProfile();
    if (user != null) {
      final contributions = await ContributionService().fetchContributions(user.id);

      Map<DateTime, int> map = {};

      for (var c in contributions) {
        final date = c.date;
        map[date] = ((map[date] ?? 0) + c.count).toInt();
      }

      if (mounted) {
        setState(() {
          heatmapData = map;
          isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniRankTheme.bg,
      appBar: AppBar(title: Text('Heatmap', style: UniRankTheme.heading(20))),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator(color: UniRankTheme.accent))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  GreenHeatmap(title: 'Coding Activity', data: heatmapData),
                  const SizedBox(height: 20),
                  // Placeholder for other heatmaps or same data
                  GreenHeatmap(title: 'Design Contributions', data: {}), 
                  const SizedBox(height: 20),
                  GreenHeatmap(title: 'Research Papers', data: {}),
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
