import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:strybuc/theme.dart';
import 'package:strybuc/widgets/logo.dart';
import 'package:strybuc/widgets/rounded_button.dart';
import 'package:strybuc/services/api_service.dart'; // Import your API service

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _customerIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();  // Instantiate your API service

  // Add a loading indicator
  bool _isLoading = false;

  Future<void> _login() async {
    
    final login = _customerIdController.text;
    final password = _passwordController.text;

    // Client-side validation for empty fields
    if (login.isEmpty || password.isEmpty) {
      _showError('Please fill in both fields');
      return;
    }

    setState(() {
      _isLoading = true;
    });

     try {
      final response = await _apiService.login(login, password);
      // Ensure response is not null and contains 'customer'
      if (response != null && response.containsKey('customer') && response['customer'].isNotEmpty) {
        // Navigate to Home Screen
        context.go('/');
      } else {
        // Show an error message if login fails
        _showError('Invalid credentials. Please try again.');
      }
    } catch (e) {
      final errorMsg = e.toString();
      if (errorMsg.contains('Invalid credentials')) {
        _showError('Invalid credentials. Please check your login details.');
      } else if (errorMsg.contains('Request timed out') || errorMsg.contains('SocketException')) {
        _showError('Network issue. Please check your internet connection.');
      } else {
        _showError('An unexpected error occurred. Please try again.');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

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
                    'Sign in',
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
                    controller: _customerIdController,
                    style: Theme.of(context).textTheme.headlineMedium,
                    decoration: InputDecoration(
                      hintText: 'Customer ID',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Password Input
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: Theme.of(context).textTheme.headlineMedium,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Customer Sign-in Button
                  RoundedButton(
                    text: _isLoading ? 'Signing In...' : 'Customer Sign In',
                    onPressed: _isLoading ? null : _login,
                  ),
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
