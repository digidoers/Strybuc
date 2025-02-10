import 'package:flutter/material.dart';
import 'package:strybuc/widgets/header.dart';
import 'package:strybuc/widgets/webview.dart';

class ExclusiveOffersScreen extends StatefulWidget {
  const ExclusiveOffersScreen({super.key});

  @override
  State<ExclusiveOffersScreen> createState() => _ExclusiveOffersScreenState();
}

class _ExclusiveOffersScreenState extends State<ExclusiveOffersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: 'Exclusive Offers'),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: WebViewScreen(
                url:
                    'https://strybuc.forpartsnow.com/inventory/catalog.php?classID=375',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
