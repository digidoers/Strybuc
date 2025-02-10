import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:strybuc/theme.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;

  const Header({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
        onPressed: () => context.push('/'),
        icon: const Icon(Icons.arrow_back),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
