import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise_verbs/constants/theme.dart';
import 'package:wise_verbs/providers/auth_provider/login_provider.dart';
import 'package:wise_verbs/providers/auth_provider/register_provider.dart';
import 'package:wise_verbs/providers/connectivity_provider.dart';
import 'package:wise_verbs/providers/home_screen_provider.dart';
import 'package:wise_verbs/providers/post_quote_provider.dart';
import 'package:wise_verbs/providers/profile_provider.dart';
import 'package:wise_verbs/providers/stt_provider.dart';
import 'package:wise_verbs/providers/tts_controller.dart';
import 'package:wise_verbs/providers/user_contribution_provider.dart';
import 'package:wise_verbs/screens/launch_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyAkPiBlm54E-8ASjcAFYSHHGeuvPE5sdqc',
            appId: '1:737961101452:android:ed84b5605007ea7cd3d3a9',
            messagingSenderId: '737961101452',
            projectId: 'wiseverbs-5195e',
            storageBucket: 'wiseverbs-5195e.appspot.com',
          ),
        )
      : await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (create) => ConnectivityProvider(),
        ),
        ChangeNotifierProvider(
          create: (create) => LoginProvider(),
        ),
        ChangeNotifierProvider(
          create: (create) => RegistrationProvider(),
        ),
        ChangeNotifierProvider(
          create: (create) => HomeScreenProvider(),
        ),
        ChangeNotifierProvider(
          create: (create) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (create) => TTSProvider(),
        ),
        ChangeNotifierProvider(
          create: (create) => PostQuoteProvider(),
        ),
        ChangeNotifierProvider(
          create: (create) => UserContributionProvider(),
        ),
        ChangeNotifierProvider(
          create: (create) => SpeechToUserTextProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
  ConnectivityProvider().initConnectivity();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      themeMode: ThemeMode.dark,
      home: const LaunchScreen(),
    );
  }
}
