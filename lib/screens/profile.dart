import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:strybuc/theme.dart';
import 'package:strybuc/widgets/header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController =
      TextEditingController(text: 'Andre Smith');
  final TextEditingController companyController =
      TextEditingController(text: 'Company Name');
  final TextEditingController emailController =
      TextEditingController(text: 'AndreSmith@gmail.com');
  final TextEditingController phoneController =
      TextEditingController(text: '949-584-9951');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: 'Profile'),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppTheme.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text(
                'My Profile',
                style: AppTheme.screenTitleTextStyle,
              ),
              const SizedBox(height: 20),
              _buildLabeledTextField(
                label: 'Name',
                controller: nameController,
              ),
              const SizedBox(height: 20),
              _buildLabeledTextField(
                label: 'Company',
                controller: companyController,
              ),
              const SizedBox(height: 20),
              _buildLabeledTextField(
                label: 'Email',
                controller: emailController,
              ),
              const SizedBox(height: 20),
              _buildLabeledTextField(
                label: 'Phone',
                controller: phoneController,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => context.go('/login'),
                child: Text(
                  'Log out',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.buttonRedColor,
                    decoration: TextDecoration.underline,
                    decorationColor: AppTheme.buttonRedColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.labelTextStyle,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: Theme.of(context).textTheme.headlineMedium,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
        )
      ],
    );
  }
}
