import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../theme.dart';

class NeonAvatar extends StatelessWidget {
  final SampleUser user;
  final double size;
  final bool hasStory;

  const NeonAvatar(this.user, {super.key, this.size = 64, this.hasStory = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: hasStory ? Border.all(color: UniRankTheme.accent, width: 2) : null,
          ),
          child: CircleAvatar(
            backgroundImage: NetworkImage(user.avatar),
            backgroundColor: UniRankTheme.cardBg,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          user.name.split(' ').first,
          style: UniRankTheme.body(12),
        ),
      ],
    );
  }
}
