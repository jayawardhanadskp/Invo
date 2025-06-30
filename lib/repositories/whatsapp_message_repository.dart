import 'package:url_launcher/url_launcher.dart';

class WhatsappMessageRepository {
  void sendWhatsAppMessage(String phone, String message) async {
  final url = Uri.parse("https://wa.me/$phone?text=${Uri.encodeComponent(message)}");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch WhatsApp';
  }
}
}
