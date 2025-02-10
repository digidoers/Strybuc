import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:strybuc/theme.dart';
import 'package:strybuc/widgets/logo.dart';
import 'package:strybuc/widgets/rounded_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            // margin: EdgeInsets.only(top: 80),
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
                    'Sign in',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
              
                  const SizedBox(height: 10),
              
                  // Sign-up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // spacing: 0,
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
                      hintText: 'Customer ID',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
              
                  const SizedBox(height: 20),
              
                  // Password Input
                  TextField(
                    obscureText: true,
                    style: Theme.of(context).textTheme.headlineMedium,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
              
                  const SizedBox(height: 20),
              
                  // Customer Sign-in Button
                  RoundedButton(text: 'Customer Sign In', onPressed: () => context.push('/')),
                  const SizedBox(height: 20),
              
                  // Divider with OR
                  Row(
                    children: [
                      Expanded(
                          child: Divider(color: Theme.of(context).primaryColor)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('OR'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
              
                  const SizedBox(height: 20),
              
                  // Sign in as Guest Button
                  RoundedButton(
                    text: 'Sign in as Guest',
                    onPressed: () => context.go('/guest_login'),
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
