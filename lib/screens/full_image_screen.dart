import 'package:flutter/material.dart';

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
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // Go back
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Go Back"),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showDeleteConfirmationDialog(context);
                  },
                  //icon: const Icon(Icons.delete),
                  label: const Text("Delete Image"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
          title: const Text("Delete Photo"),
          content: const Text("Are you sure you want to delete this photo?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cancel
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                print("Delete Image button pressed");
                Navigator.pop(context, true); // Return true to indicate deletion
              },
              child: const Text("Delete Image", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    ).then((shouldDelete) {
      if (shouldDelete == true) {
        print('shouldDelete');
        // Perform the deletion logic here (e.g., remove image from gallery)
        Navigator.pop(context, true); // Go back to the gallery page
      }
    });
  }
}
