import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:strybuc/theme.dart';
import 'package:strybuc/widgets/logo.dart';
import 'package:strybuc/widgets/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuestLoginScreen extends StatefulWidget {
  const GuestLoginScreen({super.key});

  @override
  _GuestLoginScreenState createState() => _GuestLoginScreenState();
}

class _GuestLoginScreenState extends State<GuestLoginScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveGuestData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('customer_name', nameController.text.isNotEmpty ? nameController.text : '');
    await prefs.setString('customer_email_address', emailController.text.isNotEmpty ? emailController.text : '');
    await prefs.setString('customer_phone', phoneController.text.isNotEmpty ? phoneController.text : '');

    context.go('/'); // Navigate to home
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),

                // Logo
                Center(child: Logo()),

                const SizedBox(height: 40),

                // Sign-in Title
                Text(
                  'Sign in as a guest',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),

                const SizedBox(height: 10),

                // Sign-up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    TextButton(
                      onPressed: () => context.go('/sign_up'),
                      child: Text(
                        'Sign Up',
                        style: AppTheme.textButtonTextStyle,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Full Name Input
                TextField(
                  controller: nameController,
                  style: Theme.of(context).textTheme.headlineMedium,
                  decoration: InputDecoration(
                    hintText: 'Full Name',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),

                const SizedBox(height: 20),

                // Email Input
                TextField(
                  controller: emailController,
                  style: Theme.of(context).textTheme.headlineMedium,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),

                const SizedBox(height: 20),

                // Phone Number Input
                TextField(
                  controller: phoneController,
                  style: Theme.of(context).textTheme.headlineMedium,
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),

                const SizedBox(height: 20),

                // Guest Sign-in Button
                RoundedButton(
                  text: 'Guest Sign In',
                  onPressed: _saveGuestData, // Call function to save data
                ),

                const SizedBox(height: 20),

                // Go Back Button
                RoundedButton(
                  text: 'Go Back',
                  onPressed: () => context.go('/login'),
                  backgroundColor: Colors.white,
                  textColor: Theme.of(context).primaryColor,
                  showBorder: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
