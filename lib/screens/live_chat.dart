import 'package:flutter/material.dart';
import 'package:strybuc/widgets/header.dart';
import 'package:strybuc/widgets/webview.dart';

class LiveChatScreen extends StatefulWidget {
  const LiveChatScreen({super.key});

  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: 'Live Chat'
        ),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: WebViewScreen(
                url:
                    'http://piertechlive.com/chat/window.html?account=strybuc&url=http://strybuc.com/public/partners.html',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
