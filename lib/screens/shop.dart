import 'package:flutter/material.dart';
import 'package:strybuc/widgets/header.dart';
import 'package:strybuc/widgets/webview.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: 'Shop',
      ),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: WebViewScreen(
                url:
                    'https://shop.strybuc.com/categorieshttps://shop.strybuc.com/categories',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
