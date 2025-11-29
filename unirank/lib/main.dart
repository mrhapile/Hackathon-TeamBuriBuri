import 'package:flutter/material.dart';
import 'theme.dart';
import 'widgets/neon_navbar.dart';
import 'feed/feed_screen.dart';
import 'feed/dashboard_screen.dart';
import 'profile/profile_screen.dart';
import 'profile/heatmap_screen.dart';
import 'posts/create_post_screen.dart';
import 'auth/splash_screen.dart';
import 'auth/login_screen.dart';
import 'auth/signup_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://YOUR_SUPABASE_URL.supabase.co', // Replace with actual URL
    anonKey: 'YOUR_SUPABASE_ANON_KEY', // Replace with actual Key
  );

  runApp(const UniRankApp());
}

class UniRankApp extends StatelessWidget {
  const UniRankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniRank',
      debugShowCheckedModeBanner: false,
      theme: UniRankTheme.themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/feed': (context) => const NeonNavbar(), // Main shell
        '/create-post': (context) => const CreatePostScreen(),
        '/profile': (context) => const ProfileScreen(), // Keep for direct navigation if needed
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
