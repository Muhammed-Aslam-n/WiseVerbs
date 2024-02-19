import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise_verbs/constants/constants.dart';
import 'package:wise_verbs/providers/home_screen_provider.dart';
import 'package:wise_verbs/utils/utils.dart';

import '../../models/post_quote_model.dart';
import '../../providers/tts_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child:
              Consumer<HomeScreenProvider>(builder: (context, hsProvider, _) {
            return Column(
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
                StreamBuilder<QuerySnapshot>(
                  stream: hsProvider.quoteCategoryStream,
                  builder: (context, snapshot) {
                    // printSuccess('FilteredList ${hsProvider.filterList.isEmpty}');

                    log('groupedQuotes ${jsonEncode(hsProvider.groupedQuotes)}');

                    hsProvider.groupedQuotes.forEach((key, value) {
                      printInfo('filteredList key $key $value');
                    });
                    if (hsProvider.groupedQuotes.isEmpty) {
                      return Center(
                        child: Text(
                          'No Popular quotes yet!',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      );
                    }
                    // return Text('Soon');
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (itemBuilder, index) {
                        final categorizedQuote = hsProvider.groupedQuotes;
                        String category =
                            categorizedQuote.keys.elementAt(index);
                        List<Map<String, dynamic>> quoteList =
                            categorizedQuote.values.elementAt(index);

                        return PopularQuotesByCategoryWidget(
                          categoryName: category,
                          quotes:
                              quoteList.map((e) => Quote.fromJson(e)).toList(),
                          contributionProvider: hsProvider,
                        );
                      },
                      itemCount: hsProvider.groupedQuotes.length,
                      shrinkWrap: true,
                    );
                  },
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}

class PopularQuotesByCategoryWidget extends StatelessWidget {
  const PopularQuotesByCategoryWidget({
    Key? key,
    required this.categoryName,
    required this.contributionProvider,
    required this.quotes,
  }) : super(key: key);

  // final int itemCount;
  final HomeScreenProvider contributionProvider;
  final String categoryName;
  final List<Quote> quotes;

  @override
  Widget build(BuildContext context) {
    printSuccess('categories $categoryName');
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          categoryName,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.65,
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: quotes.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              Map<String, dynamic> pickedTheme = quoteCardThemePicker();
              final Quote quote = quotes[index];

              return SizedBox(
// height: MediaQuery.of(context).size.height - 100,
                width: MediaQuery.of(context).size.width - 20,
                child: AnimationWidget(
                  quote: quote,
                  isLiked: quote.likedUIDs == null
                      ? false
                      : quote.likedUIDs!
                          .contains(contributionProvider.currentUID),
                  likes: quote.likes ?? 0,
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
        ),
      ],
    );
  }
}

class AnimationWidget extends StatefulWidget {
  final int index;
  final String quoteFont;
  final Quote quote;
  final int likes;
  final bool isLiked;
  final Color? quoteColor, bgColor, ownerColor, iconColor;

  const AnimationWidget({
    super.key,
    required this.index,
    this.quoteColor,
    this.bgColor,
    this.ownerColor,
    this.iconColor,
    required this.quoteFont,
    required this.quote,
    required this.likes,
    required this.isLiked,
  });

  @override
  State<AnimationWidget> createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<AnimationWidget> {
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    // Set a delay to start the animation for each item
    Future.delayed(Duration(milliseconds: widget.index * 10), () {
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
      child: popularQuoteItemWidget(
        quote: widget.quote,
        likes: widget.likes,
        index: widget.index,
        isLiked: widget.isLiked,
      ),
    );
  }

  Widget popularQuoteItemWidget({
    required int index,
    required Quote quote,
    required int likes,
    required bool isLiked,
  }) {
    final width = MediaQuery.of(context).size.width;
    debugPrint('font ${widget.quoteFont}');
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
                                quote.quote ?? 'Quote not found',
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
                                quote.author ??
                                    'Author not found'.toUpperCase(),
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
                            provider.speak('${quote.quote} by ${quote.author}',
                                index: index);
                          }
                        },
                        icon: provider.isSpeaking
                            ? provider.playingIndex == index
                                ? Icon(
                                    Icons.stop,
                                    color: widget.iconColor,
                                  )
                                : Icon(
                                    Icons.play_arrow,
                                    color: widget.iconColor,
                                  )
                            : Icon(
                                Icons.play_arrow,
                                color: widget.iconColor,
                              ),
                      );
                    },
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          favorite = !favorite;
                        });
                        final HomeScreenProvider provider =
                            Provider.of<HomeScreenProvider>(context,
                                listen: false);
                        isLiked
                            ? provider.likeOrUnlike(false,quote)
                            : provider.likeOrUnlike(true,quote);
                      },
                      icon: Icon(
                        isLiked
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                        color: widget.iconColor,
                      )),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.share,
                      size: 23,
                      color: widget.iconColor,
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
