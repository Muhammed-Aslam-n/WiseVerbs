import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wise_verbs/models/login_model.dart';

import '../../utils/utils.dart';

class LoginProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  User? get user => _user;
  bool isLoading = false;

  LoginProvider() {
    _user = FirebaseAuth.instance.currentUser;
    debugPrint('isUserLoggedIn ${_user != null}');
    notifyListeners();
    FirebaseAuth.instance.userChanges().listen((user) {
      debugPrint('login state change identified $user');
      _user = user;
      notifyListeners();
      // _initialScreen(user);
    });
  }

  Future<dynamic> loginUser(LoginModel loginCredentials) async {
    try {
      isLoading = true;
      notifyListeners();

      final userLoginRes = await _auth.signInWithEmailAndPassword(
        email: loginCredentials.email,
        password: loginCredentials.password,
      );
      _user = userLoginRes.user;
      isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseException catch (exc, stack) {
      debugPrint('ExceptionCaughtWhileUserLogin $exc\n $stack');
      final errorMessage = getErrorMessageFromErrorCode(exc.code);
      isLoading = false;
      notifyListeners();
      return errorMessage;
    }
  }


  Future<dynamic> resetPassword(String email)async{
    try{
      isLoading = true;
      await _auth.sendPasswordResetEmail(email: email);
      isLoading = false;
      notifyListeners();
      return true;
    }on FirebaseException catch (exc, stack) {
      debugPrint('ExceptionCaughtWhileUserLogin $exc\n $stack');
      final errorMessage = getErrorMessageFromErrorCode(exc.code);
      isLoading = false;
      notifyListeners();
      return errorMessage;
    }
  }

  logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await FirebaseAuth.instance.currentUser?.reload();
      notifyListeners();
      return true;
    } catch (exc, stack) {
      debugPrint('ExceptionCaughtWhileLoggingOut $exc \n $stack');
      return false;
    }
  }
}
