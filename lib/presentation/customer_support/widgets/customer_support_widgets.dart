import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../resources/color_manager.dart';
import '../../resources/fonts_manager.dart';
import '../../resources/style_manager.dart';

class SendMessageToApp {
  static Future<void> launchWhatsapp(BuildContext context) async {
    var whatsapp = "+971544569679";
    var message = Uri.encodeComponent("Hello from Meshwark app");
    var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=$message";
    var whatsappURLIos = "https://wa.me/$whatsapp?text=$message";

    try {
      if (Platform.isIOS) {
        if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
          await launchUrl(Uri.parse(whatsappURLIos),
              mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not launch WhatsApp';
        }
      } else {
        if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
          await launchUrl(Uri.parse(whatsappURlAndroid),
              mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not launch WhatsApp';
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "WhatsApp is not installed",
            style: getSemiBoldStyle(
                color: ColorManager.white, fontSize: FontSize.s16),
          ),
          backgroundColor: ColorManager.darkPrimary,
        ));
      }
    }
  }

  static Future<void> launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(
          <String, String>{'subject': 'Support Request from Meshwark App'}),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch email';
    }
  }

  static Future<void> launchPhone(String phoneNumber) async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    } else {
      throw 'Could not launch phone';
    }
  }

  static Future<void> openUrl({required String url}) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  static String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
