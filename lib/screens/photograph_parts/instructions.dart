import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:strybuc/constants.dart';
import 'package:strybuc/theme.dart';

class InstructionsScreen extends StatefulWidget {
  const InstructionsScreen({super.key});

  @override
  _InstructionsScreenState createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends State<InstructionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photograph Parts'),
      ),
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            padding: AppTheme.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'How to use “Photo Parts” / Camera Feature',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Color(AppTheme.textSecondaryColor),
                  ),
                ),
                const SizedBox(height: 14),

                // Instructions list
                _instructionList(),
                const SizedBox(height: 60), // Add spacing for bottom content
              ],
            ),
          ),

          // Fixed "Open Camera" button
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push('/photograph_parts/distance_tracking');
                },
                icon: SvgPicture.asset(
                  'assets/icons/photo_parts.svg',
                  width: 18,
                ),
                label: Text(
                  'Open Camera',
                  style: AppTheme.buttonTextStyle,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _instructionList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: Constants.cameraFeatureInstructions.length,
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${index + 1}. ',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Expanded(
              child: Text(
                Constants.cameraFeatureInstructions[index],
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
