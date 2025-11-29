import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _collegeController = TextEditingController();
  
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _branchController.dispose();
    _yearController.dispose();
    _collegeController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  Future<void> _handleSignup() async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String branch = _branchController.text.trim();
    final String year = _yearController.text.trim();
    final String college = _collegeController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authService.signUp(
        email: email,
        password: password,
        name: name,
        branch: branch,
        year: year,
        college: college,
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/feed');
      }
    } catch (e) {
      if (mounted) {
        // Strip "Exception: " prefix if present for cleaner UI
        final message = e.toString().replaceAll('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniRankTheme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: UniRankTheme.textMain),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Account',
                style: UniRankTheme.heading(32).copyWith(color: UniRankTheme.accent),
              ),
              const SizedBox(height: 8),
              Text(
                'Join the community today.',
                style: UniRankTheme.body(16).copyWith(color: UniRankTheme.textSecondary),
              ),
              const SizedBox(height: 32),

              // Signup Form
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: UniRankTheme.bg,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [UniRankTheme.softShadow],
                  border: Border.all(color: UniRankTheme.border),
                ),
                child: Column(
                  children: [
                    CustomInput(
                      controller: _nameController,
                      hintText: 'Full Name',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                      CustomInput(
                        controller: _emailController,
                        hintText: 'Email Address',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        enableSuggestions: false,
                      ),
                    const SizedBox(height: 16),
                    CustomInput(
                      controller: _passwordController,
                      hintText: 'Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),
                    const SizedBox(height: 16),
                    CustomInput(
                      controller: _collegeController,
                      hintText: 'College Name',
                      icon: Icons.school_outlined,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomInput(
                            controller: _branchController,
                            hintText: 'Branch (e.g. CSE)',
                            icon: Icons.category_outlined,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomInput(
                            controller: _yearController,
                            hintText: 'Year (1-4)',
                            icon: Icons.calendar_today_outlined,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'Sign Up',
                      onPressed: _handleSignup,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
