import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strybuc/router.dart';
import 'package:strybuc/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
  ));

  // Check if first launch
  final prefs = await SharedPreferences.getInstance();
  final bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
   final bool isLoggedIn = prefs.getString('customer_email_address') != null;

   // Set `is_first_launch` to false after first launch
  if (isFirstLaunch) {
    prefs.setBool('is_first_launch', false);
  }

  runApp(MainApp(isFirstLaunch: isFirstLaunch, isLoggedIn: isLoggedIn));
}






class MainApp extends StatelessWidget {
  final bool isFirstLaunch;
  final bool isLoggedIn;

  const MainApp({
    super.key,
    required this.isFirstLaunch,
    required this.isLoggedIn
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Strybuc',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: createRouter(isFirstLaunch,isLoggedIn),
    );
  }
}
