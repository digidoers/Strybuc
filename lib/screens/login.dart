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
  final ApiService _apiService = ApiService();  

  bool _isLoading = false;
  String? _errorMessage; // Store the error message

  Future<void> _login() async {
    final login = _customerIdController.text;
    final password = _passwordController.text;

    if (login.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill out both fields';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous errors
    });

    try {
      final response = await _apiService.login(login, password);
      if (response != null && response.containsKey('customer') && response['customer'].isNotEmpty) {
        context.go('/');
      } else {
        setState(() {
          _errorMessage = 'Invalid credentials. Please try again.';
        });
      }
    } catch (e) {
      final errorMsg = e.toString();
      setState(() {
        if (errorMsg.contains('Invalid credentials')) {
          _errorMessage = 'Invalid credentials. Please check your login details.';
        } else if (errorMsg.contains('Request timed out') || errorMsg.contains('SocketException')) {
          _errorMessage = 'Network issue. Please check your internet connection.';
        } else {
          _errorMessage = 'Invalid credentials. Please try again.';
        }
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                Center(child: Logo()),
                const SizedBox(height: 40),
                Text(
                  'Sign in',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text("Don't have an account?", style: Theme.of(context).textTheme.titleSmall),
                    TextButton(
                      onPressed: () => context.go('/sign_up'),
                      child: Text('Sign Up', style: AppTheme.textButtonTextStyle),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _customerIdController,
                  style: Theme.of(context).textTheme.headlineMedium,
                  decoration: InputDecoration(
                    hintText: 'Customer ID',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: Theme.of(context).textTheme.headlineMedium,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: 10),

                // Show error message below fields
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                const SizedBox(height: 10),
                RoundedButton(
                  text: _isLoading ? 'Signing In...' : 'Customer Sign In',
                  onPressed: _isLoading ? null : _login,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: Divider(color: Theme.of(context).primaryColor)),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('OR')),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),
                RoundedButton(
                  text: 'Sign in as Guest',
                  onPressed: () => context.go('/guest_login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
