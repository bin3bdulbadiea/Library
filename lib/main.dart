import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lib_app/firebase_options.dart';
import 'package:lib_app/pages/splash_page/splash_page.dart';
import 'package:lib_app/styles/themes.dart';

// ==============================================
// ----------------------------------------------
// .............( version => 1.0.0 ).............
// ----------------------------------------------
// ==============================================

void main() async {
  WidgetsFlutterBinding().accessibilityFeatures;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'المكتبة',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: themes,
      home: const SplashPage(),
    );
  }
}
