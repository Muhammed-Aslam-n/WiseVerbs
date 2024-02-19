import "dart:math";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "../constants/constants.dart";

Map<String, dynamic> quoteCardThemePicker() {
  final index = Random().nextInt(9);
  final theme = colorListForQuote[index];
  theme['quoteFont'] = quoteFonts[index != 0 ? index - 1 : index];
  return theme;
}

final List<TextInputFormatter> nameInputFormatter = [
  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
];

final List<TextInputFormatter> occupationInputFormatter = [
  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
];

final List<TextInputFormatter> name2InputFormatter = [
  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
];

final List<TextInputFormatter> quoteInputFormatter = [
  LengthLimitingTextInputFormatter(100), // Example: Limiting to 100 characters
];

final List<TextInputFormatter> aboutYouInputFormatter = [
  LengthLimitingTextInputFormatter(200), // Example: Limiting to 200 characters
];

showSimpleOneliner(
  BuildContext context,
  String message,
    {
  bool success = true,
}) {
  showDialog(
    context: context,
    builder: (builder) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Container(
          // height: 60,
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8,),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: success?Colors.green:Colors.redAccent),
              ),const SizedBox(height: 18,),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Got it',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

showSimpleAlertPopup(
  BuildContext context,
  message,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (builder) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Got it',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      );
    },
  );
}

showAlertPopupWithOptions(
    {required BuildContext context,
    required Widget title,
    required List<Widget> message,
    required List<Widget> actions}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (builder) {
      return AlertDialog(
        title: title,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [...message],
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        actions: actions,
      );
    },
  );
}

showToast(
  BuildContext context,
  String message, {
  Color? messageColor,
  Color? bgColor,
  Color? textColor,
  bool info = false,
  success = false,
  failure = false,
}) {
  if (context.mounted) {
    final SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(15),
        backgroundColor: info
            ? Colors.orange
            : success
                ? Colors.green
                : failure
                    ? Colors.redAccent
                    : bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        content: Text(
          message,
          style: TextStyle(color: messageColor ?? Colors.white),
        ));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class FadeInAnimation extends StatefulWidget {
  final Widget child;

  const FadeInAnimation({super.key, required this.child});

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

showSuccessPopup({required BuildContext context, required String message}) {
  showDialog(
      context: context,
      builder: (builder) => Dialog(
            child: Container(
              height: 70,
              width: 100,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.teal),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    const Icon(Icons.check)
                  ],
                ),
              ),
            ),
          ));
}

final Shader linearGradient = const LinearGradient(
  colors: <Color>[Color(0xFFf5ec99), Color(0xFFc3a660)],
).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

String getErrorMessageFromErrorCode(String errorCode) {
  switch (errorCode) {
    case 'invalid-credential':
      return 'Invalid credentials';
    case 'invalid-email':
      return 'Please enter a valid email address.';
    case 'user-disabled':
      return 'Your account has been disabled. Please contact support.';
    case 'user-not-found':
      return 'No account found with this email.';
    case 'wrong-password':
      return 'Incorrect password. Please try again.';
    case 'weak-password':
      return 'The password is too weak. Please choose a stronger one.';
    case 'email-already-in-use':
      return 'An account already exists with this email.';
    case 'operation-not-allowed':
      return 'This operation is not allowed.';
    case 'requires-recent-login':
      return 'Please logout and log in again to continue';
    case 'too-many-requests':
      return 'Too many requests. Please try again later.';
    case 'network-request-failed':
      return 'Network error. Please check your internet connection.';
    default:
      return 'An unknown error occurred. Please try again.';
  }
}
