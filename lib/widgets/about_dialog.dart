import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> showKingdominoAboutDialog(BuildContext context) async {
  final packageInfo = await PackageInfo.fromPlatform();

  if (!context.mounted) return;

  showAboutDialog(
    context: context,
    applicationName: 'Kingdomino Score',
    applicationVersion: packageInfo.version,
    applicationLegalese:
    '''Drevet Olivier built the Kingdomino Score app under the GPL license Version 3. 
This SERVICE is provided by Drevet Olivier at no cost and is intended for use as is.
This page is used to inform visitors regarding the policy with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.
I will not use or share your information with anyone : Kingdomino Score works offline and does not send any information over a network. ''',
    applicationIcon: Image.asset(
      'android/app/src/main/res/mipmap-mdpi/ic_launcher.png',
    ),
  );
}