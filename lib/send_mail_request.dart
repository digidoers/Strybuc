import 'dart:convert';
import 'dart:io';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:strybuc/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

Future<List<Attachment>> getAttachments(images) async {
  List<Attachment> attachments = [];

  // final ByteData data = await rootBundle.load(assetPath);
  // final tempDir = await getTemporaryDirectory();
  // final tempFile = File('${tempDir.path}/${assetPath.split('/').last}');
  // await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
  // return tempFile.path;
  // final tempDir = await getTemporaryDirectory();
  // final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  // final File tempFile = File('${tempDir.path}/image_$timestamp.jpg');

  // // Get the bytes from MemoryImage
  // Uint8List imageBytes = image.bytes;
  // await tempFile.writeAsBytes(imageBytes);

  // attachments.add(FileAttachment(tempFile));
  for (var image in images) {
    print('attachments image $image');
    // final tempDir = await getTemporaryDirectory();
    // final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    // final File tempFile = File('${tempDir.path}/image_$timestamp.jpg');
    // Uint8List imageBytes = image;
    // await tempFile.writeAsBytes(imageBytes);
    File file = File(image);
    attachments.add(FileAttachment(file));
  }
    print('attachments $attachments');

  return attachments;
}

Future<void> sendEmailSMTP({
  required String name,
  required String messageData,
  required List<String> images, // Accept image paths
}) async {
  print('images send mail $images');
  final String salesEmail = AppConfig.salesEmail;
  final String appPassword = AppConfig.appPassword;
  final prefs = await SharedPreferences.getInstance();
  final String customerId = prefs.getString('login') ?? 'Guest User';
  final smtpServer = gmail(salesEmail, appPassword);

  final String customerEmail = prefs.getString('salesman_email_address') ?? '';
  // final String guestEmail = 'ageorge@strybuc.com';
  final String guestEmail = 'moolchand@digidoers.in';
  final String recipientsMail =
      prefs.getString('login')?.isNotEmpty == true ? customerEmail : guestEmail;

  final message = Message()
    ..from = Address(salesEmail, 'Strybuc')
    ..recipients.add(recipientsMail)
    ..subject = 'Strybuc App - Customer ID # $customerId'
    ..text = '''
    Hello Team,  

    You have received a photograph request from a customer. Below are the details:  

    NAME: $name    
    MESSAGE: $messageData  
    '''
    ..attachments = await getAttachments(images);
  // ..attachments = await Future.wait(images.map((imagePath) async {
  //   String filePath = imagePath;
  //   if (imagePath.startsWith('assets/')) {
  //     filePath = await getAssetFile(imagePath);
  //   }

  //   File file = File(filePath);
  //   if (!file.existsSync()) {
  //     print("File does not exist: $filePath");
  //   }
  //   return FileAttachment(file);
  // }));

  try {
    final sendReport = await send(message, smtpServer);
    print('Email sent: ${sendReport.toString()}');
  } catch (e) {
    print('Error sending email: $e');
  }
}
