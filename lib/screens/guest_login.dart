import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:strybuc/theme.dart';
import 'package:strybuc/widgets/logo.dart';
import 'package:strybuc/widgets/rounded_button.dart';

class GuestLoginScreen extends StatelessWidget {
  const GuestLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
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
              
                  // Customer ID Input
                  TextField(
                    style: Theme.of(context).textTheme.headlineMedium,
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
              
                  const SizedBox(height: 20),
              
                  TextField(
                    style: Theme.of(context).textTheme.headlineMedium,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
              
                  const SizedBox(height: 20),
              
                  // Password Input
                  TextField(
                    style: Theme.of(context).textTheme.headlineMedium,
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
              
                  const SizedBox(height: 20),
              
                  // Customer Sign-in Button
                  RoundedButton(text: 'Guest Sign In', onPressed: () {
                     context.go('/');
                  }),
                  const SizedBox(height: 20),
              
              
                  // Sign in as Guest Button
                  RoundedButton(
                    text: 'Go Back',
                    onPressed: () {
                      context.go('/login');
                    },
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
