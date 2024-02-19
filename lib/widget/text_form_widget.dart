import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wise_verbs/constants/constants.dart';

class TextFormWidget extends StatelessWidget {
  final String errorMsg, label, helperText;
  final int? maxLine, minLine;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Icon? icon;
  final TextInputType? keyboardType;
  final TextInputAction? inputAction;
  final AutovalidateMode? validateMode;
  final List<TextInputFormatter>? inputFormatter;
  final bool? outLineBorder;
  final bool isEditing;

  const TextFormWidget({
    Key? key,
    required this.errorMsg,
    required this.label,
    required this.helperText,
    required this.controller,
    required this.validator,
    required this.icon,required this.isEditing,
    this.keyboardType,
    this.inputAction,
    this.validateMode,
    this.inputFormatter,
    this.maxLine,
    this.minLine, this.outLineBorder,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.name,
      textInputAction: inputAction ?? TextInputAction.next,
      autovalidateMode: validateMode ?? AutovalidateMode.onUserInteraction,
      inputFormatters: inputFormatter ?? [],
      enabled: isEditing,
      maxLines: maxLine,
      minLines: minLine,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(top: 20),
        prefixIcon: icon,
        border: outLineBorder==true?outlineBorder.copyWith(borderRadius: BorderRadius.circular(8)):borderDecoration,
        label: Text(label,style: Theme.of(context).textTheme.bodySmall,),
        focusedBorder: outLineBorder==true?outlineBorder.copyWith(borderRadius: BorderRadius.circular(8)):borderDecoration,
        enabledBorder: outLineBorder==true?outlineBorder.copyWith(borderRadius: BorderRadius.circular(8)):borderDecoration,
        // errorBorder:
      ),
    );
  }
}
