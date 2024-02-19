import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:wise_verbs/models/post_quote_model.dart';
import 'package:wise_verbs/models/register_user_model.dart';
import 'package:wise_verbs/providers/auth_provider/register_provider.dart';
import 'package:wise_verbs/service/shared_preference.dart';

import '../constants/constants.dart';
import '../utils/utils.dart';

class PostQuoteProvider extends ChangeNotifier {
  static final PostQuoteProvider _instance = PostQuoteProvider._internal();

  factory PostQuoteProvider() => _instance;

  PostQuoteProvider._internal() {
    notifyListeners();
    FirebaseAuth.instance.currentUser?.reload();
  }

  final TextEditingController quotesController = TextEditingController();
  final TextEditingController authorController = TextEditingController();

  String _fileContent = '';

  bool somethingGoingOn = false;

  final List<String> dropDownList = ['Myself', 'Other'];
  bool isOthers = false;
  String selectedAuthorType = 'Myself';
  String selectedCategory = 'Inspirational';

  bool agreeToShare = true;
  bool agreeToTAndC = true;

  List<String> quoteCategories = [
    'Inspirational',
    'Motivational',
    'Love',
    'Life',
    'Success',
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
    'Mindfulness',
  ];


  changeAuthor(String author) {
    selectedAuthorType = author;
    notifyListeners();
  }

  showOriginalAuthorField(bool isOther) {
    isOthers = isOther;
    notifyListeners();
  }

  changeQuoteCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  shareQuoteShareStatus(status) {
    agreeToShare = status;
    notifyListeners();
  }

  agreeToTermsAndConditions() {
    agreeToTAndC = true;
    notifyListeners();
  }

