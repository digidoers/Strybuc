import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:strybuc/theme.dart';
import 'package:strybuc/widgets/success_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../send_mail.dart';

class ContactSalesRepScreen extends StatefulWidget {
  const ContactSalesRepScreen({super.key});

  @override
  _ContactSalesRepScreenState createState() => _ContactSalesRepScreenState();
}

class _ContactSalesRepScreenState extends State<ContactSalesRepScreen> {

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override

  void initState() {
    super.initState();
    _loadCustomerData();
  }

  Future<void> _loadCustomerData() async {
    final prefs = await SharedPreferences.getInstance();
    String? customerName = prefs.getString('customer_name') ?? '';
    String? customerEmail = prefs.getString('customer_email_address') ?? '';

    if (customerName.isNotEmpty) {
      List<String> nameParts = customerName.split(' ');
      setState(() {
        firstNameController.text = nameParts.isNotEmpty ? nameParts.first : '';
        lastNameController.text = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        emailController.text = customerEmail;
      });
    }
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Sales Rep'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppTheme.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text(
                  'Get in touch',
                  style: AppTheme.screenTitleTextStyle,
                ),
                SizedBox(height: 16),
                _buildContactOption(
                    icon: 'phone.svg',
                    title: 'Call your Sales Rep',
                    onTap: () {}),
                SizedBox(height: 16),
                _buildContactOption(
                    icon: 'live_chat_black.svg',
                    title: 'Live chat to a team member ',
                    onTap: () {}),
                SizedBox(height: 30),
                Text(
                  'Send a message',
                  style: AppTheme.screenTitleTextStyle,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(hintText: 'First Name',controller:firstNameController),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(hintText: 'Last Name',controller: lastNameController),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(hintText: 'Email Address',controller:emailController),
                const SizedBox(height: 16),
                _buildTextField(
                  hintText: 'Your Message',
                  maxLines: 5,
                  controller:messageController,
                ),
                const SizedBox(height: 16),
                Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    String firstName = firstNameController.text.trim();
                    String lastName = lastNameController.text.trim();
                    String email = emailController.text.trim();
                    String messageData = messageController.text.trim();

                    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || messageData.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please fill in all fields")),
                      );
                      return;
                    }

                    await sendEmailSMTP(
                      firstName: firstName,
                      lastName: lastName,
                      email: email,
                      messageData: messageData,
                    );

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) => const SuccessDialog(
                        title: 'Thank you for your message!',
                        message: 'Your Sales Rep will get back to you within\n24 hours.',
                      ),
                    );
                  },
                  icon: SvgPicture.asset('assets/icons/send.svg'),
                  label: Text(
                    'Send Message',
                    style: AppTheme.buttonTextStyle,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            SvgPicture.asset('assets/icons/$icon'),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    int maxLines = 1,
    required TextEditingController controller,
  }) {
    return TextField(
      maxLines: maxLines,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: Theme.of(context).textTheme.headlineMedium,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
