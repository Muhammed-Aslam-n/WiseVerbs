import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise_verbs/providers/tts_controller.dart';
import 'package:wise_verbs/widget/route_transition.dart';

import '../constants/constants.dart';

class QuotePreviewWidget extends StatelessWidget {
  final String quote, author;

  const QuotePreviewWidget(
      {Key? key, required this.quote, required this.author})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Consumer<TTSProvider>(builder: (context, provider, _) {
              return IconButton(
                  onPressed: () {
                    if(provider.isSpeaking){
                      provider.stopSpeaking();
                    }else{
                      provider.speak('$quote by $author');
                    }
                  }, icon: provider.isSpeaking?const Icon(Icons.pause):const Icon(Icons.play_arrow));
            }),
          ),
          Expanded(
            child: Row(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: width * 0.15),
                    child: Image.asset(
                      'assets/icons/quote_open_1.png',
                      height: 120,
                      width: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: width * 0.1,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: width * 0.04),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          foregroundColor: dodgerBlue,
                          radius: 25,
                          child: Text(
                            'A',
                            style:
                                Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: dodgerBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                            softWrap: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: width * 0.12,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: SelectableText(
                                  quote,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.apply(
                                        fontFamily: quoteFont1,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: SelectableText(
                                  '- $author',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.apply(
                                        fontFamily: quoteFont1,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .copyWith(tertiary: Colors.teal.withOpacity(0.9))
                                .tertiary,
                            elevation: 0.5,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(25),
                          ),
                          onPressed: () {
                            navPop(context);
                          },
                          child: const Icon(CupertinoIcons.xmark),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
