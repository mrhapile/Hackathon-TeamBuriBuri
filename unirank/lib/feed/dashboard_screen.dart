import 'package:flutter/material.dart';
import '../services/profile_service.dart';
import '../services/contribution_service.dart';
import '../models/profile_model.dart';
import '../widgets/heatmap_card.dart';
import '../widgets/green_heatmap.dart';
import '../widgets/neon_tag.dart';
import '../theme.dart';
import '../services/notification_service.dart';
import '../screens/notification_screen.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ProfileService _profileService = ProfileService();
  final ContributionService _contributionService = ContributionService();
  
  ProfileModel? _user;
  Map<DateTime, int> _contributions = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final user = await _profileService.getCurrentProfile();
      if (user != null) {
        final contributionsList = await _contributionService.fetchContributions(user.id);
        final contributionsMap = <DateTime, int>{};
        for (var c in contributionsList) {
          final date = DateTime(c.date.year, c.date.month, c.date.day);
          contributionsMap[date] = (contributionsMap[date] ?? 0) + c.count;
        }

        if (mounted) {
          setState(() {
            _user = user;
            _contributions = contributionsMap;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: UniRankTheme.bg,
        body: Center(child: CircularProgressIndicator(color: UniRankTheme.accent)),
      );
    }

    if (_user == null) {
      return const Scaffold(
        backgroundColor: UniRankTheme.bg,
        body: Center(child: Text('Error loading dashboard')),
      );
    }

    // Calculate "Pro Score" based on contributions and attendance (Mock logic for now as no formula provided)
    final totalContributions = _contributions.values.fold(0, (a, b) => a + b);
    final proScore = (_user!.attendance * 10) + (totalContributions * 5);

    return Scaffold(
      backgroundColor: UniRankTheme.bg,
      appBar: AppBar(
        title: Text('Dashboard', style: UniRankTheme.heading(20)),
        backgroundColor: UniRankTheme.bg,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          StreamBuilder<int>(
            stream: Stream.periodic(const Duration(seconds: 10), (_) => 0) // Poll every 10s or use Realtime
                .asyncMap((_) => NotificationService().getUnreadCount()),
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const NotificationScreen()),
                      ).then((_) => setState(() {})); // Refresh dashboard on return
                    },
                  ),
                  if (count > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          count > 9 ? '9+' : count.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
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
                  Text(proScore.toString(), style: UniRankTheme.heading(48).copyWith(color: UniRankTheme.accent)),
                  const SizedBox(height: 10),
                  Text('Based on attendance & contributions', style: UniRankTheme.body(14)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            Text('Activity Heatmap', style: UniRankTheme.heading(18)),
            const SizedBox(height: 16),
            GreenHeatmap(title: 'Contributions', data: _contributions),
            
            const SizedBox(height: 24),
            Text('Interests', style: UniRankTheme.heading(18)),
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
                  // Using static interests for now as they are not in schema
                  NeonTag('Coding'),
                  NeonTag('Development'),
                  if (_user!.college != null) NeonTag(_user!.college!),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
