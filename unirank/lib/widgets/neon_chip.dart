import 'package:flutter/material.dart';
import '../theme.dart';

class NeonChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const NeonChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? UniRankTheme.neonPurple1 : const Color(0xFF1A1625),
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: UniRankTheme.neonPurple1.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Text(
          label,
          style: UniRankTheme.label(13).copyWith(
            color: isSelected ? Colors.white : Colors.white60,
          ),
        ),
      ),
    );
  }
}
