
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

navPush(BuildContext context,Widget page,{String? routeName,Curve? curve,Alignment? direction}){
  if(routeName == null) {
    Navigator.push(context, PageTransition(  page,curve: curve,direction: direction));
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
navPopCompletelyAndPush(BuildContext context,Widget page,{String? routeName,Curve? curve}){
  if(routeName == null) {
    Navigator.pushAndRemoveUntil(context, PageTransition(  page,curve: curve),(Route<dynamic> route) => false);
  }else{
    Navigator.pushNamedAndRemoveUntil(context, routeName,(route) => false,);
  }
}

navPop(BuildContext context){
  Navigator.pop(context);
}





class PageTransition extends PageRouteBuilder {
  final Widget page;
  final Curve? curve;
  final Alignment? direction;

  PageTransition(this.page, {this.curve,this.direction})
      : super(
    pageBuilder: (context, animation, anotherAnimation) => page,
    transitionDuration: const Duration(milliseconds: 2000),
    transitionsBuilder: (context, animation, anotherAnimation, child) {
      animation = CurvedAnimation(
        curve: curve??Curves.fastLinearToSlowEaseIn,
        parent: animation,
      );
      return Align(
        alignment: direction??Alignment.bottomCenter,
        child: SizeTransition(
          sizeFactor: animation,
          axisAlignment: 0,
          child: page,
        ),
      );
    },
  );
}
