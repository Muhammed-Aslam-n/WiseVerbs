import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise_verbs/constants/constants.dart';
import 'package:wise_verbs/screens/contribution/contribution.dart';
import 'package:wise_verbs/screens/home/home_screen.dart';
import 'package:wise_verbs/screens/index/post_quote_screen.dart';
import 'package:wise_verbs/screens/index/stt_quote_screen.dart';
import 'package:wise_verbs/widget/connectivity_unavailable_widget.dart';
import 'package:wise_verbs/widget/route_transition.dart';

import '../../providers/connectivity_provider.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({Key? key}) : super(key: key);

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  int selectedIndex = 1;

  changeIndex(index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final _naveScreens = [
    const HomeScreen(),
    const UserContributionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
        builder: (context, connectivityProvider, _) {
      if (connectivityProvider.isConnected == false) {
        return const ConnectivityUnavailableWidget();
      }
      return Scaffold(
        body: SafeArea(
          child: _naveScreens[selectedIndex],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  navIcon1,
                  height: 25,
                  color: selectedIndex == 0
                      ? Theme.of(context)
                          .bottomNavigationBarTheme
                          .selectedItemColor
                      : Theme.of(context)
                          .bottomNavigationBarTheme
                          .unselectedItemColor,
                ),
                label: '',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_2,
                  size: 30,
                ),
                label: '',
              ),
            ],
            onTap: changeIndex,
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex,
          ),
        ),
        floatingActionButton: SizedBox(
          // color: Colors.green,
          height: 150,
          width: 200,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    debugPrint('HI');
                    showOption = !showOption;
                    setState(() {});
                  },
                  backgroundColor: Colors.white,
                  tooltip: 'Share your thoughts',
                  foregroundColor: Colors.blueGrey,
                  child: Icon(
                    showOption ? Icons.menu : Icons.add,
                    // color: Colors.black,
                  ),
                ),
                if (showOption)
                  roundedStackButtonWidget(
                      bottom: 15,
                      right: 100,
                      imagePath: ttsPostIcon,
                      onPressed: () {
                        navPush(
                            context,
                            const PostQuoteScreen(
                              isTtsEnabled: true,
                            ));

                        setState(() {
                          showOption = !showOption;
                        });
                      }),
                if (showOption)
                  roundedStackButtonWidget(
                      bottom: 67,
                      right: 60,
                      isIcon: true,
                      icon: Icons.edit,
                      onPressed: () {
                        navPush(
                            context,
                            const PostQuoteScreen(
                              isTtsEnabled: false,
                            ));
                        setState(() {
                          showOption = !showOption;
                        });
                      }),
                // if (showOption)
                //   roundedStackButtonWidget(
                //       right: 0,
                //       bottom: 90,
                //       imagePath: sttPostIcon,
                //       onPressed: () {
                //         navPush(context, STTQuoteScreen());
                //         setState(() {
                //           showOption = !showOption;
                //         });
                //       }),
              ],
            ),
          ),
        ),
      );
    });
  }

  bool showOption = false;

  Widget roundedStackButtonWidget({
    double? bottom,
    double? right,
    double? left,
    double? top,
    VoidCallback? onPressed,
    IconData? icon,
    Color? bgColor,
    bool? isIcon,
    String? imagePath,
  }) {
    return Positioned(
      bottom: bottom,
      right: right,
      left: left,
      top: top,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor ?? Colors.teal,
        ),
        child: IconButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          icon: isIcon == true
              ? Icon(
                  icon,
                  color: Colors.white,
                  size: 30,
                )
              : imagePath != null
                  ? Image.asset(
                      imagePath,
                      width: 50,
                      color: Colors.white,
                    )
                  : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
