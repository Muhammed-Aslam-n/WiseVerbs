import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise_verbs/constants/constants.dart';
import 'package:wise_verbs/models/register_user_model.dart';
import 'package:wise_verbs/providers/post_quote_provider.dart';
import 'package:wise_verbs/providers/tts_controller.dart';
import 'package:wise_verbs/service/shared_preference.dart';
import 'package:wise_verbs/utils/utils.dart';
import 'package:wise_verbs/widget/loading_overlay.dart';
import 'package:wise_verbs/widget/new_quote_preview_widget.dart';
import 'package:wise_verbs/widget/outlined_button.dart';
import 'package:wise_verbs/widget/route_transition.dart';

class PostQuoteScreen extends StatefulWidget {
  final bool isTtsEnabled;
  final bool isUpdating;
  final DocumentSnapshot? quoteDocument;

  const PostQuoteScreen({
    Key? key,
    required this.isTtsEnabled,
    required this.isUpdating,
    this.quoteDocument,
  }) : super(key: key);

  @override
  State<PostQuoteScreen> createState() => _PostQuoteScreenState();
}

class _PostQuoteScreenState extends State<PostQuoteScreen> {
  final _formKey = GlobalKey<FormState>();
  TTSProvider ttsProvider = TTSProvider();
  PostQuoteProvider? postQuoteProvider;

