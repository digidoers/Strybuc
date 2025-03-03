import 'dart:io';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:strybuc/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

Future<String> getAssetFile(String assetPath) async {
  final ByteData data = await rootBundle.load(assetPath);
  final tempDir = await getTemporaryDirectory();
  final tempFile = File('${tempDir.path}/${assetPath.split('/').last}');
  await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
  return tempFile.path;
}

Future<void> sendEmailSMTP({
  required String name,
  required String messageData,
  required List<String> images, // Accept image paths
}) async {
  final String salesEmail = AppConfig.salesEmail;
  final String appPassword = AppConfig.appPassword;
  final prefs = await SharedPreferences.getInstance();
  final String customerId = prefs.getString('login') ?? 'Guest User';
  final smtpServer = gmail(salesEmail, appPassword);

  final String customerEmail = prefs.getString('salesman_email_address') ?? '';
  final String guestEmail = 'ageorge@strybuc.com';
  final String recipientsMail = prefs.getString('login') ?.isNotEmpty == true ? customerEmail : guestEmail;
  final message = Message()
    ..from = Address(salesEmail, 'Strybuc')
    ..recipients.add(recipientsMail)
    ..subject = 'Strybuc App - Customer ID # $customerId'
    ..text = '''
    Hello Team,  

    You have received a photograph request from a customer. Below are the details:  

    NAME: $name    
    MESSAGE:    $messageData  
    '''
    ..attachments = await Future.wait(images.map((imagePath) async {
      String filePath = imagePath;
      if (imagePath.startsWith('assets/')) {
        filePath = await getAssetFile(imagePath);
      }
      
      File file = File(filePath);
      if (!file.existsSync()) {
        print("File does not exist: $filePath");
      }
      return FileAttachment(file);
    }));

  try {
    final sendReport = await send(message, smtpServer);
    print('Email sent: ${sendReport.toString()}');
  } catch (e) {
    print('Error sending email: $e');
  }
}

