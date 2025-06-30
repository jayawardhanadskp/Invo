import 'package:url_launcher/url_launcher.dart';

class WhatsappMessageRepository {
  Future<void> sendWhatsAppMessage(String phone, String message) async {
    final url = Uri.parse("https://wa.me/$phone?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(url)) {
      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication, 
      );

      if (!launched) {
        throw 'Could not open WhatsApp';
      }
    } else {
      throw 'Could not launch WhatsApp';
    }
  }
}
