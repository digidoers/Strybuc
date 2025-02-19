import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:strybuc/theme.dart';
import 'package:strybuc/widgets/header.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool hasCompany = false; // Track if company has a value

  @override
  void initState() {
    super.initState();
    _fetchCustomerData();
  }

  // Fetch customer data and update the controllers
  Future<void> _fetchCustomerData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? customerName = prefs.getString('customer_name') ?? '';
      String? customerEmail = prefs.getString('customer_email_address') ?? '';
      String? customerPhone = prefs.getString('customer_phone') ?? '';
      String? customerCompany = prefs.getString('customer_company_cu') ?? '';
      if (customerName.isNotEmpty) {
        setState(() {
          nameController.text = customerName;
          emailController.text = customerEmail;
          phoneController.text = customerPhone;
          companyController.text = customerCompany;
          hasCompany = customerCompany.isNotEmpty; // Update visibility flag
        });
      }
    } catch (e) {
      print('Error fetching customer data: $e');
    }
  }
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
                hasCompany ? 'My Profile' : 'Guest Profile',
                style: AppTheme.screenTitleTextStyle,
              ),
              const SizedBox(height: 20),
              _buildLabeledTextField(
                label: 'Name',
                controller: nameController,
              ),
              if (hasCompany)...[
                const SizedBox(height: 20),
                _buildLabeledTextField(label: 'Company', controller: companyController),
              ],
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
                onPressed: () async {
                  // Remove the access token
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();

                  // Navigate to the login screen
                  context.go('/login');
                },
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
        ),
      ],
    );
  }
}
