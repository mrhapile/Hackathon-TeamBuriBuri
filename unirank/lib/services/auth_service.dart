import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;
  Stream<AuthState> get authStream => _supabase.auth.onAuthStateChange;

  // Sign Up
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String branch,
    required String year,
    required String college,
  }) async {
    try {
      final AuthResponse res = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final User? user = res.user;

      if (user != null) {
        await _supabase.from('profiles').insert({
          'id': user.id,
          'email': email,
          'name': name,
          'branch': branch,
          'year': int.parse(year),
          'college': college,
          'attendance': 0,
        });
      }

    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  // Login
  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Logout
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
