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

  runApp(MainApp(isFirstLaunch: isFirstLaunch));
}






class MainApp extends StatelessWidget {
  final bool isFirstLaunch;

  const MainApp({
    super.key,
    required this.isFirstLaunch,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Strybuc',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: createRouter(isFirstLaunch),
    );
  }
}
