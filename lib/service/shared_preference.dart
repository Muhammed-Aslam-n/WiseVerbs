import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wise_verbs/models/login_model.dart';

import '../models/register_user_model.dart';

class SharedPreferenceHelper {
  SharedPreferenceHelper._internal();

  static final SharedPreferenceHelper _instance =
      SharedPreferenceHelper._internal();

  factory SharedPreferenceHelper() => _instance;

  static const String checkInitialLaunchKey = 'initialCheckKey';
  static const String loggedUserInfoKey = 'loggedUserInfo';
  static const String profileDataKey = 'profileData';

  static Future<bool> checkWhetherLoggedOrNot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final initialLaunch = prefs.getBool(checkInitialLaunchKey);
    if (initialLaunch == true) {
      return true;
    }
    return false;
  }

  static Future<bool> changeLoggedStatus(bool status) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final changeStatus = await pref.setBool(checkInitialLaunchKey, status);
    if (changeStatus == true) return true;
    return false;
  }

  static Future<bool> saveUserLoginData(LoginModel loginData) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    debugPrint('storingUserLoginData as ${jsonEncode(loginData.toJson())}');
    final stored =
        await pref.setString(loggedUserInfoKey, jsonEncode(loginData.toJson()));
    if (stored == true) return true;

    return false;
  }

  static Future<bool> saveProfileData(RegisterUserModel profileData) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    debugPrint('storingProfileData as ${jsonEncode(profileData.toJson())}');
    final stored =
    await pref.setString(profileDataKey, jsonEncode(profileData.toJson()));
    if (stored == true) return true;
    return false;
  }
  static Future<RegisterUserModel?> fetchSavedProfileData()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    final String? profileData = pref.getString(profileDataKey);
    debugPrint('fetchedSavedProfileData $profileData');
    if(profileData!=null&& profileData.isNotEmpty){
      return RegisterUserModel.fromJson(jsonDecode(profileData));
    }
    return null;
  }



}
