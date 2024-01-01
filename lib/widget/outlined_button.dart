import 'package:flutter/material.dart';

class OutlinedButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? bgColor, textColor;
  final EdgeInsets? padding;
  final String text;
  final bool? invert;

  const OutlinedButtonWidget(
      {Key? key,
      required this.onPressed,
      this.bgColor,
      this.textColor,
      this.padding,
      required this.text,
      this.invert = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor:
            invert == true ? Colors.black : bgColor ?? Colors.white,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.apply(
              color: invert == true ? Colors.white : textColor ?? Colors.black,
            ),
      ),
    );
  }
}

class OutlinedIconButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? bgColor, iconColor,borderColor;
  final double? iconSize,btnWidth,btnHeight;
  final EdgeInsets? padding, iconPadding;
  final bool? invert, showOutline;

  const OutlinedIconButtonWidget({
    Key? key,
    required this.onPressed,
    this.bgColor,
    this.padding,
    this.invert = false,
    required this.icon,
    this.iconColor,
    this.iconSize,
    this.iconPadding,
    this.showOutline, this.borderColor, this.btnWidth, this.btnHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor:
            invert == true ? Colors.black : bgColor ?? Colors.white,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
        side: BorderSide(color: borderColor??Colors.white),
        fixedSize: Size(btnWidth??80, btnHeight??20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Icon(
        icon,
        color: invert == true
            ? iconColor ?? Colors.white
            : iconColor ?? Colors.black,
        size: iconSize,
      ),
    );
  }
}
