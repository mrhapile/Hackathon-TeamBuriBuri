import 'package:flutter/material.dart';
import '../theme.dart';
import 'soft_card.dart';

class GreenHeatmap extends StatelessWidget {
  final String title;
  final int rows;
  final int cols;

  const GreenHeatmap({
    super.key,
    required this.title,
    this.rows = 7,
    this.cols = 13, // Approx 3 months
  });

  Color _getColor(int value) {
    if (value == 0) return UniRankTheme.softGray;
    if (value < 3) return UniRankTheme.mintGreenLight;
    if (value < 6) return UniRankTheme.accent.withValues(alpha: 0.6);
    return UniRankTheme.accent;
  }

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: UniRankTheme.heading(18)),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final double itemSize = (constraints.maxWidth - (cols - 1) * 4) / cols;
              return Wrap(
                spacing: 4,
                runSpacing: 4,
                children: List.generate(rows * cols, (index) {
                  // Simulate random data
                  final int value = (index * 7 + 3) % 10;
                  final int displayValue = value > 2 ? value : 0;
                  
                  return Container(
                    width: itemSize,
                    height: itemSize,
                    decoration: BoxDecoration(
                      color: _getColor(displayValue),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
