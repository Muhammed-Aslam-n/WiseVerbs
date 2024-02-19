import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise_verbs/constants/constants.dart';
import 'package:wise_verbs/providers/auth_provider/login_provider.dart';
import 'package:wise_verbs/screens/auth_screen/get_started_screen.dart';
import 'package:wise_verbs/screens/index/index.dart';
import 'package:wise_verbs/service/shared_preference.dart';
import 'package:wise_verbs/widget/route_transition.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen>
    with TickerProviderStateMixin {
  bool launchScreenCompleted = false;

  double _fontSize = 2;
  double _containerSize = 1.5;
  double _textOpacity = 0.0;
  double _containerOpacity = 0.0;

  late AnimationController _controller;
  late Animation<double> animation1;
  bool showSubText = true;
  bool isLoggedIn = false;

  @override
  void initState() {
    navigateToAppropriateScreen();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    animation1 = Tween<double>(begin: 40, end: 20).animate(CurvedAnimation(
        parent: _controller, curve: Curves.fastLinearToSlowEaseIn))
      ..addListener(() {
        setState(() {
          _textOpacity = 1.0;
        });
      });

    _controller.forward();

    Timer(const Duration(seconds: 2), () {
      setState(() {
        _fontSize = 1.06;
        if (_fontSize == 1.06) {
          showSubText = false;
        }
      });
    });

    Timer(const Duration(seconds: 2), () {
      setState(() {
        _containerSize = 2;
        _containerOpacity = 1;
      });
    });

    Timer(const Duration(seconds: 4), () {
      setState(() {
        //
        launchScreenCompleted = true;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return launchScreenCompleted
          ? Consumer<LoginProvider>(builder: (builder, authProvider, _) {
              debugPrint('User Login state changed ${authProvider.user}');
              if (authProvider.user == null) {
                debugPrint('showingGetStartedScreen');
                return const GetStartedScreen();
              } else {
                debugPrint('showingIndexScreen');
                return const IndexScreen();
              }
            })
          : Scaffold(
            body: Stack(
                children: [
                  Column(
                    children: [
                      AnimatedContainer(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.fastLinearToSlowEaseIn,
                          height: height / _fontSize),
                    ],
                  ),
                  Center(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 2000),
                      curve: Curves.fastLinearToSlowEaseIn,
                      opacity: _containerOpacity,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 2000),
                        curve: Curves.fastLinearToSlowEaseIn,
                        height: width / _containerSize,
                        width: width / _containerSize,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Image(
                          image: AssetImage(launchLogo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          );
  }

  void navigateToAppropriateScreen() async {
    isLoggedIn = await SharedPreferenceHelper.checkWhetherLoggedOrNot();
    debugPrint('isLoggedIn $isLoggedIn');
    setState(() {});
  }
}
