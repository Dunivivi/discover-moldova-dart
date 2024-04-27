import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    String appleUrl = 'https://maps.apple.com/?q=$latitude,$longitude';

    if (Platform.isAndroid) {
      if (await canLaunch(Uri.parse(googleUrl).toString())) {
        await launch(Uri.parse(googleUrl).toString());
      } else {
        throw 'Could not launch $googleUrl';
      }
    } else {
      var url =
          'comgooglemaps://?saddr=&daddr=$latitude,$longitude&directionsmode=driving';
      if (await canLaunch(Uri.parse(url).toString())) {
        await launch(Uri.parse(url).toString());
      } else if (await canLaunch(Uri.parse(appleUrl).toString())) {
        await launch(Uri.parse(appleUrl).toString());
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  static Future<void> openUrl(String url) async {
    final Uri finalUrl = Uri.parse(url);
    if (!await launch(finalUrl.toString())) {
      throw Exception('Could not launch ${finalUrl.toString()}');
    }
  }

  static Future<void> callPhone(String phone) async {
    Uri callUrl = Uri.parse('tel:=$phone');

    try {
      if (await canLaunch(callUrl.toString())) {
        // await launch(phoneNumber.toString());
        await launch(phone);
      } else {
        throw 'Could not launch $callUrl';
      }
    } catch(error) {
      print(error);
    }
  }
}
