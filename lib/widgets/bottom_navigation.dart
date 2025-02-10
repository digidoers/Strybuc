import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:strybuc/theme.dart';

class BottomNavigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const BottomNavigation({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: AppTheme.secondaryBackgroundColor,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => {
          navigationShell.goBranch(index,
              initialLocation: index == navigationShell.currentIndex)
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/home.svg'),
            activeIcon: SvgPicture.asset('assets/icons/home_active.svg'),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/library.svg'),
            activeIcon: SvgPicture.asset('assets/icons/library_active.svg'),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/form.svg'),
            activeIcon: SvgPicture.asset('assets/icons/form_active.svg'),
            label: 'Forms',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/profile.svg'),
            activeIcon: SvgPicture.asset('assets/icons/profile_active.svg'),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
