import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise_verbs/constants/constants.dart';
import 'package:wise_verbs/models/post_quote_model.dart';
import 'package:wise_verbs/providers/auth_provider/login_provider.dart';
import 'package:wise_verbs/providers/user_contribution_provider.dart';
import 'package:wise_verbs/screens/auth_screen/get_started_screen.dart';
import 'package:wise_verbs/screens/contribution/add_update_screen.dart';
import 'package:wise_verbs/screens/index/post_quote_screen.dart';
import 'package:wise_verbs/widget/route_transition.dart';

import '../../providers/tts_controller.dart';
import '../../widget/loading_widget.dart';

class UserContributionScreen extends StatelessWidget {
  const UserContributionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () async {
                    final provider =
                        Provider.of<LoginProvider>(context, listen: false);
                    final logout = await provider.logout();
                    if (logout) {
                      navPopCompletelyAndPush(
                          context, const GetStartedScreen());
                    }
                  },
                  icon: const Icon(Icons.logout_rounded),
                ),
              ),
              AddProfileSection(onTap: () {
                addProfile(context);
              }),
              const SizedBox(
                height: 40,
              ),
              screenSubjectText(context),
              const SizedBox(
                height: 40,
              ),
              const UserSharedQuotes(),
            ],
          ),
        ),
      ),
    );
  }

  Widget screenSubjectText(context) {
    return Align(
        alignment: Alignment.topLeft,
        child: Text(
          UserContributionConstants.screenSubjectText,
          style: Theme.of(context).textTheme.titleLarge,
        ));
  }

  addProfile(context) {
    debugPrint('Add Profile Button Clicked');
    navPush(context, const AddUpdateProfile(), direction: Alignment.topCenter);
  }
}

class UserSharedQuotes extends StatefulWidget {
  const UserSharedQuotes({Key? key}) : super(key: key);

  @override
  State<UserSharedQuotes> createState() => _UserSharedQuotesState();
}

class _UserSharedQuotesState extends State<UserSharedQuotes> {
  late UserContributionProvider provider;

  @override
  void initState() {
    provider = Provider.of<UserContributionProvider>(context, listen: false);
    provider.startListeningUserQuotes();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserContributionProvider>(
      builder: (context, userCProvider, _) {
        return StreamBuilder<QuerySnapshot>(
          stream: userCProvider.userQuotesStream,
          builder: (context, snapshot) {
            debugPrint('userPostSnapshot $snapshot ${snapshot.data}');
            // if (snapshot.connectionState == ConnectionState.active ||
            //     snapshot.connectionState == ConnectionState.waiting) {
            //   return const LoadingWidget();
            // }
            if (userCProvider.userQuotes.isEmpty) {
              return const Center(
                child: Text("You haven't shared any quotes"),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: userCProvider.userQuotes.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final docSnapshot = userCProvider.userQuotes[index];
                final Quote quote = Quote.fromDocument(docSnapshot);
                return Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          SelectableText(
                            quote.quote ?? 'No Quote',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                    fontSize: 17, fontFamily: quoteFont9),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SelectableText(
                              ' - ${quote.author}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontSize: 15, fontFamily: quoteFont9),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Consumer<TTSProvider>(
                                  builder: (context, provider, _) {
                                    return IconButton(
                                      onPressed: () {
                                        if (provider.isSpeaking) {
                                          provider.stopSpeaking();
                                        } else {
                                          provider.speak(
                                              '${quote.quote} by ${quote.author}',
                                              index: index);
                                        }
                                      },
                                      icon: provider.isSpeaking
                                          ? provider.playingIndex == index
                                              ? const Icon(
                                                  Icons.stop,
                                                  color: Colors.red,
                                                )
                                              : const Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.teal,
                                                )
                                          : const Icon(
                                              Icons.play_arrow,
                                              color: Colors.teal,
                                            ),
                                    );
                                  },
                                ),
                                IconButton(
                                    onPressed: () {
                                      navPush(
                                        context,
                                        PostQuoteScreen(
                                          isTtsEnabled: false,
                                          isUpdating: true,
                                          quoteDocument: docSnapshot,
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.edit,
                                        color: Theme.of(context)
                                            .iconTheme
                                            .copyWith(color: dodgerBlue)
                                            .color)),
                                IconButton(
                                    onPressed: () {
                                      userCProvider.deletePost(docSnapshot);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Theme.of(context)
                                          .iconTheme
                                          .copyWith(color: Colors.red)
                                          .color,
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Theme.of(context)
                                  .iconTheme
                                  .copyWith(color: Colors.teal)
                                  .color,
                              size: 20,
                            ),
                            Text(
                              '${quote.likes??'0'}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

class AddProfileSection extends StatelessWidget {
  final VoidCallback onTap;

  const AddProfileSection({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
          backgroundColor: MaterialStatePropertyAll(
            Theme.of(context).colorScheme.tertiary,
          ),
          padding: const MaterialStatePropertyAll(EdgeInsets.all(25))),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Profile',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          // const SizedBox(
          //   width: 10,
          // ),
          // Icon(
          //   CupertinoIcons.pencil,
          //   color: Theme.of(context).iconTheme.color,
          // ),
        ],
      ),
    );
  }
}
