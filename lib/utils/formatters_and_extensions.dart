import 'package:flutter/services.dart';

// class UsernameInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     final RegExp validCharacters = RegExp(r'^[a-zA-Z0-9._]*$');
//
//     if (newValue.text.isEmpty) {
//       return const TextEditingValue(); // Allow empty text
//     } else if (newValue.text.length > 15) {
//       // Return old value if the new value is too long
//       return oldValue.copyWith(text: oldValue.text);
//     } else if (!validCharacters.hasMatch(newValue.text)) {
//       // Return old value if the new value contains invalid characters
//       return oldValue.copyWith(text: oldValue.text);
//     } else {
//       // Allow the new value
//       return newValue;
//     }
//   }
// }
//
//
//
//
// extension UsernameValidator on String {
//   bool isValidUsername() {
//     // Customizable validation rules
//     final RegExp usernameRegex = RegExp(
//       r"^[a-zA-Z0-9_.]{3,15}$", // Adjust pattern as needed
//     );
//
//     return usernameRegex.hasMatch(this) && length >= 3 && length <= 15;
//   }
//
//   String? get invalidUsernameReason {
//     if (isEmpty) return "Username can't be empty";
//     if(length <3) return "Too short, need 3 characters at least";
//     if(length > 15) return "Too big, must be less that 15 characters";
//     if (!isValidUsername()) {
//       return "Only letters,numbers,periods,underscores\nare allowed"; // Adjust message as needed
//     }
//     return null;
//   }
// }
//
//
//

extension PasswordValidation on String {
  String? get invalidPasswordReason {
    if (isEmpty) return "Password can't be empty";
    if (length < 5) return "Password must be at least 5 characters long";
    if (length > 8) return "Password must be at most 8 characters long";
    if (contains(' ')) return "Password should not contain spaces";
    return null;
  }
}

class PasswordInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final RegExp noSpace = RegExp(r'^[^ ]*$');

    if (newValue.text.isEmpty) {
      return const TextEditingValue(); // Allow empty text
    } else if (newValue.text.length > 8) {
      // Return old value if the new value is too long
      return oldValue.copyWith(text: oldValue.text);
    } else if (!noSpace.hasMatch(newValue.text)) {
      // Return old value if the new value contains spaces
      return oldValue.copyWith(text: oldValue.text);
    } else {
      // Allow the new value
      return newValue;
    }
  }
}

extension EmailValidation on String {
  String? get invalidEmailReason {
    if (isEmpty) return "Email can't be empty";
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.+_-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    if (!emailRegex.hasMatch(this)) {
      return "Invalid email format";
    }
    return null;
  }
}
class EmailInputFormatter implements TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final regExp = RegExp(r'^[a-zA-Z0-9.@_-]+$');

    if (regExp.hasMatch(newValue.text)) {
      return newValue; // Return the new value if it matches the email pattern
    } else {
      // Return the old value if the new value doesn't match the pattern
      return oldValue;
    }
  }
}