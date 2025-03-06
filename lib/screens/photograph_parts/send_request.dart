import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:strybuc/theme.dart';
import 'package:strybuc/widgets/success_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../send_mail_request.dart';

class SendRequestScreen extends StatefulWidget {
  final List<String> images; // New parameter

  const SendRequestScreen(
      {super.key, required this.images}); // Update constructor

  @override
  _SendRequestScreenState createState() => _SendRequestScreenState();
}

class _SendRequestScreenState extends State<SendRequestScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  bool _isLoading = true;

  List<String> images = [];
  @override
  void initState() {
    super.initState();
    _loadCustomerData();
  }

  Future<void> _loadCustomerData() async {
    final prefs = await SharedPreferences.getInstance();
    String? customerName = prefs.getString('customer_name') ?? '';

    if (customerName.isNotEmpty) {
      setState(() {
        nameController.text = customerName;
      });
    }
  }

  static const String phone = '484-652-0492';

  void _launchPhoneDialer() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photograph Parts'),
      ),
      body: Stack(
        children: [
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          SingleChildScrollView(
            child: Padding(
              padding: AppTheme.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    'Send Your Request',
                    style: GoogleFonts.inter(
                      color: Color(AppTheme.textColor),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'If you have any questions please call us:',
                    style: GoogleFonts.inter(
                      color: Color(AppTheme.textColor),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: _launchPhoneDialer,
                    child: Text(
                      phone,
                      style: GoogleFonts.inter(
                        color: Color(AppTheme.primaryColor),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  _buildLabeledTextField(
                    label: 'Name',
                    controller: nameController,
                  ),
                  const SizedBox(height: 30),
                  _buildLabeledTextField(
                    label: 'Message',
                    controller: messageController,
                    hintText: 'Your Message',
                    maxLines: 5,
                  ),
                  const SizedBox(height: 30),
                  if (widget.images.isNotEmpty) ...[
                    Text('Photos', style: AppTheme.labelTextStyle),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis
                          .horizontal, // Allow scrolling if more than 6 images
                      child: Row(
                        children: widget.images.take(6).map((image) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(image),
                                width: 80, // Adjust size as needed
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              String name = nameController.text;
                              String messageData = messageController.text;

                              if (name.isEmpty || messageData.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Please fill in all fields")),
                                );
                                return;
                              }

                              setState(() {
                                _isLoading = true;
                              });

                              await sendEmailSMTP(
                                name: name,
                                messageData: messageData,
                                images: widget.images, // Pass images dynamically
                              );

                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.remove('captured_images');

                              setState(() {
                                _isLoading = false;
                                messageController.clear();
                              });

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) =>
                                    const SuccessDialog(
                                  title: 'Thank you for your photo(s)!',
                                  message:
                                      'We are processing your request and will contact you as soon as we identify the part(s) you need. Your Sales Rep will get back to you shortly.',
                                ),
                              );
                            },
                      label: Text(
                        'Send to Your Sales Rep',
                        style: AppTheme.buttonTextStyle,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isLoading
                            ? Colors.grey
                            : Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    String? hintText,
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
          maxLines: maxLines,
          controller: controller,
          style: Theme.of(context).textTheme.headlineMedium,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        )
      ],
    );
  }
}
