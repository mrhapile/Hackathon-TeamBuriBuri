import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/comment_service.dart';
import '../models/comment_model.dart';
import '../widgets/custom_input.dart';

class CommentsSheet extends StatefulWidget {
  final String postId;

  const CommentsSheet({super.key, required this.postId});

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final TextEditingController _controller = TextEditingController();
  final CommentService _commentService = CommentService();
  late Future<List<CommentModel>> _commentsFuture;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _refreshComments();
  }

  void _refreshComments() {
    setState(() {
      _commentsFuture = _fetchComments();
    });
  }

  Future<List<CommentModel>> _fetchComments() async {
    final data = await _commentService.fetchComments(widget.postId);
    return data.map((json) => CommentModel.fromJson(json)).toList();
  }

  Future<void> _sendComment() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    setState(() => _isSending = true);
    try {
      await _commentService.addComment(widget.postId, content);
      _controller.clear();
      _refreshComments();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending comment: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: UniRankTheme.bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: UniRankTheme.softSlate.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          Text('Comments', style: UniRankTheme.heading(20)),
          const SizedBox(height: 20),

          Expanded(
            child: FutureBuilder<List<CommentModel>>(
              future: _commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: UniRankTheme.accent));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading comments', style: UniRankTheme.body(14)));
                }
                
                final comments = snapshot.data ?? [];
                if (comments.isEmpty) {
                  return Center(child: Text('No comments yet', style: UniRankTheme.body(14).copyWith(color: UniRankTheme.textSecondary)));
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: comments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: comment.user?.avatarUrl != null
                              ? NetworkImage(comment.user!.avatarUrl!)
                              : const AssetImage('assets/images/leaf_logo.png') as ImageProvider,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(comment.user?.name ?? 'Unknown', style: UniRankTheme.heading(14)),
                                  const SizedBox(width: 8),
                                  Text('Just now', style: UniRankTheme.body(12).copyWith(color: UniRankTheme.textSecondary)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(comment.text, style: UniRankTheme.body(14)),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          // Input
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, MediaQuery.of(context).viewInsets.bottom + 20),
            child: Row(
              children: [
                Expanded(
                  child: CustomInput(
                    controller: _controller,
                    hintText: 'Add a comment...',
                    icon: Icons.chat_bubble_outline,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: _isSending ? null : _sendComment,
                  icon: _isSending 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: UniRankTheme.accent))
                      : const Icon(Icons.send_rounded, color: UniRankTheme.accent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
