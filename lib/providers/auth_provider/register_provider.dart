import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wise_verbs/models/login_model.dart';
import 'package:wise_verbs/models/register_user_model.dart';
import 'package:wise_verbs/service/shared_preference.dart';

import '../../utils/utils.dart';

class RegistrationProvider extends ChangeNotifier {
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  logout() async {
    FirebaseAuth.instance.signOut();
  }

  Future<dynamic> registerUser({
    required RegisterUserModel registerDetails,
    required LoginModel loginCredentials,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      // final existing = await FirebaseAuth.instance.fetchSignInMethodsForEmail(loginCredentials.email);
      // debugPrint('isUserAlreadyExisting $existing');
      // if(existing.isNotEmpty){
      //   return false;
      // }
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: loginCredentials.email.toLowerCase(),
        password: loginCredentials.password,
      );
      final User? user = userCredential.user;

      final imageUrlFromStorage = await _uploadProfilePicToStorage(
          File(registerDetails.profilePicture));
      registerDetails.profilePicture = imageUrlFromStorage!;

      await FirebaseFirestore.instance
          .collection(FirebaseReferences.firestoreUserRef)
          .doc(user!.uid)
          .set(
            registerDetails.toJson(),
          );
      debugPrint('registered Successfully');
      final storeUserProfile =
          await SharedPreferenceHelper.saveProfileData(registerDetails);
      if (storeUserProfile) {
        debugPrint('ProfileData Stored');
      } else {
        debugPrint('ProfileData Not Stored');
      }
      isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseException catch (exc, stack) {
      debugPrint('ExceptionCaughtWhileRegisteringNewUser $exc \n $stack');
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
}

class FirebaseReferences {
  static const String refProfilePic = 'user_photos';

  static String profilePicName(userId, {imageFormat}) {
    return '$userId.${imageFormat ?? 'jpg'}';
  }

  static const String firestoreUserRef = 'user_test1';

  static const String firestoreQuoteRef = 'quote_test_1';
  static const String firestoreQuoteCategoryRef = 'quote_categories ';
}
