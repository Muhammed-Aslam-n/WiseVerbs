import 'package:flutter/material.dart';
import 'package:wise_verbs/constants/constants.dart';

class ConnectivityUnavailableWidget extends StatelessWidget {
  const ConnectivityUnavailableWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: width * 0.6,
                ),
                Image.asset(sadFaceGif,width: width * 0.3,height: width * 0.3,),

                SizedBox(
                  height: width * 0.12,
                ),
                Text('No Connectivity found',style: Theme.of(context).textTheme.bodyLarge,),
                SizedBox(height: width * 0.05,),
                Text('Please connect to network',style: Theme.of(context).textTheme.bodySmall,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
