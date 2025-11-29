import 'package:flutter/material.dart';
import '../theme.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniRankTheme.bg,
      body: Center(
        child: Text('Chat Screen', style: UniRankTheme.heading(24)),
      ),
    );
  }
}
