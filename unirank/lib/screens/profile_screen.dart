import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../theme.dart';
import '../widgets/soft_card.dart';
import '../widgets/green_heatmap.dart';
import '../widgets/filter_chip.dart';
import '../widgets/neon_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as SampleUser;

    return Scaffold(
      backgroundColor: UniRankTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Back Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: UniRankTheme.softGray,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, size: 20, color: UniRankTheme.textMain),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.more_horiz, color: UniRankTheme.textMain),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Profile Header
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: UniRankTheme.accent, width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(user.avatar),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(user.name, style: UniRankTheme.heading(24)),
                          const SizedBox(height: 4),
                          Text(
                            '${user.branch} • ${user.year}th Year',
                            style: UniRankTheme.body(14).copyWith(color: UniRankTheme.softSlate),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Attendance Section
                    SoftCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Attendance', style: UniRankTheme.heading(18)),
                              Text('85%', style: UniRankTheme.body(16).copyWith(color: UniRankTheme.softSlate)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          LinearProgressIndicator(
                            value: 0.85,
                            backgroundColor: UniRankTheme.mintGreenLight.withValues(alpha: 0.3),
                            color: UniRankTheme.accent,
                            minHeight: 12,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Activity Insights
                    Row(
                      children: [
                        _buildInsightCard('Hours\nStudied', '42', Icons.timer_outlined),
                        const SizedBox(width: 12),
                        _buildInsightCard('DSA\nSolved', '156', Icons.code_rounded),
                        const SizedBox(width: 12),
                        _buildInsightCard('GitHub\nStreak', '12', Icons.local_fire_department_rounded),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Contributions Heatmap
                    const GreenHeatmap(title: 'Contributions'),
                    const SizedBox(height: 20),

                    // Skills
                    SoftCard(
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Skills', style: UniRankTheme.heading(18)),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _buildSkillChip('Python'),
                                _buildSkillChip('AI/ML'),
                                _buildSkillChip('Flutter'),
                                _buildSkillChip('React'),
                                _buildSkillChip('Node.js'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 3,
        onTap: (i) {
          if (i == 0) Navigator.pushNamed(context, '/');
          if (i == 1) Navigator.pushNamed(context, '/dashboard'); // Map placeholder
        },
      ),
    );
  }

  Widget _buildInsightCard(String label, String value, IconData icon) {
    return Expanded(
      child: SoftCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: UniRankTheme.accent, size: 24),
            const SizedBox(height: 12),
            Text(value, style: UniRankTheme.heading(20)),
            const SizedBox(height: 4),
            Text(
              label,
              style: UniRankTheme.body(12).copyWith(height: 1.2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: UniRankTheme.softGray,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: UniRankTheme.border),
      ),
      child: Text(
        label,
        style: UniRankTheme.label(12).copyWith(color: UniRankTheme.textSecondary),
      ),
    );
  }
}
