import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhotographPartsHeader extends StatelessWidget {
  const PhotographPartsHeader({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}