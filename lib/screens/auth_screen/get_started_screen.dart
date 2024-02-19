import 'package:flutter/material.dart';
import 'package:wise_verbs/constants/constants.dart';
import 'package:wise_verbs/screens/auth_screen/login_screen.dart';
import 'package:wise_verbs/widget/outlined_button.dart';
import 'package:wise_verbs/widget/route_transition.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: width * 0.3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Image.asset(
                    introBgImage,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  SizedBox(
                    height: width * 1.2,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'WiseVerbs - a simple Quote sharing app designed for spreading wonderfulness in thoughts',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.apply(fontFamily: quoteFont9),
                    ),
                  ),
                  SizedBox(height: width * 0.12,),
                  Center(
                    child: OutlinedButtonWidget(
                      onPressed: () {
                        navPushReplace(context, const LoginScreen());
                      },
                      text: 'Get Started',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
