import 'package:flutter/material.dart';
import 'package:strybuc/widgets/header.dart';
import 'package:strybuc/widgets/webview.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: 'Library'),
      body: RefreshIndicator(
        onRefresh: () => Future.delayed(const Duration(seconds: 1)),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: WebViewScreen(
                  url:
                      'https://www.strybuc.com/catalogs/2023-24-Strybuc-Catalog/index.html#p=1',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
