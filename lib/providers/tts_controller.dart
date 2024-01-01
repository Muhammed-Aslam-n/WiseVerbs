import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:wise_verbs/constants/constants.dart';

class TTSProvider extends ChangeNotifier{
  static final TTSProvider _instance = TTSProvider._internal();

  factory TTSProvider() => _instance;

  TTSProvider._internal() ;

  // Create a FlutterTts instance
  final FlutterTts _flutterTts = FlutterTts();

  bool isSpeaking = false;
  int playingIndex = 0;
  Future<void> speak(String text, {index}) async {
    // Stop any previous speech
    await _flutterTts.stop();
    // Speak the text

    if (text.isEmpty) {
      await _flutterTts.speak(emptyQuoteAlert);
      playingIndex = index??-1;
      isSpeaking = true;
      _flutterTts.setCompletionHandler(() {
        isSpeaking = false;
      });
    } else {
      playingIndex = index??-1;
      debugPrint('playingIndex $playingIndex');
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setSpeechRate(0.3);
      await _flutterTts.setLanguage("en-GB");
      print('getVoices ${await _flutterTts.getVoices}');
      // Map<String, String> reference = {'voice': "ml-IN-Standard-B"};
      // await _flutterTts.setVoice(reference);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.speak(text);
      isSpeaking = true;
      _flutterTts.setCompletionHandler(() {
        isSpeaking = false;
        debugPrint('completed');
        notifyListeners();
      });
    }
    // Notify the listeners
    notifyListeners();
  }

  stopSpeaking() async {
    await _flutterTts.stop();
    isSpeaking = false;
    notifyListeners();
  }


}