import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:wise_verbs/constants/constants.dart';
import 'package:wise_verbs/screens/contribution/add_update_screen.dart';
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
          "Quotes you've shared",
          style: Theme
              .of(context)
              .textTheme
              .titleLarge,
        ));
  }

  addProfile(context) {
    debugPrint('Add Profile Button Clicked');
    navPush(context, const AddUpdateProfile(), direction: Alignment.topCenter);
  }
}

class UserSharedQuotes extends StatelessWidget {
  const UserSharedQuotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 1)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        }

        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: 30,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            const String quote =
                '''For several generations, stories from Africa have traditionally been passed down by word of mouth. Often, after a hard day’s work, the adults would gather the children together by moonlight, around a village fire and tell stories. This was traditionally called 'Tales by Moonlight'. Usually, the stories are meant to prepare young people for life, and so each story taught a lesson or moral. 

In the African folktales, the stories reflect the culture where diverse types of animals abound. The animals and birds are often accorded human attributes, so it is not uncommon to find animals talking, singing, or demonstrating other human characteristics such as greed, jealousy, honesty, etc. The setting in many of the stories exposes the reader to the land form and climate within that region of Africa. References are often made to different seasons such as the 'dry' or 'rainy' season and their various effects on the surrounding vegetation and animal life.''';
            const String author = 'You';
            return Stack(

              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .tertiary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      SelectableText(
                        quote,
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontSize: 17, fontFamily: quoteFont9),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SelectableText(
                          ' - $author',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 15, fontFamily: quoteFont9),
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
                                          '$quote by $author', index: index);
                                    }
                                  },
                                  icon: provider.isSpeaking ? provider
                                      .playingIndex == index ? const Icon(Icons.stop,color: Colors.red,):
                                       const Icon(Icons.play_arrow,color: Colors.teal,)
                                      : const Icon(Icons.play_arrow,color: Colors.teal,),
                                );
                              },
                            ),
                            IconButton(onPressed: (){}, icon: Icon(Icons.edit,color: Theme.of(context).iconTheme.copyWith(color: dodgerBlue).color)),
                            IconButton(onPressed: (){}, icon: Icon(Icons.delete,color: Theme.of(context).iconTheme.copyWith(color: Colors.red).color,)),
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
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.favorite,color: Theme.of(context).iconTheme.copyWith(color: Colors.teal).color,size: 20,),
                        Text('2',style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.teal,fontWeight: FontWeight.w600),),
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
  }
}

class AddProfileSection extends StatelessWidget {
  final VoidCallback onTap;

  const AddProfileSection({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: Theme
          .of(context)
          .elevatedButtonTheme
          .style
          ?.copyWith(
          backgroundColor: MaterialStatePropertyAll(
            Theme
                .of(context)
                .colorScheme
                .tertiary,
          ),
          padding: const MaterialStatePropertyAll(EdgeInsets.all(25))),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Describe yourself',
            style: Theme
                .of(context)
                .textTheme
                .titleSmall,
          ),
          const SizedBox(
            width: 10,
          ),
          Icon(
            CupertinoIcons.pencil,
            color: Theme
                .of(context)
                .iconTheme
                .color,
          ),
        ],
      ),
    );
  }
}
