import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/feed_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/heatmap_screen.dart';
import 'screens/create_post_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://wamijvuswksbzdepbusm.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndhbWlqdnVzd2tzYnpkZXBidXNtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQzOTY2MTAsImV4cCI6MjA3OTk3MjYxMH0.uKE0OkVpJSFDH2UffB8iqnP8G4W9BQpxNP7QKvWsT1A',
  );

  runApp(UniRankApp());
}

class UniRankApp extends StatelessWidget {
  const UniRankApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniRank',
      theme: UniRankTheme.theme(),
      initialRoute: '/splash',
      routes: {
        '/splash': (ctx) => SplashScreen(),
        '/login': (ctx) => LoginScreen(),
        '/signup': (ctx) => SignupScreen(),
        '/feed': (ctx) => FeedScreen(),
        '/': (ctx) => FeedScreen(),
        '/dashboard': (ctx) => DashboardScreen(),
        '/profile': (ctx) => ProfileScreen(),
        '/heatmap': (ctx) => HeatmapScreen(),
        '/create-post': (ctx) => CreatePostScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
