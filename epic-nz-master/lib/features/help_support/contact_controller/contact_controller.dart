import 'package:epic_nz/core/service/contact_service.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactController extends GetxController {
  final adminEmail = ContactService.adminEmail.obs;
  final adminPhone = ContactService.adminPhone.obs;

  Future<void> openEmailApp() async {
    final email = adminEmail.value.trim();

    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Support Request',
        'body': 'Hi Support Team,\n\n',
      },
    );

    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      Get.snackbar("Error", "Could not open email app");
    }
  }

  Future<void> openPhoneDialer() async {
    String phone = adminPhone.value.trim();

    phone = phone.replaceAll(RegExp(r'\s|-'), '');

    if (!phone.startsWith('+')) {
      if (phone.startsWith('0')) {
        phone = phone.substring(1);
      }
      phone = '+64$phone';
    }

    final uri = Uri(scheme: 'tel', path: phone);

    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!ok) {
      Get.snackbar("Error", "Could not open phone dialer");
    }
  }
}
