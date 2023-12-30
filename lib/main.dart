import 'package:flutter/material.dart';
import 'package:wise_verbs/constants/theme.dart';
import 'package:wise_verbs/screens/launch_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkThemeData(context),
      themeMode: ThemeMode.dark,
      home: const LaunchScreen(),
    );
  }
}