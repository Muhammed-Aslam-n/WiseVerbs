import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Quote {
  final String? quote;
  final String? author;
  final DateTime? dateTime;
  final int? likes;
  final List<dynamic>? likedUIDs;
  final bool? showEmail;
  final bool? agreedToTerms;
  final bool? agreeToShare;
  final String? category;
  final String? language;
  final String? profilePicPath;

  Quote({
    required this.quote,
    required this.author,
    required this.category,
    this.language = 'English',
    this.likes,
    this.likedUIDs,
    required this.dateTime,
    required this.showEmail,
    required this.agreedToTerms,
    this.agreeToShare = true,
    required this.profilePicPath,
  });

  // Constructor to create a Quote object from a Firestore document snapshot
  factory Quote.fromDocument(DocumentSnapshot doc) {
    return Quote(

      quote: doc['quote'] as String?,
      category: doc['quoteCategory'] as String?,
      author: doc['author'] as String?,
      language: doc['quoteLanguage'] as String?,
      dateTime: DateTime.parse(doc['dateTime']),
      profilePicPath: doc['profilePicPath'] as String?,
      likes: doc['likes'] as int?,
      likedUIDs: doc['likedUIDs'] == null?null:doc['likedUIDs'] as List,
      showEmail: doc['showEmail'] as bool?,
      agreedToTerms: doc['agreedToTerms'] as bool?,
      agreeToShare: doc['agreedToShare'] as bool?,
    );
  }

  factory Quote.fromJson(Map<String,dynamic> doc) {
    return Quote(
      quote: doc['quote'] as String?,
      author: doc['author'] as String?,
      category: doc['quoteCategory'] as String?,
      dateTime: DateTime.parse(doc['dateTime']),
      likes: doc['likes'] as int?,
      likedUIDs: doc['likedUIDs'] as List<dynamic>?,
      showEmail: doc['showEmail'] as bool?,
      agreedToTerms: doc['agreedToTerms'] as bool?,
      agreeToShare: doc['agreedToShare'] as bool?,
      language: doc['quoteLanguage'] as String?,
      profilePicPath: doc['profilePicPath'] as String?,
    );
  }

  // Convert the Quote object to a Map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'quote': quote,
      'author': author,
      'quoteCategory': category,
      'quoteLanguage': language,
      'profilePicPath': profilePicPath,
      'dateTime': dateTime?.toUtc().toIso8601String(),
      'likes': likes??0,
      'likedUIDs':likedUIDs??[],
      'showEmail': showEmail,
      'agreedToTerms': agreedToTerms,
      'agreedToShare': agreeToShare,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
