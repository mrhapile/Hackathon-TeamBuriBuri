import 'package:flutter/material.dart';
import '../theme.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? UniRankTheme.accent.withValues(alpha: 0.15) : UniRankTheme.softGray,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? UniRankTheme.accent : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: UniRankTheme.label(13).copyWith(
            color: isSelected ? UniRankTheme.accent : UniRankTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
