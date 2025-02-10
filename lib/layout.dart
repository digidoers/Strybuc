import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:strybuc/widgets/bottom_navigation.dart';

class LayoutScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const LayoutScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigation(navigationShell: navigationShell),
    );
  }
}