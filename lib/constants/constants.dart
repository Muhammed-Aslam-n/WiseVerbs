import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarningColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const Color darkPrimaryColor = Colors.black;
const Color darkSecondaryColor = Color(0xffe7eae7);
const Color dodgerBlue = Color(0xFF005A9C);

const defaultPadding = 20.0;

const appName = 'WiseVerbs';
const appFont = 'Poppins';
const appFont2 = 'RubikMaps';

const quoteFont1 = 'Caveat';
const quoteFont2 = 'DancingScript';
const quoteFont3 = 'EBGaramond';
const quoteFont4 = 'GreatVibes';
const quoteFont5 = 'LibreBaskerville';
const quoteFont6 = 'Merriweather';
const quoteFont7 = 'Pacifico';
const quoteFont8 = 'PlayfairDisplay';
const quoteFont9 = 'RobotoCondensed';
const quoteFont10 = 'Sacramento';

const appIconPath = 'assets/app_icon/app_icon.jpg';
const introBgImage = 'assets/launch_icon/intro_icon.png';
const launchLogo = 'assets/launch_icon/launch_icon.png';
const navIcon1 = 'assets/icons/popular_icon.png';
const likeButton = 'assets/icons/likeIcon.png';
const ttsPostIcon = 'assets/icons/text_to_speech.png';
const sttPostIcon = 'assets/icons/speech_to_text1.png';

const sadFaceGif = 'assets/gifs/sad_face.gif';
const listeningGif = 'assets/gifs/listening_gif.gif';

const requiredField = "This field is required";
const invalidEmail = "Enter a valid email address";

const List<String> loadingAssetFiles = [
  'assets/gifs/loading_gif_1.gif',
  'assets/gifs/loading_gif_2.gif',
  'assets/gifs/loading_gif_3.gif',
  'assets/gifs/loading_gif_4.gif',
  'assets/gifs/loading_gif_5.gif',
  'assets/gifs/loading_gif_6.gif',
  'assets/gifs/loading_gif_7.gif',
  'assets/gifs/loading_gif_8.gif',
];


List<String> quoteCategories = [
  'Inspirational',//
  'Motivational',//
  'Love',//
  'Life',//
  'Success',//
  'Wisdom',
  'Happiness',
  'Friendship',
  'Humor/Funny',
  'Courage',
  'Hope',
  'Gratitude',
  'Change',
  'Creativity',
  'Passion',
  'Faith/Spirituality',
  'Ambition',
  'Reflection',
  'Empowerment',
  'Mindfulness',//
];

const noUsernameMsg = 'Please enter a username';
const noPasswordMsg = 'Please enter a password';
const noConfirmPassMsg = 'Please confirm your password';
const noEmailMsg = 'Please enter your email';

const InputDecoration otpInputDecoration = InputDecoration(
  filled: false,
  border: UnderlineInputBorder(),
  hintText: "0",
);

final List<String> quoteFonts = [
  quoteFont1,
  quoteFont2,
  quoteFont3,
  quoteFont4,
  quoteFont5,
  quoteFont6,
  quoteFont8,
  quoteFont9,
  quoteFont10
];

final List<Map<String, dynamic>> colorListForQuote = [
  {
    'quoteColor': Colors.blue.shade900,
    'ownerColor': Colors.redAccent,
    'iconColor': Colors.orange,
    'bgColor': Colors.orange.shade100,
  },
  {
    'quoteColor': Colors.red.shade900,
    'ownerColor': Colors.white,
    'iconColor': Colors.green,
    'bgColor': Colors.green.shade100,
  },
  {
    'quoteColor': Colors.green.shade900,
    'ownerColor': Colors.white,
    'iconColor': Colors.yellow.shade800,
    'bgColor': Colors.yellow.shade100,
  },
  {
    'quoteColor': Colors.purple.shade900,
    'ownerColor': Colors.white,
    'iconColor': Colors.blue.shade300,
    'bgColor': Colors.blue.shade100,
  },
  {
    'quoteColor': Colors.yellow.shade900,
    'ownerColor': Colors.white,
    'iconColor': Colors.green.shade300,
    'bgColor': Colors.green.shade100,
  },
  {
    'quoteColor': Colors.teal.shade900,
    'ownerColor': Colors.white,
    'iconColor': Colors.orange.shade300,
    'bgColor': Colors.orange.shade100,
  },
  {
    'quoteColor': Colors.orange.shade900,
    'ownerColor': Colors.white,
    'iconColor': Colors.pink.shade300,
    'bgColor': Colors.pink.shade100,
  },
  {
    'quoteColor': Colors.pink.shade900,
    'ownerColor': Colors.white,
    'iconColor': Colors.purple.shade300,
    'bgColor': Colors.purple.shade100,
  },
  {
    'quoteColor': Colors.indigo.shade900,
    'ownerColor': Colors.white,
    'iconColor': Colors.teal.shade300,
    'bgColor': Colors.teal.shade100,
  },
  {
    'quoteColor': Colors.cyan.shade900,
    'ownerColor': Colors.white,
    'iconColor': Colors.red.shade300,
    'bgColor': Colors.red.shade100,
  },
];

