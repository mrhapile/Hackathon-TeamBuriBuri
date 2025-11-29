import 'package:flutter/material.dart';
import '../theme.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;

  const CustomInput({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.autocorrect = true,
    this.enableSuggestions = true,
  });

  final bool autocorrect;
  final bool enableSuggestions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: UniRankTheme.softGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        autocorrect: autocorrect,
        enableSuggestions: enableSuggestions,
        cursorColor: UniRankTheme.accent,
        style: UniRankTheme.body(16),
        decoration: InputDecoration(
          icon: Icon(icon, color: UniRankTheme.textSecondary, size: 20),
          hintText: hintText,
          hintStyle: UniRankTheme.body(16).copyWith(color: UniRankTheme.textSecondary),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
