import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/sample_data.dart';
import '../widgets/create_post_widgets.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isPostEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isPostEnabled = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Using the first sample user as the current user
    final user = sampleUsers[0];

    return Scaffold(
      backgroundColor: UniRankTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: UniRankTheme.textMain),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Create Post',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: UniRankTheme.textMain,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _isPostEnabled
                        ? () {
                            // TODO: Implement post logic
                            Navigator.pop(context);
                          }
                        : null,
                    style: TextButton.styleFrom(
                      backgroundColor: _isPostEnabled ? UniRankTheme.accent : UniRankTheme.softGray,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      'Post',
                      style: TextStyle(
                        color: _isPostEnabled ? Colors.white : UniRankTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Row
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(user.avatar),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name, style: UniRankTheme.heading(16)),
                            Text(
                              '${user.branch} • ${user.year}th Year',
                              style: UniRankTheme.body(12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Text Input
                    PostInputField(
                      controller: _controller,
                      hintText: 'What do you want to talk about?',
                    ),
                    const SizedBox(height: 30),

                    // Attachment Grid
                    Text('Add to your post', style: UniRankTheme.heading(16)),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.1,
                      children: [
                        AttachmentTile(
                          icon: Icons.image_outlined,
                          label: 'Photo/Video',
                          color: Colors.blue,
                          onTap: () {},
                        ),
                        AttachmentTile(
                          icon: Icons.gif_box_outlined,
                          label: 'GIF',
                          color: Colors.purple,
                          onTap: () {},
                        ),
                        AttachmentTile(
                          icon: Icons.poll_outlined,
                          label: 'Poll',
                          color: Colors.orange,
                          onTap: () {},
                        ),
                        AttachmentTile(
                          icon: Icons.event_outlined,
                          label: 'Event',
                          color: Colors.red,
                          onTap: () {},
                        ),
                        AttachmentTile(
                          icon: Icons.article_outlined,
                          label: 'Notice',
                          color: Colors.teal,
                          onTap: () {},
                        ),
                        AttachmentTile(
                          icon: Icons.upload_file_outlined,
                          label: 'File',
                          color: Colors.indigo,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Toolbar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: UniRankTheme.bg,
                border: Border(top: BorderSide(color: UniRankTheme.border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ToolbarAction(icon: Icons.image_outlined, color: Colors.blue, onTap: () {}),
                  ToolbarAction(icon: Icons.gif_box_outlined, color: Colors.purple, onTap: () {}),
                  ToolbarAction(icon: Icons.poll_outlined, color: Colors.orange, onTap: () {}),
                  ToolbarAction(icon: Icons.event_outlined, color: Colors.red, onTap: () {}),
                  ToolbarAction(icon: Icons.upload_file_outlined, color: Colors.indigo, onTap: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
