import 'package:flutter/material.dart';
import '../services/profile_service.dart';
import '../services/auth_service.dart';
import 'user_profile.dart';
import '../theme.dart';
import '../widgets/soft_card.dart';
import '../widgets/green_heatmap.dart';
import '../widgets/filter_chip.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // If arguments are passed, use them (e.g. visiting another profile), otherwise fetch current user
    final String? userId = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      backgroundColor: UniRankTheme.bg,
      body: SafeArea(
        child: FutureBuilder<UserProfile?>(
          future: userId != null 
              ? ProfileService().fetchProfile(userId) 
              : ProfileService().getCurrentProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: UniRankTheme.accent));
            }

            if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
              return Center(
                child: Text(
                  'Error loading profile', 
                  style: UniRankTheme.body(16).copyWith(color: UniRankTheme.textSecondary)
                ),
              );
            }

            final user = snapshot.data!;

            return Column(
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
                      if (userId == null || userId == AuthService().currentUser?.id)
                        IconButton(
                          icon: const Icon(Icons.logout_rounded, color: Colors.red),
                          onPressed: () async {
                            await AuthService().signOut();
                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                            }
                          },
                        ),
                      const SizedBox(width: 8),
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
                                  backgroundImage: user.avatarUrl != null 
                                      ? NetworkImage(user.avatarUrl!) 
                                      : const AssetImage('assets/images/leaf_logo.png') as ImageProvider,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(user.fullName, style: UniRankTheme.heading(24)),
                              const SizedBox(height: 4),
                              Text(
                                '${user.branch ?? "Student"} • ${user.year ?? "1"}th Year',
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
                        const SizedBox(height: 40),
                        
                        // Logout Button
                        if (userId == null || userId == AuthService().currentUser?.id) // Show logout on own profile
                          Padding(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () async {
                                  await AuthService().signOut();
                                  if (context.mounted) {
                                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                                  }
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(color: Colors.red.withValues(alpha: 0.2)),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Log Out',
                                  style: UniRankTheme.heading(16).copyWith(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
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
