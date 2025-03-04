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
  final _formKey = GlobalKey<FormState>(); // Form key for validation
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
    if (!_formKey.currentState!.validate()) {
      return; // Don't proceed if form is invalid
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('customer_name', nameController.text);
    await prefs.setString('customer_email_address', emailController.text);
    await prefs.setString('customer_phone', phoneController.text);

    context.go('/'); // Navigate to home
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                  TextFormField(
                    controller: nameController,
                    style: Theme.of(context).textTheme.headlineMedium,
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      errorStyle: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ), // Left align and smaller font for error message
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Full Name is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Email Input
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress, // Ensures correct keyboard for email
                    style: Theme.of(context).textTheme.headlineMedium,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      errorStyle: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ), // Left align and smaller font for error message
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Phone Number Input
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.number, // Ensures number-only keyboard
                    style: Theme.of(context).textTheme.headlineMedium,
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      errorStyle: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ), // Left align and smaller font for error message
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone Number is required';
                      } else if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
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
      ),
    );
  }
}
