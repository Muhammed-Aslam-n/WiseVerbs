import 'package:flutter/material.dart';

class UserContributionScreen extends StatelessWidget {
  const UserContributionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/icons/quoteBg.png',
              ),
              fit: BoxFit.fill,
            ),
          ),

          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
          child: Container(margin: EdgeInsets.symmetric(horizontal: 10,vertical: 15),child: Text('User Contributkasdjuaedfuyefions')),
        ),
      ),
    );
  }
}