  Future<bool> openFileExplorer() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['txt']);

      if (result != null) {
        File file = File(result.files.single.path!);
        String content = await file.readAsString();
        _fileContent = content;
        quotesController.clear();
        quotesController.text = _fileContent;
        notifyListeners();
        return true;
      }
      return false;
    } catch (exc, stack) {
      debugPrint('ExceptionCaughtWhileReadingFile $exc \n $stack');
      return false;
    }
  }

  /// firestore handling starts

  Future<dynamic> fetchUserNameFromSp() async {
    try {
      final RegisterUserModel? userData =
          await SharedPreferenceHelper.fetchSavedProfileData();
      return userData;
    } catch (exc, stack) {
      debugPrint(
          'UnknownExceptionCaughtWhileFetchingUserProfileData $exc\n $stack');

      return null;
    }
  }

  Future<dynamic> postNewQuote() async {
    somethingGoingOn = true;
    notifyListeners();
    try {
      final RegisterUserModel? userData =
          await SharedPreferenceHelper.fetchSavedProfileData();

      final Quote newQuote = Quote(
        author: selectedAuthorType == CreateNewQuote.myselfCred
            ? userData!.name
            : authorController.text,
        dateTime: DateTime.now(),
        showEmail: true,
        quote: quotesController.text,
        agreedToTerms: agreeToTAndC,
        profilePicPath: userData!.profilePicture,
        category: selectedCategory,
        language: 'English',
        agreeToShare: agreeToShare,
        likes: null,
      );

      debugPrint('sendingNewQuoteDetails ${newQuote.toMap()}');

      final postNewQuoteRes = await FirebaseFirestore.instance
          .collection(FirebaseReferences.firestoreQuoteRef)
          .add(
            newQuote.toMap(),
          );
      debugPrint('postNewQuoteResponse $postNewQuoteRes');
      somethingGoingOn = false;
      notifyListeners();
      return true;
    } on FirebaseException catch (exc, stack) {
      debugPrint('FirebaseExceptionCaughtWhilePostingNewQuote $exc\n $stack');
      somethingGoingOn = false;
      notifyListeners();
      return getErrorMessageFromErrorCode(exc.code);
    } catch (exc, stack) {
      debugPrint('UnknownExceptionCaughtWhilePostingNewQuote $exc\n $stack');
      somethingGoingOn = false;
      notifyListeners();
      return somethingWW;
    }
  }

  prepareForUpdate(DocumentSnapshot documentSnapshot) async {
    final Quote quote = Quote.fromDocument(documentSnapshot);
    final RegisterUserModel? userData =
        await SharedPreferenceHelper.fetchSavedProfileData();
    authorController.clear();
    authorController.text = quote.author ?? '';
    quotesController.clear();
    quotesController.text = quote.quote ?? '';
    if (quote.author == userData?.name) {
      isOthers = false;
    } else {
      isOthers = true;
    }
    selectedAuthorType =
        quote.author == userData?.name ? dropDownList.first : dropDownList.last;
    selectedCategory = quote.category ?? '';
    agreeToShare = quote.agreeToShare ?? true;
    agreeToTAndC = quote.agreedToTerms ?? true;

    somethingGoingOn = false;
    notifyListeners();
  }

  editPost({required DocumentSnapshot documentSnapshot}) async {
    somethingGoingOn = true;
    notifyListeners();
    try {
      final RegisterUserModel? userData =
          await SharedPreferenceHelper.fetchSavedProfileData();

      final Quote editedQuote = Quote(
        author: selectedAuthorType == CreateNewQuote.myselfCred
            ? userData!.name
            : authorController.text,
        dateTime: DateTime.now(),
        showEmail: true,
        quote: quotesController.text,
        agreedToTerms: agreeToTAndC,
        profilePicPath: userData!.profilePicture,
        category: selectedCategory,
        language: 'English',
        agreeToShare: agreeToShare,
        likes: null,
      );

      debugPrint('updatingExistingQuoteDetails ${editedQuote.toMap()}');

      final updateQuote = documentSnapshot.reference.update(editedQuote.toMap());
      debugPrint('postNewQuoteResponse $updateQuote');
      somethingGoingOn = false;
      notifyListeners();
      return true;
    } on FirebaseException catch (exc, stack) {
      debugPrint('FirebaseExceptionCaughtWhilePostingNewQuote $exc\n $stack');
      somethingGoingOn = false;
      notifyListeners();
      return getErrorMessageFromErrorCode(exc.code);
    } catch (exc, stack) {
      debugPrint('UnknownExceptionCaughtWhilePostingNewQuote $exc\n $stack');
      somethingGoingOn = false;
      notifyListeners();
      return somethingWW;
    }
  }

  resetForm() {
    authorController.clear();
    quotesController.clear();
    isOthers = false;
    selectedAuthorType = dropDownList.first;
    selectedCategory = quoteCategories.first;
    agreeToShare = true;
    agreeToTAndC = false;

    somethingGoingOn = false;
    notifyListeners();
  }
}

// Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 5),
//   child: TextFormField(
//     controller: quoteProvider.categoryController,
//     validator: (author) {
//       if (author == null || author.isEmpty) {
//         return authorErrorMsg;
//       }
//       return null;
//     },
//     onChanged: (k){
//       quoteProvider.filterCategories(k);
//     },
//     decoration: InputDecoration(
//       border: const UnderlineInputBorder(),
//       hintText: 'Mention author here',
//       hintStyle: Theme.of(context)
//           .textTheme
//           .bodyLarge
//           ?.copyWith(color: Colors.grey.shade600),
//     ),
//   ),
// ),

// Expanded(
//   child: SizedBox(
//     height: 150,
//     child: ListView.builder(
//       itemCount: quoteProvider.filteredCategories.length,
//       shrinkWrap: true,
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text(quoteProvider.filteredCategories[index]),
//           onTap: () {
//             // Handle selected suggestion
//             print('Selected: ${quoteProvider.filteredCategories[index]}');
//           },
//         );
//       },
//     ),
//   ),
// ),
