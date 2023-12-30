import 'package:flutter/material.dart';
import 'dart:math';

import '../constants/constants.dart';
class LoadingWidget extends StatelessWidget {
  final double? height,width;
  final String? path;
  const LoadingWidget({Key? key, this.height, this.width, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset(path??pickLoadingAsset(),height: height??200,width: width??100,));
  }

  String pickLoadingAsset(){
    final int index = Random().nextInt(7);
    return loadingAssetFiles[1];
  }
}
