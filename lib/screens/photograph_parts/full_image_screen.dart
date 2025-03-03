import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:strybuc/theme.dart';

class FullImageScreen extends StatelessWidget {
  final String imagePath;
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
              child: Image.asset(imagePath, fit: BoxFit.contain),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 14),
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
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.redCardColor,foregroundColor: Colors.white, side: BorderSide(color: Colors.white, width: 1)),
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
        return AlertDialog(
          title: const Text("Delete Photo", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
          content: const Text("Are you sure you want to delete this photo?", style: TextStyle(color: Colors.black)),
          actions: [
            // Cancel Button (styled)
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cancel action
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // Text color
                backgroundColor: Colors.white, // Background color (transparent)
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                side: BorderSide(color: Colors.black, width: 1), // Adding a black border
              ),
              child: const Text("Cancel", style: TextStyle(fontSize: 16)),
            ),
            // Delete Image Button (styled)
            TextButton(
              onPressed: () {
                print("Delete Image button pressed");
                Navigator.pop(context, true); // Indicate deletion
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // Text color
                backgroundColor: AppTheme.redCardColor, // Red background for delete
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
              ),
              child: const Text("Delete Image", style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    ).then((shouldDelete) {
      if (shouldDelete == true) {
        print('Image deleted');
        // Perform the deletion logic here (e.g., remove image from gallery)
        Navigator.pop(context, true); // Go back to the gallery page
      }
    });
  }

}
