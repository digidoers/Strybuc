import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> sendEmailSMTP({
  required String firstName,
  required String lastName,
  required String email,
  required String messageData,
}) async {
  final smtpServer = gmail('info.digidoers@gmail.com', 'vceyaezfldwetjdq'); // Use an App Password

  final message = Message()
    ..from = Address('info.digidoers@gmail.com', 'Strybuc')
    ..recipients.add('digitester@yopmail.com')
    ..subject = 'Contact Sales Rep Inquiry'
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
