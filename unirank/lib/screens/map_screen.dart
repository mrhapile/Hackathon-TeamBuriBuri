import 'package:flutter/material.dart';
import '../theme.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniRankTheme.bg,
      body: Center(
        child: Text('Map Screen', style: UniRankTheme.heading(24)),
      ),
    );
  }
}
