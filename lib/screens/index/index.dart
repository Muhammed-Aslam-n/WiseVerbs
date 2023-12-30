import 'package:flutter/material.dart';
import 'package:wise_verbs/constants/constants.dart';
import 'package:wise_verbs/screens/contribution/contribution.dart';
import 'package:wise_verbs/screens/home/home_screen.dart';

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
      floatingActionButton: Container(
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
                  showOption?Icons.menu:Icons.add,
                  // color: Colors.black,
                ),
              ),
              if (showOption)
                Positioned(
                  bottom: 15,
                  right: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.teal,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      icon: Image.asset(ttsPostIcon,width: 50,color: Colors.white),
                    ),
                  ),
                ),
              if (showOption)
                Positioned(
                  bottom: 67,
                  right: 60,
                  child: Container(decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.teal,
                  ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              if (showOption)
                Positioned(
                  bottom: 90,
                  right: 0,
                  child: Container(decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.teal,
                  ),
                    child: IconButton(
                      onPressed: () {},padding: EdgeInsets.zero,
                      icon: Image.asset(sttPostIcon,width: 50,color: Colors.white,),
                    ),
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }

  bool showOption = false;
}
