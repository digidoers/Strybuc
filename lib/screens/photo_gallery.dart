import 'package:flutter/material.dart';
import 'package:strybuc/screens/full_image_screen.dart';
import 'package:strybuc/theme.dart'; // Assuming AppTheme is defined here

class PhotoGalleryRepScreen extends StatefulWidget {
  const PhotoGalleryRepScreen({super.key});

  @override
  _PhotoGalleryRepScreenState createState() => _PhotoGalleryRepScreenState();
}

class _PhotoGalleryRepScreenState extends State<PhotoGalleryRepScreen> {
  List<String> images = [
    'assets/images/full_first.png',
    'assets/images/full_first.png',
    'assets/images/full_first.png',
    'assets/images/full_first.png',
    'assets/images/full_first.png',
    'assets/images/full_first.png',
  ];

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
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      final bool? isDeleted = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullImageScreen(
                            imagePath: images[index],
                            index: index,
                          ),
                          fullscreenDialog: true, //
                        ),
                      );
                      print("isDeleted: $isDeleted"); // Check the returned value
                      // If the image was deleted, update the image list
                      if (isDeleted == true) {
                        print("Image at index $index deleted");
                        setState(() {
                          images.removeAt(index);
                        });
                      } else {
                        print("Image not deleted");
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        images[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            // Send Images Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Handle sending images logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sent ${images.length} images successfully!')),
                  );
                },
                //icon: const Icon(Icons.send),
                label: Text(
                  'Send ${images.length} Images', // Dynamic number of images
                  style: AppTheme.buttonTextStyle,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
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
