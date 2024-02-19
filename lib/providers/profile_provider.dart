import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wise_verbs/models/register_user_model.dart';

import '../service/shared_preference.dart';
import '../utils/utils.dart';
import 'auth_provider/register_provider.dart';

enum UpdatePassCredEnum {
  initial,
  mailSent,
  mailNotVerified,
  mailVerified,
}

class ProfileProvider extends ChangeNotifier {
  static final ProfileProvider _instance = ProfileProvider._internal();

  factory ProfileProvider() => _instance;

  ProfileProvider._internal() {
    isEditing = false;
    debugPrint('isEditingValueChangesToFalseInConstructor $isEditing');
    FirebaseAuth.instance.currentUser?.reload();
    notifyListeners();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController favQuoteController = TextEditingController();
  TextEditingController mostInfController = TextEditingController();

  XFile? pickedFile;

  CroppedFile? croppedFile;

  bool isLoading = false;
  bool isEditing = false;
  RegisterUserModel? userProfileData;

  changeEditStatus(bool status) {
    isEditing = status;
    // if(isEditing){
    nameController.text = userProfileData!.name;
    occupationController.text = userProfileData!.occupation;
    descriptionController.text = userProfileData!.aboutYou;
    favQuoteController.text = userProfileData!.favQuote;
    mostInfController.text = userProfileData!.inspiration;
    croppedFile = null;
    // }
    notifyListeners();
  }

  changeCroppedFile(CroppedFile newFile) {
    croppedFile = newFile;
    notifyListeners();
  }

  Future<RegisterUserModel?> fetchUserProfileData() async {
    debugPrint('fetchingUserData');
    try {
      isLoading = true;
      // notifyListeners();
      final user = _auth.currentUser;
      if (user == null) return null; // handle not logged in

      final docSnapshot = await FirebaseFirestore.instance
          .collection(FirebaseReferences.firestoreUserRef)
          .doc(user.uid)
          .get();
      debugPrint('fetched UserData ${jsonEncode(docSnapshot.data())}');
      if (docSnapshot.data() == null) {
        return null;
      }
      userProfileData = RegisterUserModel.fromJson(docSnapshot.data()!);
      final storeUserProfile =
      await SharedPreferenceHelper.saveProfileData(RegisterUserModel.fromJson(docSnapshot.data()!));
      if (storeUserProfile) {
        debugPrint('ProfileData Update');
      } else {
        debugPrint('ProfileData Not Updated');
      }
      isLoading = false;
      isEditing = false;
      notifyListeners();
      changeEditStatus(false);
      return userProfileData;
    } on FirebaseException catch (exc, stack) {
      debugPrint('ExceptionCaughtWhileFetchingUserProfileData $exc\n $stack');
      // final errorMessage = getErrorMessageFromErrorCode(exc.code);
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  updateUserProfile({
    required RegisterUserModel updateData,
    required bool profilePicUpdating,
  }) async {
    debugPrint('fetchingUserData');
    try {
      isLoading = true;
      notifyListeners();
      final user = _auth.currentUser;
      if (user == null) return null;

      debugPrint(
          'UpdatingUserProfile -\n isProfilePicUpdating $profilePicUpdating \n detailsUpdating ${updateData.toJson()}');

      if (profilePicUpdating) {
        final imageUrlFromStorage =
            await _uploadProfilePicToStorage(File(updateData.profilePicture));
        updateData.profilePicture = imageUrlFromStorage!;
      }

      await FirebaseFirestore.instance
          .collection(FirebaseReferences.firestoreUserRef)
          .doc(user.uid)
          .update(
            updateData.toJson(),
          );
      await fetchUserProfileData();
      isLoading = false;
      isEditing = false;
      notifyListeners();
      return true;
    } on FirebaseException catch (exc, stack) {
      debugPrint('ExceptionCaughtWhileFetchingUserProfileData $exc\n $stack');
      final errorMessage = getErrorMessageFromErrorCode(exc.code);
      isLoading = false;
      notifyListeners();
      return errorMessage;
    }
  }

  Future<String?> _uploadProfilePicToStorage(File imageFile) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child(FirebaseReferences.refProfilePic)
        .child(FirebaseReferences.profilePicName(_auth.currentUser!.uid));
    final uploadTask = storageRef.putFile(imageFile);
    final downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  /// ---------------------------------------------------------------------------------------------------

  TextEditingController newEmailController =
      TextEditingController(text: 'muhammedaslamn210@gmail.com');
  TextEditingController currentEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController currentPasswordController =
      TextEditingController(text: 'Aslam123');

  // bool isPasswordUpdating = false;
  UpdatePassCredEnum updateState = UpdatePassCredEnum.initial;
  String currentEmail = '';

  changeEmailVerifiedStatus(UpdatePassCredEnum status) {
    updateState = status;
    notifyListeners();
  }

  checkNewEmailIsSame() async {
    debugPrint(
        'checkNewEmailIsSameFnCalled \n NewEmail ${newEmailController.text} \n $FirebaseAuth.instance.currentUser ');

    if (FirebaseAuth.instance.currentUser != null) {
      if (newEmailController.text.toLowerCase() ==
          FirebaseAuth.instance.currentUser?.email?.toLowerCase()) {
        updateState = UpdatePassCredEnum.mailVerified;
        notifyListeners();
      } else {
        updateState = UpdatePassCredEnum.mailNotVerified;
        notifyListeners();
      }
    }
  }

  bool isSomethingGoingOn = false;

  updateNewEmail() async {
    try {
      isSomethingGoingOn = true;
      notifyListeners();
      debugPrint(
          'isUser ${FirebaseAuth.instance.currentUser?.email} - MailVerifiedAlready ${FirebaseAuth.instance.currentUser?.emailVerified}');

      final credential = EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!,
        password: currentPasswordController.text,
      );
      await FirebaseAuth.instance.currentUser?.reload();
      await FirebaseAuth.instance.currentUser
          ?.reauthenticateWithCredential(credential)
          .then((reCred) async {
        await FirebaseAuth.instance.currentUser
            ?.verifyBeforeUpdateEmail(newEmailController.text);
        await FirebaseAuth.instance.currentUser
            ?.updateEmail(newEmailController.text.toLowerCase());
        await FirebaseAuth.instance.currentUser?.reload();
        if (FirebaseAuth.instance.currentUser != null &&
            FirebaseAuth.instance.currentUser!.emailVerified) {
          updateState = UpdatePassCredEnum.mailVerified;
          isSomethingGoingOn = false;
          notifyListeners();
          return true;
        } else {
          updateState = UpdatePassCredEnum.mailNotVerified;
          isSomethingGoingOn = false;
          notifyListeners();
          return false;
        }
      });
    } on FirebaseException catch (exc, stack) {
      debugPrint('ExceptionCaughtWhileUpdatingMail $exc\n $stack');
      final errorMessage = getErrorMessageFromErrorCode(exc.code);
      isSomethingGoingOn = false;
      updateState = UpdatePassCredEnum.initial;
      notifyListeners();
      return errorMessage;
    }
  }

  verifyNewEmail() async {
    try {
      isSomethingGoingOn = true;
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      updateState = UpdatePassCredEnum.mailSent;
      isSomethingGoingOn = false;
      notifyListeners();
      return true;
    } on FirebaseException catch (exc, stack) {
      debugPrint(
          'ExceptionCaughtWhileSendingEmailVerificationMail $exc\n $stack');
      final errorMessage = getErrorMessageFromErrorCode(exc.code);
      isSomethingGoingOn = false;
      notifyListeners();
      return errorMessage;
    }
  }

  confirmVerification() async {
    try {
      isSomethingGoingOn = true;
      await FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        isSomethingGoingOn = false;
        notifyListeners();
        return true;
      } else {
        isSomethingGoingOn = false;
        updateState = UpdatePassCredEnum.mailNotVerified;
        notifyListeners();
        return false;
      }
    } on FirebaseException catch (exc, stack) {
      debugPrint(
          'ExceptionCaughtWhileSendingEmailVerificationMail $exc\n $stack');
      final errorMessage = getErrorMessageFromErrorCode(exc.code);
      isSomethingGoingOn = false;
      notifyListeners();
      return errorMessage;
    }
  }

  // checkIfNewMailOpened() async {
  //   debugPrint(
  //       'isUser ${user?.email} - MailVerifiedAlready ${user?.emailVerified}');
  //
  //   await user?.reload();
  //   debugPrint(
  //       'isUser 2  ${user?.email} - MailVerifiedAlready ${user?.emailVerified}');
  //
  //   if (user != null && !user!.emailVerified) {
  //     return false;
  //   }
  //   return true;
  // }

  updatePassword() async {
    try {
      isSomethingGoingOn = true;
      notifyListeners();
      if (currentPasswordController.text.isEmpty) {
        isSomethingGoingOn = false;
        notifyListeners();
        return 'Current password cannot be empty';
      }
      if (passwordController.text == confirmPasswordController.text) {
        final credential = EmailAuthProvider.credential(
          email: FirebaseAuth.instance.currentUser!.email!,
          password: currentPasswordController.text,
        );

        final UserCredential? userCredential = await FirebaseAuth
            .instance.currentUser
            ?.reauthenticateWithCredential(credential);
        if (userCredential?.user != null) {
          await FirebaseAuth.instance.currentUser
              ?.updatePassword(passwordController.text);
          isSomethingGoingOn = false;
          notifyListeners();
          resetUpdatePassword();
          return true;
        }
        isSomethingGoingOn = false;
        notifyListeners();
        return 'Something went wrong. Try again later';
      } else {
        isSomethingGoingOn = false;
        notifyListeners();
        return 'Passwords does not match';
      }
    } on FirebaseException catch (exc, stack) {
      debugPrint('ExceptionCaughtWhileUpdatingCred $exc\n $stack');
      final errorMessage = getErrorMessageFromErrorCode(exc.code);
      isSomethingGoingOn = false;
      notifyListeners();
      return errorMessage;
    }
  }

  resetUpdateCred() {
    updateState = UpdatePassCredEnum.initial;
    newEmailController.clear();
    currentEmailController.clear();
    currentPasswordController.clear();
    isSomethingGoingOn = false;
    notifyListeners();
  }

  resetUpdatePassword() {
    passwordController.clear();
    confirmPasswordController.clear();
    currentPasswordController.clear();
    notifyListeners();
  }
}
