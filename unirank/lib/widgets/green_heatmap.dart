import 'package:flutter/material.dart';
import '../theme.dart';
import 'soft_card.dart';

class GreenHeatmap extends StatelessWidget {
  final String title;
  final Map<DateTime, int>? data;

  const GreenHeatmap({
    super.key,
    required this.title,
    this.data,
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
              const int rows = 7;
              const int cols = 13; // Approx 3 months
              final double itemSize = (constraints.maxWidth - (cols - 1) * 4) / cols;
              
              // Generate dates for the last 13 weeks
              final now = DateTime.now();
              final startDate = now.subtract(const Duration(days: rows * cols - 1));

              return Wrap(
                spacing: 4,
                runSpacing: 4,
                children: List.generate(rows * cols, (index) {
                  final date = startDate.add(Duration(days: index));
                  final normalizedDate = DateTime(date.year, date.month, date.day);
                  final value = data?[normalizedDate] ?? 0;
                  
                  return Tooltip(
                    message: '${date.day}/${date.month}: $value contributions',
                    child: Container(
                      width: itemSize,
                      height: itemSize,
                      decoration: BoxDecoration(
                        color: _getColor(value),
                        borderRadius: BorderRadius.circular(4),
                      ),
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