const borderDecoration =
    UnderlineInputBorder(borderSide: BorderSide(color: Colors.white60));
const outlineBorder = OutlineInputBorder(
  borderSide: BorderSide(
    width: 0.3,
    color: Colors.white,
  ),
);

const nameErrorMsg = 'Name is required';
const genderErrorMsg = 'Gender is required';
const occupationErrorMsg = 'Occupation is required';
const selfDescErrorMsg = 'Description is required';
const favouriteQuoteErrorMsg = 'Favourite quote is required';
const mostInfluencedErrorMsg = 'Most influenced person is required';

const quoteErrorMsg = '    Please quote something to post';
const authorErrorMsg = 'Author cannot be empty';

const emptyQuoteAlert = 'Please write something to try it out';

const String somethingWW = 'Something went wrong. Please try again later';

class UpdateProfileConstants {
  static const String appBarTitle = 'Update Profile';
  static const String emailHintText = 'New Email';
  static const String currentPasswordHint = 'Current Password';
  static const String verifyEmailText = 'Verify Email';
  static const String confirmVerification = 'Confirm Verification';
  static const String updateEmail = 'Update Email';

  static const String newPassword = 'New password';
  static const String confirmNewPass = 'Confirm new password';
  static const String updatePass = 'Update Password';

  static const String someErrorOccurred =
      'Some error occurred. Try again later';
  static const String emailVerifiedSuccess = 'Email verified successfully';
  static const String verifyNewMail =
      'New mail has been updated. Please verify it';
  static const String verifyMailSendingFailed =
      'Failed to send verification Mail';
  static const String verificationMailSent =
      'A verification mail has been sent to you new mail';
  static const String failedNewMailVerification = 'Failed to verify new Mail';
  static const String newMailVerified = 'Your new mail has been verified';

  static const String passUpdateFailed = 'Failed to update new Password';
  static const String passChangedSuccess = 'Password Changed successfully';
}

class CreateNewQuote {
  static const String appBarTitle = 'Create new Quote';
  static const String updateAppBarTitle = 'Update your Quote';
  static const String enterQuoteHint = '   You quote goes here...';
  static const String creditText = 'Author :';
  static const String myselfCred = 'Myself';
  static const String categoryText = 'Category: ';
  static const String termsAndCondition1 =
      'By continuing this, you acknowledge and agree that the app and its creator will not be held responsible for any outcomes or consequences resulting from this action, and any quote shared is solely owned by the posting user';
  static const String termsAndCondition2 =
      'The creator has made efforts to ensure that no offensive or inappropriate content is shared.';
  static const String shareQuoteReq = 'Allow others to share this Quote';

  static const String importFromFile = 'Import from file';
  static const String postQuote = 'Post';
  static const String editQuote = 'Update';

  static const String fileOpenUnable =
      'Sorry, Unable to read quote from this file.Try again later';

  static const String postingFailed =
      'Sorry, Unable to post this quote. Please try again';
  static const String postSuccess = 'Posted Successfully';
  static const String updateSuccess = 'Updated Successfully';
}

class UserContributionConstants{
  static const String screenSubjectText = "Quotes you've shared";
  // static const String = '';
  // static const String = '';
  // static const String = '';
  // static const String = '';
  // static const String = '';
  // static const String = '';
  // static const String = '';
  // static const String = '';
  // static const String = '';
  // static const String = '';
  // static const String = '';
  // static const String = '';
  // static const String = '';
  // static const String = '';
}

void printSuccess(String message) {
  if (kDebugMode) {
    print('\x1B[32m$message\x1B[0m');
  }  // Green for success
}

void printError(String message) {
  if (kDebugMode) {
    print('\x1B[31m$message\x1B[0m');
  }  // Red for error
}


// void printWarning(String message) {
//   if (kDebugMode) {
//     print('\x1B[35m$message\x1B[0m');
//   }  // Red for error
// }

void printInfo(String message) {
  if (kDebugMode) {
    print('\x1B[34m$message\x1B[0m');
  }  // Red for error
}
