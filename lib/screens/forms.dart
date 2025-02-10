import 'package:flutter/material.dart';
import 'package:strybuc/theme.dart';
import 'package:strybuc/widgets/header.dart';
import 'package:strybuc/widgets/webview.dart';

class FormsScreen extends StatefulWidget {
  const FormsScreen({super.key});

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: 'Forms'),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Color(AppTheme.primaryColor),
        strokeWidth: 4.0,
        onRefresh: () => Future.delayed(const Duration(seconds: 2)),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: WebViewScreen(
                  url: 'https://www.strybuc.com/info/Forms-74.html',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
