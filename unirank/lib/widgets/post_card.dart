import 'package:flutter/material.dart';
import '../posts/post_model.dart';
import '../theme.dart';

import '../services/post_service.dart';
import '../widgets/comments_sheet.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback onTap;

  const PostCard({super.key, required this.post, required this.onTap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late bool _isLiked;
  late int _likesCount;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLiked;
    _likesCount = widget.post.likesCount;
  }

  Future<void> _toggleLike() async {
    setState(() {
      _isLiked = !_isLiked;
      _likesCount += _isLiked ? 1 : -1;
    });

    try {
      await PostService().toggleLike(widget.post.id);
    } catch (e) {
      // Revert if error
      if (mounted) {
        setState(() {
          _isLiked = !_isLiked;
          _likesCount += _isLiked ? 1 : -1;
        });
      }
    }
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsSheet(postId: widget.post.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
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
                widget.post.imageUrl,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 240,
                  color: UniRankTheme.softGray,
                  child: const Center(child: Icon(Icons.broken_image, color: UniRankTheme.textSecondary)),
                ),
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
                        backgroundImage: widget.post.user?.avatarUrl != null 
                            ? NetworkImage(widget.post.user!.avatarUrl!) 
                            : const AssetImage('assets/images/leaf_logo.png') as ImageProvider,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.post.user?.fullName ?? 'Unknown User', style: UniRankTheme.heading(15)),
                            Text('Just now', style: UniRankTheme.body(12)), // TODO: Format date
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
                    widget.post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: UniRankTheme.heading(20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.post.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: UniRankTheme.body(15),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Stats
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _toggleLike,
                        child: _buildStat(
                          _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          _likesCount.toString(),
                          color: _isLiked ? Colors.red : UniRankTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: _showComments,
                        child: _buildStat(Icons.chat_bubble_outline_rounded, widget.post.commentsCount.toString()),
                      ),
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

  Widget _buildStat(IconData icon, String count, {Color? color}) {
    return Row(
      children: [
        Icon(icon, color: color ?? UniRankTheme.textSecondary, size: 22),
        const SizedBox(width: 8),
        Text(count, style: UniRankTheme.body(14).copyWith(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
