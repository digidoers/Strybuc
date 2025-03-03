// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class AndroidDistanceTrackingScreen extends StatefulWidget {
//   const AndroidDistanceTrackingScreen({super.key});

//   @override
//   _AndroidDistanceTrackingScreenState createState() => _AndroidDistanceTrackingScreenState();
// }

// class _AndroidDistanceTrackingScreenState extends State<AndroidDistanceTrackingScreen> {
//   static const platform = MethodChannel('com.example.strybuc/ar_measurement');

//   @override
//   void initState() {
//     super.initState();
//     _launchAR();
//   }

//   Future<void> _launchAR() async {
//     try {
//       final String result = await platform.invokeMethod('startAR');
//       print("AR Launched: $result");
//     } on PlatformException catch (e) {
//       print("Failed to launch AR: ${e.message}");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('AR Distance Tracking')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _launchAR,
//           child: const Text("Start AR Measurement"),
//         ),
//       ),
//     );
//   }
// }