  @override
  void initState() {
    ttsProvider = Provider.of<TTSProvider>(context, listen: false);
    if (widget.isUpdating && widget.quoteDocument != null) {
      postQuoteProvider = Provider.of(context, listen: false);
      postQuoteProvider?.prepareForUpdate(widget.quoteDocument!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isUpdating?CreateNewQuote.updateAppBarTitle:CreateNewQuote.appBarTitle),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Consumer<PostQuoteProvider>(
          builder: (context, quoteProvider, _) {
            return LoadingOverlay(
              isLoading: quoteProvider.somethingGoingOn,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(CreateNewQuote.categoryText),
                            const SizedBox(
                              width: 5,
                            ),
                            SingleChildScrollView(
                              child: DropdownButton<String>(
                                value: quoteProvider.selectedCategory,
                                elevation: 2,
                                underline: const SizedBox.shrink(),
                                onChanged: (String? value) {
                                  quoteProvider.changeQuoteCategory(value!);
                                },
                                items: quoteProvider.quoteCategories
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                alignment: Alignment.bottomCenter,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          height: MediaQuery.of(context).size.height * 0.5,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade800,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: quoteProvider.quotesController,
                                  validator: (quote) {
                                    if (quote == null || quote.isEmpty) {
                                      return quoteErrorMsg;
                                    }
                                    return null;
                                  },
                                  onChanged: (quote) {},
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: CreateNewQuote.enterQuoteHint,
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Colors.grey.shade600,
                                        ),
                                  ),
                                ),
                              ),
                              Consumer<TTSProvider>(
                                  builder: (context, ttsOb, _) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Hear quote'),
                                    OutlinedIconButtonWidget(
                                      onPressed: () {
                                        if (ttsOb.isSpeaking) {
                                          ttsOb.stopSpeaking();
                                        } else {
                                          ttsOb.speak(quoteProvider
                                              .quotesController.text);
                                        }
                                      },
                                      icon: ttsOb.isSpeaking
                                          ? CupertinoIcons.pause
                                          : CupertinoIcons.play,
                                      iconColor: Colors.white,
                                      bgColor: Colors.black,
                                      borderColor: Colors.transparent,

                                      // invert: true,
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            const Text(CreateNewQuote.creditText),
                            const SizedBox(
                              width: 5,
                            ),
                            DropdownButton<String>(
                              value: quoteProvider.selectedAuthorType,
                              elevation: 2,
                              underline: const SizedBox.shrink(),
                              onChanged: (String? value) {
                                quoteProvider.changeAuthor(value!);
                                if (value == quoteProvider.dropDownList.last) {
                                  quoteProvider.showOriginalAuthorField(true);
                                } else {
                                  quoteProvider.showOriginalAuthorField(false);
                                }
                              },
                              items: quoteProvider.dropDownList
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                        if (quoteProvider.isOthers)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: TextFormField(
                              controller: quoteProvider.authorController,
                              validator: (author) {
                                if (author == null || author.isEmpty) {
                                  return authorErrorMsg;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: const UnderlineInputBorder(),
                                hintText: 'Mention author here',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: Colors.grey.shade600),
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Checkbox(
                              value: quoteProvider.agreeToShare,
                              onChanged: quoteProvider.shareQuoteShareStatus,
                              activeColor: Colors.white,
                            ),
                            const Text(CreateNewQuote.shareQuoteReq),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // OutlinedButtonWidget(onPressed: (){
                            //   clearForm(quoteProvider);}, text: 'Clear'),
                            Expanded(
                              flex: 4,
                              child: OutlinedButtonWidget(
                                onPressed: () =>
                                    _openFileExplorer(context, quoteProvider),
                                text: 'Import from file',
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                invert: true,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 5,
                              child: OutlinedButtonWidget(
                                onPressed: () =>
                                    _showAcknowledgePopup(quoteProvider),
                                text: widget.isUpdating?CreateNewQuote.editQuote:CreateNewQuote.postQuote,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _showAcknowledgePopup(PostQuoteProvider quoteProvider) {
    debugPrint('postNewQuoteClicked');
    if (_formKey.currentState!.validate()) {
      showAlertPopupWithOptions(
        context: context,
        title: const Text('Acknowledgement'),
        message: [
          Text(
            CreateNewQuote.termsAndCondition1,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
          const SizedBox(height: 10),
          Text(
            CreateNewQuote.termsAndCondition2,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
        ],
        actions: [
          OutlinedButtonWidget(
            onPressed: () {
              _showAnimatedDialog(context, quoteProvider);
            },
            text: 'Preview',
            padding: const EdgeInsets.symmetric(horizontal: 10),
            invert: true,
          ),
          OutlinedButtonWidget(
            onPressed: () => handleQuotePosting(quoteProvider),
            text: 'Continue with Posting',
            padding: const EdgeInsets.symmetric(horizontal: 10),
          ),
        ],
      );
    }
  }

  handleQuotePosting(PostQuoteProvider quoteProvider) async {
    quoteProvider.agreeToTermsAndConditions();

    if(widget.isUpdating){
      final updateQuoteRes = await quoteProvider.editPost(documentSnapshot: widget.quoteDocument!);
      if (updateQuoteRes is String && mounted) {
        navPop(context);
        showToast(context, updateQuoteRes, info: true);
      } else if (updateQuoteRes == false && mounted) {
        navPop(context);
        showToast(context, CreateNewQuote.postingFailed, failure: true);
      } else if (updateQuoteRes == true && mounted) {
        navPop(context);
        debugPrint('posted new quote');
        showSuccessPopup(context: context, message: CreateNewQuote.updateSuccess);
      }
    }else {
      final postRes = await quoteProvider.postNewQuote();
      if (postRes is String && mounted) {
        navPop(context);
        showToast(context, postRes, info: true);
      } else if (postRes == false && mounted) {
        navPop(context);
        showToast(context, CreateNewQuote.postingFailed, failure: true);
      } else if (postRes == true && mounted) {
        navPop(context);
        debugPrint('posted new quote');
        showSuccessPopup(context: context, message: CreateNewQuote.postSuccess);
      }
    }


    clearForm(quoteProvider);
  }

  Future<void> _showAnimatedDialog(
      BuildContext context, PostQuoteProvider quoteProvider) async {
    final RegisterUserModel? profileData =
        await SharedPreferenceHelper.fetchSavedProfileData();
    if (mounted) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return FadeInAnimation(
            child: QuotePreviewWidget(
              quote: quoteProvider.quotesController.text,
              author:
                  quoteProvider.selectedAuthorType == CreateNewQuote.myselfCred
                      ? profileData!.name
                      : quoteProvider.authorController.text,
              profilePicPath: profileData!.profilePicture,
            ),
          );
        },
      );
    }
  }

  void clearForm(PostQuoteProvider quoteProvider) {
    debugPrint('clearing new quote');
    setState(() {
      _formKey.currentState?.reset();
    });

    quoteProvider.resetForm();
  }

  Future<void> _openFileExplorer(
      BuildContext context, PostQuoteProvider postQuoteProvider) async {
    final openFileRes = await postQuoteProvider.openFileExplorer();
    if (!openFileRes && mounted) {
      showSimpleAlertPopup(context, CreateNewQuote.fileOpenUnable);
    }
  }
}
