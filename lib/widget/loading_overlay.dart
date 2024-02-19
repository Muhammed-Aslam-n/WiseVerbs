import 'package:flutter/material.dart';

import '../constants/constants.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            // height: 50,width: 50,
            color: Colors.black.withOpacity(0.5),
            // Adjust opacity for blur effect
            child: Center(
              child: Image.asset(
                loadingAssetFiles[5],
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
      ],
    );
  }
}
