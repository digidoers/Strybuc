import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:strybuc/theme.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.backgroundColor,
    this.textColor,
    this.firstButtonTitle = 'Cancel',
    this.secondButtonTitle = 'Delete',
    this.firstButtonColor,
    this.secondButtonColor,
    this.firstButtonTextColor = Colors.black,
    this.secondButtonTextColor = Colors.white,
    this.firstButtonOnPressed,
    this.secondButtonOnPressed,
  });

  final String title;
  final String message;
  final Color? backgroundColor;
  final Color? textColor;

  final String firstButtonTitle;
  final String secondButtonTitle;
  final Color? firstButtonColor;
  final Color? secondButtonColor;
  final Color firstButtonTextColor;
  final Color secondButtonTextColor;
  final VoidCallback? firstButtonOnPressed;
  final VoidCallback? secondButtonOnPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor,
      insetPadding: const EdgeInsets.all(10),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      contentPadding:
          const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 20),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: Text(
        message,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
      actions: [
        // Cancel Button (styled)
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Cancel action
          },
          style: TextButton.styleFrom(
            foregroundColor: firstButtonTextColor, // Text color
            backgroundColor: firstButtonColor, // Background color (transparent)
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            side: BorderSide(
              color: Colors.black,
              width: 1,
            ), // Adding a black border
          ),
          child: Text(
            firstButtonTitle,
            style: GoogleFonts.inter(fontSize: 14),
          ),
        ),
        // Delete Image Button (styled)
        TextButton(
          onPressed: secondButtonOnPressed,
          style: TextButton.styleFrom(
            foregroundColor:
                secondButtonTextColor ?? Colors.white, // Text color
            backgroundColor: secondButtonColor ??
                AppTheme.redCardColor, // Red background for delete
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Rounded corners
            ),
          ),
          child: Text(
            secondButtonTitle,
            style: GoogleFonts.inter(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
