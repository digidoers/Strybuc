import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:strybuc/theme.dart';
import 'package:strybuc/widgets/logo.dart';
import 'package:strybuc/widgets/rounded_button.dart';
import 'package:strybuc/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final TextEditingController _customerIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _customerIdError;
  String? _passwordError;
  String? _generalError;

  Future<void> _login() async {
    setState(() {
      _customerIdError = null;
      _passwordError = null;
      _generalError = null;
    });

    final login = _customerIdController.text.trim();
    final password = _passwordController.text.trim();

    if (login.isEmpty) {
      setState(() => _customerIdError = 'Customer ID is required');
      return;
    }
    if (password.isEmpty) {
      setState(() => _passwordError = 'Password is required');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _apiService.login(login, password);
      if (response != null && response.containsKey('customer') && response['customer'].isNotEmpty) {
        context.go('/');
      } else {
        setState(() => _generalError = 'Invalid credentials. Please try again.');
      }
    } catch (e) {
      final errorMsg = e.toString();
      setState(() {
        if (errorMsg.contains('Invalid credentials')) {
          _generalError = 'Invalid credentials. Please check your login details.';
        } else if (errorMsg.contains('Request timed out') || errorMsg.contains('SocketException')) {
          _generalError = 'Network issue. Please check your internet connection.';
        } else {
          _generalError = 'Something went wrong. Please try again.';
        }
      });
    } finally {
      setState(() => _isLoading = false);
    }
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

                  // Customer ID Input
                  TextFormField(
                    controller: _customerIdController,
                    style: Theme.of(context).textTheme.headlineMedium,
                    decoration: InputDecoration(
                      hintText: 'Customer ID',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      errorText: _customerIdError, // Show error below input
                    ),
                  ),
                  // if (_customerIdError != null)
                  //   Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(left: 4.0, top: 4.0), // Adjust alignment
                  //       child: Text(
                  //         _customerIdError!,
                  //         style: const TextStyle(color: Colors.red, fontSize: 14),
                  //       ),
                  //     ),
                  //   ),
                  const SizedBox(height: 20),

                  // Password Input
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: Theme.of(context).textTheme.headlineMedium,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      errorText: _passwordError, // Show error below input
                    ),
                  ),
                  // if (_passwordError != null)
                  //   Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(left: 4.0, top: 4.0),
                  //       child: Text(
                  //         _passwordError!,
                  //         style: const TextStyle(color: Colors.red, fontSize: 14),
                  //       ),
                  //     ),
                  //   ),
                  const SizedBox(height: 10),

                  // Show general error message
                  if (_generalError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        _generalError!,
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
      ),
    );
  }
}
