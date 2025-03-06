import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strybuc/screens/home.dart';

class AndroidDistanceTrackingScreen extends StatefulWidget {
  const AndroidDistanceTrackingScreen({super.key});

  @override
  _AndroidDistanceTrackingScreenState createState() =>
      _AndroidDistanceTrackingScreenState();
}

class _AndroidDistanceTrackingScreenState
    extends State<AndroidDistanceTrackingScreen> {
  static const methodChannel =
      MethodChannel('ar_measurement');
  List<String> screenshots = [];

  @override
  void initState() {
    super.initState();
    print('launching AR');
    _launchAR();

    methodChannel.setMethodCallHandler((call) async {
      if (call.method == "screenshotsCaptured") {
        List<String> paths = List<String>.from(call.arguments);
        // await _convertPathsToMemory(paths);
        setState(() {
          screenshots = paths;
        });

        if (paths.isNotEmpty) {
          await _saveCapturedImage(paths);
          // print('Received measurement result saved $screenshotBytes');
          Future.delayed(Duration(milliseconds: 300), () {
            if (mounted) {
              context.push('/photograph_parts/gallery');
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No images captured'),
              duration: Duration(seconds: 2),
            ),
          );
          Future.delayed(Duration(milliseconds: 300), () {
            if (mounted) {
              context.pop();
            }
          });
        }
      }
    });
  }

  // Future<void> _convertPathsToMemory(List<String> paths) async {
  //   List<Uint8List> images = [];

  //   for (String path in paths) {
  //     File file = File(path);
  //     if (await file.exists()) {
  //       Uint8List bytes = await file.readAsBytes(); // Convert file to bytes
  //       images.add(bytes);
  //     }
  //   }
  //   setState(() {
  //     screenshots = images;
  //   });
  //   print('Received measurement result images $images');
  // }

  Future<void> _saveCapturedImage(images) async {
    final prefs = await SharedPreferences.getInstance();
    // store captured images in shared preferences
    var oldImages = prefs.getStringList('captured_images');
    if (oldImages != null) {
      images.addAll(oldImages);
    }
    await prefs.setStringList('captured_images', images.toList());
  }

  Future<void> _launchAR() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // store captured images in shared preferences
      var oldImages = prefs.getStringList('captured_images');
      print('oldImages ${oldImages?.length}');
      final String result =
          await methodChannel.invokeMethod('startAR', oldImages?.length ?? 0);
      print("AR Launched: $result");
    } on PlatformException catch (e) {
      print("Failed to launch AR: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
