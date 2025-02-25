import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:strybuc/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> sendEmailSMTP({
  required String firstName,
  required String lastName,
  required String email,
  required String messageData,
}) async {
  final String salesEmail = AppConfig.salesEmail;
  final String appPassword = AppConfig.appPassword;
  final prefs = await SharedPreferences.getInstance();
  final String customerId = prefs.getString('login') ?? 'Guest User'; // Ensure correct key is used
  final smtpServer = gmail(salesEmail, appPassword); // Use an App Password

  final message = Message()
    ..from = Address(salesEmail, 'Strybuc')
    ..recipients.add('digitester@yopmail.com')
    ..subject = 'Strybuc App - Customer ID # $customerId'
    ..text = '''
    Hello Team,  

    You have received a new inquiry from a customer. Below are the details:  

    FIRST NAME: $firstName  
    LAST NAME:  $lastName  
    EMAIL:      $email  
    MESSAGE:    $messageData  
    ''';

  try {
    final sendReport = await send(message, smtpServer);
    print('Email sent: ${sendReport.toString()}');
  } catch (e) {
    print('Error sending email: $e');
  }
}
