import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme.dart';
import '../services/post_service.dart';
import '../services/profile_service.dart';
import '../models/profile_model.dart';
import '../widgets/create_post_widgets.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isPostEnabled = false;
  bool _isLoading = false;
  ProfileModel? _currentUser;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _fetchUser();
    _controller.addListener(() {
      setState(() {
        _isPostEnabled = _controller.text.isNotEmpty;
      });
    });
  }

  Future<void> _fetchUser() async {
    final profile = await ProfileService().getCurrentProfile();
    if (mounted) {
      setState(() {
        _currentUser = profile;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _handlePost() async {
    if (_currentUser == null) return;
    
    setState(() => _isLoading = true);
    try {
      String? imageUrl;
      if (_selectedImage != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        await Supabase.instance.client.storage
            .from('posts')
            .upload(fileName, _selectedImage!);
        imageUrl = Supabase.instance.client.storage
            .from('posts')
            .getPublicUrl(fileName);
      }

      await PostService().createPost(
        title: _controller.text.trim(), // Using text as title for now
        description: _controller.text.trim(),
        mediaUrl: imageUrl,
        college: _currentUser!.college ?? '',
        category: 'General', // Default category
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating post: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const Scaffold(
        backgroundColor: UniRankTheme.bg,
        body: Center(child: CircularProgressIndicator(color: UniRankTheme.accent)),
      );
    }

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
                    onPressed: _isPostEnabled && !_isLoading
                        ? _handlePost
                        : null,
                    style: TextButton.styleFrom(
                      backgroundColor: _isPostEnabled ? UniRankTheme.accent : UniRankTheme.softGray,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: _isLoading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(
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
                          backgroundImage: _currentUser!.avatarUrl != null 
                              ? NetworkImage(_currentUser!.avatarUrl!) 
                              : const AssetImage('assets/images/leaf_logo.png') as ImageProvider,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_currentUser!.name, style: UniRankTheme.heading(16)),
                            Text(
                              '${_currentUser!.branch ?? "Student"} • ${_currentUser!.year ?? "1"}th Year',
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
                    const SizedBox(height: 20),

                    // Selected Image Preview
                    if (_selectedImage != null)
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImage!,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedImage = null),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        ],
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
                          onTap: _pickImage,
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
                  ToolbarAction(icon: Icons.image_outlined, color: Colors.blue, onTap: _pickImage),
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
