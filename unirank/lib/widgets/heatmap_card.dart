import 'package:flutter/material.dart';
import '../theme.dart';

class HeatmapCard extends StatelessWidget {
  final String title;
  final int rows;
  final int cols;
  final Color? color;

  const HeatmapCard({super.key, required this.title, this.rows = 5, this.cols = 8, this.color});

  Color _colorForValue(int v) {
    final baseColor = color ?? UniRankTheme.accent;
    if (v >= 8) return baseColor;
    if (v >= 5) return baseColor.withValues(alpha: 0.6);
    if (v >= 2) return baseColor.withValues(alpha: 0.3);
    return UniRankTheme.softGray;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> boxes = [];
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final v = (r + c * 2) % 10; // dummy value
        boxes.add(Container(
          width: 14,
          height: 14,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: _colorForValue(v),
            borderRadius: BorderRadius.circular(4),
          ),
        ));
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: UniRankTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [UniRankTheme.softShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: UniRankTheme.heading(16)),
          const SizedBox(height: 12),
          Wrap(children: boxes),
        ],
      ),
    );
  }
}
