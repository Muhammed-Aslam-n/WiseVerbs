import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise_verbs/constants/theme.dart';
import 'package:wise_verbs/providers/connectivity_provider.dart';
import 'package:wise_verbs/providers/stt_provider.dart';
import 'package:wise_verbs/providers/tts_controller.dart';
import 'package:wise_verbs/screens/launch_screen.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (create) => ConnectivityProvider(),
        ),
        ChangeNotifierProvider(
          create: (create) => TTSProvider(),
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
