import 'package:flutter/material.dart';
import '../theme.dart';
import 'soft_card.dart';

class PostInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const PostInputField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: null,
      cursorColor: UniRankTheme.accent,
      style: UniRankTheme.body(16).copyWith(color: UniRankTheme.textMain),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: UniRankTheme.body(16).copyWith(color: UniRankTheme.textSecondary),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }
}

class AttachmentTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const AttachmentTile({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SoftCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: UniRankTheme.label(12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ToolbarAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ToolbarAction({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: color, size: 24),
      style: IconButton.styleFrom(
        backgroundColor: UniRankTheme.softGray,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
