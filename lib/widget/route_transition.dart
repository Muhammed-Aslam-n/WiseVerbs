
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

navPush(BuildContext context,Widget page,{String? routeName,Curve? curve}){
  if(routeName == null) {
    Navigator.push(context, PageTransition(  page,curve: curve));
  }else{
    Navigator.pushNamed(context, routeName);
  }
}

navPushReplace(BuildContext context,Widget page,{String? routeName,Curve? curve}){
  if(routeName == null) {
    Navigator.pushReplacement(context, PageTransition(  page,curve: curve));
  }else{
    Navigator.pushReplacementNamed(context, routeName);
  }
}

navPop(BuildContext context){
  Navigator.pop(context);
}





class PageTransition extends PageRouteBuilder {
  final Widget page;
  final Curve? curve;

  PageTransition(this.page, {this.curve})
      : super(
    pageBuilder: (context, animation, anotherAnimation) => page,
    transitionDuration: const Duration(milliseconds: 2000),
    transitionsBuilder: (context, animation, anotherAnimation, child) {
      animation = CurvedAnimation(
        curve: curve??Curves.fastLinearToSlowEaseIn,
        parent: animation,
      );
      return Align(
        alignment: Alignment.bottomCenter,
        child: SizeTransition(
          sizeFactor: animation,
          axisAlignment: 0,
          child: page,
        ),
      );
    },
  );
}
