import 'package:flutter/material.dart';
import '../models/swipe_profile_model.dart';
import '../theme.dart';
import '../widgets/neon_tag.dart';

class SwipeCard extends StatelessWidget {
  final SwipeProfileModel profile;

  const SwipeCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            if (profile.postImage != null)
              Image.network(
                profile.postImage!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: UniRankTheme.softGray,
                  child: const Center(child: Icon(Icons.person, size: 64, color: UniRankTheme.textSecondary)),
                ),
              )
            else if (profile.avatarUrl != null)
              Image.network(
                profile.avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: UniRankTheme.softGray,
                  child: const Center(child: Icon(Icons.person, size: 64, color: UniRankTheme.textSecondary)),
                ),
              )
            else
              Container(
                color: UniRankTheme.softGray,
                child: const Center(child: Icon(Icons.person, size: 64, color: UniRankTheme.textSecondary)),
              ),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  stops: const [0.5, 0.7, 1.0],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name & Age
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          profile.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      // Mock Age/Year if not available directly as age
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          '${profile.year ?? "1"}th Year',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Branch & College
                  Row(
                    children: [
                      const Icon(Icons.school_outlined, color: Colors.white70, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${profile.branch ?? "Student"} • ${profile.college ?? "University"}',
                          style: const TextStyle(color: Colors.white70, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Distance (Mock)
                  const Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.white70, size: 16),
                      SizedBox(width: 8),
                      Text(
                        '2 km away',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tags
                  if (profile.postTags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: profile.postTags.take(3).map((tag) => _buildTag(tag)).toList(),
                    ),
                  
                  const SizedBox(height: 16),

                  // Bio / Post Desc
                  if (profile.postDesc != null && profile.postDesc!.isNotEmpty)
                    Text(
                      profile.postDesc!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                    ),
                  
                  // Space for bottom buttons
                  const SizedBox(height: 80), 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: UniRankTheme.accent.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}
