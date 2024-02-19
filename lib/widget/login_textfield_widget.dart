import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthFormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final bool? filled, enabled;
  final String hintText;
  final List<TextInputFormatter> formatters;
  final bool obscureText;
  final int? minLines, maxLines;
  final TextInputAction? textInputAction;
  final VoidCallback? onTap, onEditingComplete;
  final void Function(String)? onChanged, onFieldSubmitted;
  final void Function(String?)? onSaved;
  final void Function(PointerDownEvent)? onTapOutSide;
  final TextInputType? keyboardType;

  const AuthFormTextField({
    Key? key,
    required this.controller,
    required this.validator,
    required this.hintText,
    required this.formatters,
    required this.obscureText,
    this.filled,
    this.fillColor,
    this.minLines,
    this.maxLines,
    this.textInputAction,
    this.onTap,
    this.onChanged,
    this.onSaved,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onTapOutSide,
    this.enabled,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade900));
    return TextFormField(
      controller: controller,
      validator: validator,
      minLines: minLines,
      maxLines: maxLines ?? 1,
      textInputAction: textInputAction ?? TextInputAction.next,
      decoration: InputDecoration(
        fillColor: fillColor ?? Colors.grey.shade900,
        filled: true,
        border: border,
        focusedBorder: border,
        enabledBorder: border,
        enabled: enabled ?? true,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        hintText: '  $hintText',
      ),
      inputFormatters: formatters,
      obscureText: obscureText,
      onTap: onTap,
      onChanged: onChanged,
      onSaved: onSaved,
      onFieldSubmitted: onFieldSubmitted,
      onEditingComplete: onEditingComplete,
      onTapOutside: onTapOutSide,
      keyboardType: keyboardType ?? TextInputType.name,
    );
  }
}
