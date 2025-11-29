import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../theme.dart';

class PostCard extends StatelessWidget {
  final SamplePost post;
  final SampleUser user;
  final VoidCallback onTap;

  const PostCard({super.key, required this.post, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: UniRankTheme.bg,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [UniRankTheme.softShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              child: Image.network(
                post.image,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(user.avatar),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name, style: UniRankTheme.heading(15)),
                            Text('3 days ago', style: UniRankTheme.body(12)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: UniRankTheme.accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Save',
                          style: UniRankTheme.label(12).copyWith(color: UniRankTheme.accent),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Content
                  Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: UniRankTheme.heading(20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: UniRankTheme.body(15),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Stats
                  Row(
                    children: [
                      _buildStat(Icons.favorite_border_rounded, '12'),
                      const SizedBox(width: 20),
                      _buildStat(Icons.chat_bubble_outline_rounded, '4'),
                      const Spacer(),
                      Icon(Icons.share_outlined, color: UniRankTheme.textSecondary, size: 22),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, color: UniRankTheme.textSecondary, size: 22),
        const SizedBox(width: 8),
        Text(count, style: UniRankTheme.body(14).copyWith(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
