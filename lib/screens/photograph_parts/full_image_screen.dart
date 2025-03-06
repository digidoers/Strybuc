import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strybuc/theme.dart';
import 'package:strybuc/widgets/confirmation_dialog.dart';

class FullImageScreen extends StatelessWidget {
  final String? imagePath;
  final int index;

  const FullImageScreen({
    super.key,
    required this.imagePath,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: InteractiveViewer(
                panEnabled: true,
                maxScale: 5.0,
                child: Image.file(File(imagePath!), fit: BoxFit.contain),),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Go Back Button (styled like Continue button)
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Go back
                    },
                    child: Text(
                      'Go Back',
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                // Delete Image Button
                ElevatedButton.icon(
                  onPressed: () {
                    _showDeleteConfirmationDialog(context);
                  },
                  label: const Text("Delete Image"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.redCardColor,
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white, width: 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: 'Delete Photo',
          message: 'Are you sure you want to delete this photo?',
          backgroundColor: Colors.white,
          firstButtonOnPressed: () {
            Navigator.pop(context, true); // Go back to the gallery page
          },
          secondButtonOnPressed: () async {
            // update shared preferences and remove image
            var prefs = await SharedPreferences.getInstance();
            var images = prefs.getStringList('captured_images') ?? [];
            images.removeAt(index);
            await prefs.setStringList('captured_images', images);
            Navigator.pop(context, true);
          },
        );
      },
    ).then((shouldDelete) {
      if (shouldDelete == true) {
        // Perform the deletion logic here (e.g., remove image from gallery)
        Navigator.pop(context, true); // Go back to the gallery page
      }
    });
  }
}
