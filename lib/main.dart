import 'dart:io';

import 'package:ethiotel/bindings/main_bindings.dart';
import 'package:ethiotel/bindings/pkgs_bindings.dart';
import 'package:ethiotel/home_page.dart';
import 'package:ethiotel/translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

Future<void> main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SnapApp());
}

class SnapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Snap Ethio Telecom',
      home: HomePage(),
      locale: Locale("am"),
      fallbackLocale: Locale('en', 'UK'),
      initialBinding: MainBinding(),
      translations: MTranslations(),
      defaultTransition: Transition.rightToLeftWithFade,
      supportedLocales: [
        const Locale('en', ''),
        const Locale('am', ''),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
