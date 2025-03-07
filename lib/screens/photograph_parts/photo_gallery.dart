import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strybuc/theme.dart'; // Assuming AppTheme is defined here
import 'package:strybuc/screens/photograph_parts/send_request.dart';

class PhotoGalleryRepScreen extends StatefulWidget {
  const PhotoGalleryRepScreen({super.key});

  @override
  _PhotoGalleryRepScreenState createState() => _PhotoGalleryRepScreenState();
}

class _PhotoGalleryRepScreenState extends State<PhotoGalleryRepScreen> {
  List<String> images = [];

  @override
  void initState() {
    super.initState();
    _loadImagesFromPrefs(); // Load images from SharedPreferences when the screen opens
  }

  /// Load images from SharedPreferences
  Future<void> _loadImagesFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedImages = prefs.getStringList('captured_images');
    if (storedImages != null) {
      setState(() {
        images = storedImages; // Set the loaded images
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Gallery')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount:
                    images.length < 6 ? images.length + 1 : 6, // Max 6 items
                itemBuilder: (context, index) {
                  if (index == 0 && images.length < 6) {
                    // Camera Box when images are less than 6
                    return GestureDetector(
                      onTap: () {
                        context.push('/photograph_parts/distance_tracking');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.camera_alt,
                                color: Colors.white, size: 40),
                            SizedBox(height: 8),
                            Text('Camera',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ],
                        ),
                      ),
                    );
                  } else {
                    // Show images
                    int imageIndex = images.length < 6 ? index - 1 : index;
                    return GestureDetector(
                      onTap: () async {
                        final bool? isDeleted = await context.push(
                          '/full_image_screen',
                          extra: {
                            'imagePath': images[imageIndex],
                            'index': imageIndex
                          },
                        ) as bool?;

                        if (isDeleted == true) {
                          setState(() {
                            images.removeAt(imageIndex);
                          });
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        // child: Image.memory(
                        //   base64Decode(images[imageIndex]),
                        //   fit: BoxFit.cover,
                        // ),
                        child: Image.file(File(images[imageIndex]), fit: BoxFit.cover),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 10),

            // Send Images Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SendRequestScreen(images: images),
                    ),
                  );
                },
                label: Text(
                  'Send ${images.length} Images',
                  style: AppTheme.buttonTextStyle,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
