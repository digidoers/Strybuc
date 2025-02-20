import 'package:flutter/material.dart';
import 'package:strybuc/theme.dart';

class PhotoGalleryRepScreen extends StatefulWidget {
  const PhotoGalleryRepScreen({super.key});

  @override
  _PhotoGalleryRepScreenState createState() => _PhotoGalleryRepScreenState();
}

class _PhotoGalleryRepScreenState extends State<PhotoGalleryRepScreen> {
  final List<String> images = List.generate(6, (_) => 'assets/images/first.png');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photograph Gallery'),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppTheme.screenPadding,
          child: Column(
            children: [
              const SizedBox(height: 16),
              
              // Gallery Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 images per row
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        images[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Send Images Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Images sent successfully!')),
                    );
                  },
                  icon: const Icon(Icons.send),
                  label: Text(
                    'Send Images',
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
      ),
    );
  }
}
