import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strybuc/widgets/logo.dart';
import 'package:url_launcher/url_launcher.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  static const String email = 'cservice@strybuc.com';
  static const String phone = '(800) 352 0800';

  void _launchEmail() async {
    const mailto = 'mailto:$email';
    if (await canLaunchUrl(Uri.parse(mailto))) {
      await launchUrl(Uri.parse(mailto));
    } else {
      throw 'Could not launch $mailto';
    }
  }

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Logo
                Center(
                  child: Logo(),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  'Thank you for downloading the Strybuc App.',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 20),

                // Description
                Text(
                  'This APP will allow you to:',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 20),

                // Bullet Points
                const BulletPoint(text: 'View Exclusive Discounted Products.'),
                const BulletPoint(
                  text:
                      'Take photographs with dimensions and send them to your assigned Sales Rep.',
                ),
                const BulletPoint(
                  text: 'Chat Live with any Sales Rep available.',
                ),
                const BulletPoint(text: 'And much more!'),

                const SizedBox(height: 20),

                // Additional Info
                Text(
                  'Consumers, as a Guest, can also benefit by having the parts they need photographed and sent to our Consumer Sales department.',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 20),

                // Contact Info
                Text(
                  'For questions about our App, please call',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                RichText(
                  text: TextSpan(
                    text: phone,
                    style: Theme.of(context).textTheme.headlineSmall,
                    recognizer: TapGestureRecognizer()
                      ..onTap = _launchPhoneDialer,
                    children: <TextSpan>[
                      TextSpan(
                        text: ' or email ',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _launchEmail,
                  child: Text(
                    email,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 20),

                // Continue Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 14),
                    ),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isFirstLaunch', false);
                      context.push('/login');
                    },
                    child: Text(
                      'Continue',
                      style: GoogleFonts.inter(
                          textStyle:
                              TextStyle(fontSize: 16, color: Colors.white)),
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
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            String.fromCharCode(0x2022), // Unicode for bullet point
            style: const TextStyle(fontSize: 20), // Bigger bullet point
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ],
      ),
    );
  }
}
