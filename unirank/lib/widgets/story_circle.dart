import 'package:flutter/material.dart';
import '../posts/post_model.dart';
import '../theme.dart';

class StoryCircle extends StatelessWidget {
  final Story? story;
  final bool isAdd;

  const StoryCircle({super.key, this.story, this.isAdd = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isAdd ? Colors.transparent : UniRankTheme.accent,
              width: 2,
            ),
          ),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isAdd ? UniRankTheme.softGray : Colors.transparent,
              image: isAdd || story == null
                  ? null
                  : DecorationImage(
                      image: NetworkImage(story!.imageUrl),
                      fit: BoxFit.cover,
                    ),
            ),
            child: isAdd
                ? Icon(Icons.add, color: UniRankTheme.textMain, size: 28)
                : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          isAdd ? 'Add Story' : (story?.user.fullName.split(' ').first ?? 'User'),
          style: UniRankTheme.body(12),
        ),
      ],
    );
  }
}
