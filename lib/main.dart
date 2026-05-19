import 'package:detect_text_from_image/bindings/app_binding.dart';
import 'package:detect_text_from_image/l10n/app_translations.dart';
import 'package:detect_text_from_image/theme/app_theme.dart';
import 'package:detect_text_from_image/view/scan_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Text Recognition',
      translations: AppTranslations(),
      locale: const Locale('tr', 'TR'),
      fallbackLocale: const Locale('en', 'US'),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialBinding: AppBinding(),
      home: const ScanView(),
    );
  }
}
