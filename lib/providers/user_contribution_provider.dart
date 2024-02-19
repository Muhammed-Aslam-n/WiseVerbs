import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:wise_verbs/providers/auth_provider/register_provider.dart';

import '../models/register_user_model.dart';
import '../service/shared_preference.dart';

class UserContributionProvider extends ChangeNotifier {
  UserContributionProvider._internal() {
    startListeningUserQuotes();
  }

  static final UserContributionProvider _instance =
      UserContributionProvider._internal();

  factory UserContributionProvider() => _instance;
  bool loading = false;
  List<DocumentSnapshot> userQuotes = [];
  Stream<QuerySnapshot<Object?>>? userQuotesStream;

  void startListeningUserQuotes() async {
    debugPrint('startingListeningUserQuotes');
    final RegisterUserModel? userData =
        await SharedPreferenceHelper.fetchSavedProfileData();

    userQuotesStream = FirebaseFirestore.instance
        .collection(FirebaseReferences.firestoreQuoteRef)
        .snapshots();

    debugPrint('userQuoteStream $userQuotesStream');

    userQuotesStream!.listen((snapshot) {
      debugPrint('snapShot ${snapshot.docs}');
      userQuotes = snapshot.docs.toList();
      notifyListeners();
    });
  }

  // Future<List<Quote>> fetchUserSharedQuotes() async {
  //   try {
  //     final RegisterUserModel? userData =
  //         await SharedPreferenceHelper.fetchSavedProfileData();
  //
  //     final fetchedUserPosts = await FirebaseFirestore.instance
  //         .collection(FirebaseReferences.firestoreQuoteRef)
  //         .doc(FirebaseAuth.instance.currentUser?.uid)
  //         .collection(userData!.name)
  //         .get();
  //
  //     debugPrint(
  //         'fetchedUserPosts is $fetchedUserPosts and ${fetchedUserPosts.runtimeType}');
  //     debugPrint(
  //         'fetchedUserPosts data ${fetchedUserPosts.docs.map((e) => Quote.fromDocument(e).toJson())} ${fetchedUserPosts.docs.length}');
  //
  //     for (DocumentSnapshot post in fetchedUserPosts.docs) {
  //       userQuotes.add(Quote.fromDocument(post));
  //     }
  //
  //     // notifyListeners();
  //     return userQuotes;
  //   } on FirebaseException catch (exc, stack) {
  //     debugPrint('ExceptionCaughtWhileFetchingUserSharedQuotes $exc\n $stack');
  //
  //     loading = false;
  //     notifyListeners();
  //     return [];
  //   } catch (exc, stack) {
  //     debugPrint(
  //         'UnknownExceptionCaughtWhileFetchingUserSharedQuotes $exc \n $stack');
  //     return [];
  //   }
  // }

  Future deletePost(DocumentSnapshot documentSnapshot) async {
    try {
      await documentSnapshot.reference.delete();
      return true;
    } on FirebaseException catch (exc, stack) {
      debugPrint('ExceptionCaughtWhileFetchingUserSharedQuotes $exc\n $stack');

      loading = false;
      notifyListeners();
      return [];
    } catch (exc, stack) {
      debugPrint(
          'UnknownExceptionCaughtWhileFetchingUserSharedQuotes $exc \n $stack');
      return [];
    }
  }
}
