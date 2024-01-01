import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise_verbs/constants/constants.dart';
import 'package:wise_verbs/utils/utils.dart';
import 'package:wise_verbs/widget/loading_widget.dart';

import '../../providers/tts_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: AspectRatio(
                  aspectRatio: 5 / 1.5,
                  child: Image.asset(
                    launchLogo,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Popular Quotes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              FutureBuilder(
                future: Future.delayed(const Duration(milliseconds: 1)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingWidget();
                  }

                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: 30,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        Map<String, dynamic> pickedTheme =
                            quoteCardThemePicker();
                        return SizedBox(
                          // height: MediaQuery.of(context).size.height - 100,
                          width: MediaQuery.of(context).size.width - 20,
                          child: AnimationWidget(
                            index: index,
                            quoteFont: pickedTheme['quoteFont'],
                            bgColor: pickedTheme['bgColor'],
                            ownerColor: pickedTheme['ownerColor'],
                            quoteColor: pickedTheme['quoteColor'],
                            iconColor: pickedTheme['iconColor'],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimationWidget extends StatefulWidget {
  final int index;
  final String quoteFont;
  final Color? quoteColor, bgColor, ownerColor, iconColor;

  const AnimationWidget(
      {super.key,
      required this.index,
      this.quoteColor,
      this.bgColor,
      this.ownerColor,
      this.iconColor,
      required this.quoteFont});

  @override
  State<AnimationWidget> createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<AnimationWidget> {
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    // Set a delay to start the animation for each item
    Future.delayed(Duration(milliseconds: widget.index * 300), () {
      if (mounted) {
        setState(() {
          isVisible = true;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastLinearToSlowEaseIn,
      child: popularQuoteItemWidget(widget.index),
    );
  }

  Widget popularQuoteItemWidget(int index) {
    final width = MediaQuery.of(context).size.width;
    debugPrint('font ${widget.quoteFont}');
    const String quote = "Quiet people have the loudestesteses minds.";
    const String author = "Stephen Hawking";
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          favorite = !favorite;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        margin: const EdgeInsets.all(15),
        curve: Curves.fastLinearToSlowEaseIn,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.bgColor ?? Colors.teal,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: width * 0.15),
                    child: Image.asset(
                      'assets/icons/quote_open_1.png',
                      height: 120,
                      width: 60,
                      color: widget.iconColor ?? Colors.white,
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
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
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
                              SelectableText(
                               quote ,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.apply(
                                      fontFamily: widget.quoteFont,
                                      color: widget.quoteColor,
                                    ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              SelectableText(
                                author.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.apply(
                                      fontFamily: widget.quoteFont,
                                      color: widget.quoteColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     const SizedBox(
                      //       width: 20,
                      //     ),
                      //
                      //     IconButton(
                      //       onPressed: () {},
                      //       icon: const Icon(
                      //         Icons.share,
                      //         size: 23,
                      //       ),
                      //     ),
                      //     IconButton(
                      //       onPressed: () {},
                      //       icon: const Icon(
                      //         Icons.copy,
                      //         size: 23,
                      //       ),
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Consumer<TTSProvider>(
                    builder: (context, provider, _) {
                      return IconButton(
                        onPressed: () {
                          if (provider.isSpeaking) {
                            provider.stopSpeaking();
                          } else {
                            provider.speak(
                                '$quote by $author', index: index);
                          }
                        },
                        icon: provider.isSpeaking ? provider
                            .playingIndex == index ? const Icon(Icons.stop):
                        const Icon(Icons.play_arrow)
                            : const Icon(Icons.play_arrow),
                      );
                    },
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          favorite = !favorite;
                        });
                      },
                      icon: Icon(
                        favorite
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                        color: favorite ? widget.iconColor : null,
                      )),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share,
                      size: 23,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool favorite = false;
}
