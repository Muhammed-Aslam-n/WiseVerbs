import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../constants/constants.dart';
import '../models/post_quote_model.dart';
import '../models/register_user_model.dart';
import '../service/shared_preference.dart';
import '../utils/utils.dart';
import 'auth_provider/register_provider.dart';

class HomeScreenProvider extends ChangeNotifier {
  static final HomeScreenProvider _instance = HomeScreenProvider._internal();

  factory HomeScreenProvider() => _instance;

  HomeScreenProvider._internal() {
    fetchPopularQuotes();
  }

  Stream<QuerySnapshot<Object?>>? popularQuotesStream;

  Stream<QuerySnapshot<Object?>>? quoteCategoryStream;
  bool loading = false;
  List<DocumentSnapshot> popularQuotesList = [];
  List<DocumentSnapshot> quoteCategoryList = [];

  // List<DocumentSnapshot> userQuotes = [];
  fetchPopularQuotes() async {
    loading = true;
    notifyListeners();
    try {
      // final RegisterUserModel? userData =
      // await SharedPreferenceHelper.fetchSavedProfileData();

      popularQuotesStream = FirebaseFirestore.instance
          .collection(FirebaseReferences.firestoreQuoteRef)
          .snapshots();

      quoteCategoryStream = FirebaseFirestore.instance
          .collection(FirebaseReferences.firestoreQuoteCategoryRef)
          .snapshots();

      quoteCategoryStream?.listen((categories) {
        quoteCategoryList = categories.docs.toList();

        notifyListeners();
        printSuccess(
            'message ---- quoteCatList Empty? : ${quoteCategoryList.map((e) => jsonEncode(e.data()))} ');
        reflectUIChanges();
        notifyListeners();
      });
      popularQuotesStream?.listen((quotes) {
        popularQuotesList = quotes.docs.toList();
        reflectUIChanges();
        notifyListeners();
      });

      loading = false;
      notifyListeners();
      return true;
    } on FirebaseException catch (exc, stack) {
      debugPrint('FirebaseExceptionCaughtWhilePostingNewQuote $exc\n $stack');
      loading = false;
      notifyListeners();
      return getErrorMessageFromErrorCode(exc.code);
    } catch (exc, stack) {
      debugPrint('UnknownExceptionCaughtWhilePostingNewQuote $exc\n $stack');
      loading = false;
      notifyListeners();
      return somethingWW;
    }
  }

  Map<String, List<Map<String, dynamic>>> groupedQuotes = {};

  String currentUID = '';

  reflectUIChanges() {
    printInfo(
        'CurrentUser in ReflectUI ${FirebaseAuth.instance.currentUser?.email} ${FirebaseAuth.instance.currentUser?.uid}');
    groupedQuotes.clear();
    currentUID = FirebaseAuth.instance.currentUser!.uid;
    printInfo('ReflectUI Fn Called');
    for (var category in quoteCategoryList) {
      groupedQuotes[category['quote_categories']] = [];
    }
    for (var quote in popularQuotesList) {
      List<Map<String, dynamic>> categoryList =
          groupedQuotes[quote['quoteCategory']]!;
      categoryList.add(Quote.fromDocument(quote).toMap());
    }

    List<Map<String, dynamic>> result = [];
    groupedQuotes.forEach((category, quoteList) {
      result.add({
        'category': category,
        'quoteList': quoteList,
      });
    });

    groupedQuotes.removeWhere((key, value) => value.isEmpty);
    notifyListeners();
  }

  likeOrUnlike(isLike, Quote quote) async {
    final quotes = FirebaseFirestore.instance
        .collection(FirebaseReferences.firestoreQuoteRef)
        .get();
    List<DocumentSnapshot> list = await quotes.then((value) => value.docs);
    DocumentReference itemRef =
    list.where((element) {
      printInfo("element['dateTime'] ${DateTime.parse(element['dateTime']).toUtc().toIso8601String().toString()} ${quote.dateTime.toString()} \n element['author'].toString() ${element['author'].toString()} ${quote.author.toString()}");
     return DateTime.parse(element['dateTime']).toString().toLowerCase() ==
              quote.dateTime.toString().toLowerCase() &&
          element['author'].toString().toLowerCase() ==
              quote.author.toString().toLowerCase() && element['quote'].toString().toLowerCase() == quote.quote.toString().toLowerCase();
    }).toList().first.reference;
    currentUID = FirebaseAuth.instance.currentUser!.uid;


    isLike?quote.likedUIDs?.add(currentUID):quote.likedUIDs?.remove(currentUID);
    printInfo('quoteMapLikeUpdate ${quote.toMap()}');
    final updateLike = await itemRef.update(
      quote.toMap()
    );
  }
}
