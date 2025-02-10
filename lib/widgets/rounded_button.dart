import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.showBorder = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        minimumSize: const Size(double.infinity, 25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: showBorder ? BorderSide(color: Theme.of(context).primaryColor) : BorderSide(color: Colors.transparent),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: textColor ?? Colors.white),
      ),
    );
  }
}