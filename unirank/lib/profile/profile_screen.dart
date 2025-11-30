import 'package:flutter/material.dart';
import '../services/profile_service.dart';
import '../services/contribution_service.dart';
import '../services/auth_service.dart';
import '../models/profile_model.dart';
import '../models/contribution_model.dart';
import '../theme.dart';
import '../widgets/soft_card.dart';
import '../widgets/filter_chip.dart';
import '../services/conversation_service.dart';
import '../screens/chat_room_screen.dart';
import '../widgets/green_heatmap.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final ContributionService _contributionService = ContributionService();
  
  ProfileModel? _user;
  Map<DateTime, int> _contributions = {};
  bool _isLoading = true;
  String? _userId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      _userId = args;
    }
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      ProfileModel? user;
      if (_userId != null) {
        user = await _profileService.fetchProfile(_userId!);
      } else {
        user = await _profileService.getCurrentProfile();
      }

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
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
      return Scaffold(
        backgroundColor: UniRankTheme.bg,
        body: Center(child: Text('User not found', style: UniRankTheme.body(16))),
      );
    }

    final isCurrentUser = _userId == null || _userId == AuthService().currentUser?.id;

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
                  if (!isCurrentUser)
                    GestureDetector(
                      onTap: () async {
                        // Navigate to chat
                        final conversationService = ConversationService();
                        try {
                          final convId = await conversationService.getOrCreateConversation(_user!.id);
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatRoomScreen(
                                  conversationId: convId,
                                  otherUser: _user,
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error starting chat: $e')));
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: UniRankTheme.accent.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.chat_bubble_outline_rounded, size: 20, color: UniRankTheme.accent),
                      ),
                    ),
                  if (isCurrentUser)
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
                              backgroundImage: _user!.avatarUrl != null 
                                  ? NetworkImage(_user!.avatarUrl!) 
                                  : const AssetImage('assets/images/leaf_logo.png') as ImageProvider,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(_user!.name, style: UniRankTheme.heading(24)),
                          const SizedBox(height: 4),
                          Text(
                            '${_user!.branch ?? "Student"} • ${_user!.year ?? "1"}th Year',
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
                              Text('${_user!.attendance}%', style: UniRankTheme.body(16).copyWith(color: UniRankTheme.softSlate)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          LinearProgressIndicator(
                            value: _user!.attendance / 100,
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
                        _buildInsightCard('Contributions', _contributions.values.fold(0, (a, b) => a + b).toString(), Icons.local_fire_department_rounded),
                        const SizedBox(width: 12),
                        _buildInsightCard('Attendance', '${_user!.attendance}%', Icons.check_circle_outline),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Contributions Heatmap
                    GreenHeatmap(title: 'Contributions', data: _contributions),
                    const SizedBox(height: 20),

                    // Skills (Placeholder for now as not in schema, or could be tags)
                    // Removing static skills to avoid "mock data" if possible, or keeping generic ones.
                    // User said "Remove all mock data". I'll remove the Skills section if I can't fetch it.
                    // But I can show GitHub/LeetCode IDs if present.
                    if (_user!.githubUsername != null || _user!.leetcodeId != null)
                      SoftCard(
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Profiles', style: UniRankTheme.heading(18)),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  if (_user!.githubUsername != null) _buildSkillChip('GitHub: ${_user!.githubUsername}'),
                                  if (_user!.leetcodeId != null) _buildSkillChip('LeetCode: ${_user!.leetcodeId}'),
                                  if (_user!.codeforcesId != null) _buildSkillChip('Codeforces: ${_user!.codeforcesId}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 40),
                    
                    // Logout Button (Redundant but requested in task)
                    if (isCurrentUser)
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
