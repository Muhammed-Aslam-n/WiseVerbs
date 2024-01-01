import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise_verbs/constants/constants.dart';
import 'package:wise_verbs/providers/stt_provider.dart';

class STTQuoteScreen extends StatefulWidget {
  const STTQuoteScreen({Key? key}) : super(key: key);

  @override
  State<STTQuoteScreen> createState() => _STTQuoteScreenState();
}

class _STTQuoteScreenState extends State<STTQuoteScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create new quote'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<SpeechToUserTextProvider>(
              builder: (builder, speechObj, _) {
                if(speechObj.text.isNotEmpty){
                  return Text(speechObj.text,style: Theme.of(context).textTheme.bodyMedium,);
                }
                return const SizedBox.shrink();
              },
            ),
            SizedBox(height: width * 0.74,),
            Center(
              child: Consumer<SpeechToUserTextProvider>(
                builder: (context,sttOb,_) {
                  if(sttOb.text.isEmpty) {
                    return ElevatedButton(
                    onPressed: () async {
                      final available =
                      await sttOb.initSpeech();
                      if (available) {
                        sttOb.startListening();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).highlightColor,
                      backgroundColor:
                      Theme.of(context).colorScheme.tertiary,
                      // Text color
                      side: const BorderSide(
                          color: Colors.white, width: 0.5),
                      padding: const EdgeInsets.all(50),
                      shape: const CircleBorder(),
                      // Border settings
                      elevation: 0,
                    ),
                    child: Column(
                      children: [
                        Icon(CupertinoIcons.waveform),
                        Text(
                          'Start Listening',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  );
                  }
                  return
                    Image.asset(listeningGif);
                }
              ),
            ),

          ],
        ),
      ),
    );
  }
}
