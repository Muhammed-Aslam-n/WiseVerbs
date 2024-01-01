
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:wise_verbs/providers/tts_controller.dart';

class SpeechToUserTextProvider extends ChangeNotifier {
  static final SpeechToUserTextProvider _instance =
  SpeechToUserTextProvider._internal();

  factory SpeechToUserTextProvider() => _instance;

  SpeechToUserTextProvider._internal() {
    // initSpeech();
  }

  // Create a SpeechToText instance
  final SpeechToText _speechToText = SpeechToText();

  // A field to store the recognized text
  String _text = '';

  // A getter to access the text
  String get text => _text;

  // A method to initialize the speech recognition

  TTSProvider ttsProvider = TTSProvider();

  Future<bool> initSpeech() async {
    // Check if the speech service is available
    bool available = await _speechToText.initialize(
      onError: _onError,
      onStatus: _onStatus,
    );
    if (available) {
      debugPrint('speechToTextAvailable $available');
      // Notify the listeners
      notifyListeners();
      return true;
    } else {
      // Handle the error
      ttsProvider.speak('Sorry, Speech recognition service is not available');
      debugPrint('Speech recognition service is not available');
      return false;
    }
  }

  // A method to start listening to the user's speech
  String locale = '';
  Future<bool> startListening() async {
    // Specify the language code for Malayalam
    try {
      String language = 'en_US';

      var _localeNames = await _speechToText.locales();

      _localeNames.forEach((element) {

        debugPrint('localeNames ${element.name} -- ${element.localeId}');
      });

      var systemLocale = await _speechToText.systemLocale();

      debugPrint('locale ${await _speechToText.systemLocale().then((value) => value?.localeId)}');

      var _currentLocaleId = systemLocale?.localeId ?? '';
      locale = _currentLocaleId;

      // Start listening
      await _speechToText.listen(
        onResult: _onResult,
        localeId: locale,
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
      );
      notifyListeners();
      return true;
    } catch (e, s) {
      log('ExceptionCaughtAt startListening $e \n $s');
      return false;
    }
  }

  // A method to stop listening to the user's speech
  Future<bool> stopListening() async {
    try {
      // Stop listening
      await _speechToText.stop();
      debugPrint('listeningStopped');
      notifyListeners();
      return true;
    } catch (e, s) {
      log('ExceptionCaughtAt stopListening $e \n $s');
      return false;
    }
  }

  // A callback to handle the speech recognition result
  void _onResult(SpeechRecognitionResult result) {
    // Update the text field with the recognized text
    _text = result.recognizedWords;
    // Notify the listeners
    // _speechToText.isNotListening == true
    //     ? SqfliteNotesTable().insert(NoteModel(
    //     id: null, note: _text, dateTime: DateTime.now().toString(),locale: locale),)
    //     : null;
    notifyListeners();
  }

  // A callback to handle the speech recognition error
  void _onError(SpeechRecognitionError error) {
    // Handle the error
    debugPrint('Speech recognition error: ${error.errorMsg}');
  }

  // A callback to handle the speech recognition status
  void _onStatus(String status) {
    // Handle the status
    debugPrint('Speech recognition status: $status');
  }
}
