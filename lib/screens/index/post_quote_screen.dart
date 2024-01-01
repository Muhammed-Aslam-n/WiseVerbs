import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise_verbs/constants/constants.dart';
import 'package:wise_verbs/providers/tts_controller.dart';
import 'package:wise_verbs/utils/utils.dart';
import 'package:wise_verbs/widget/new_quote_preview_widget.dart';
import 'package:wise_verbs/widget/outlined_button.dart';
import 'package:wise_verbs/widget/route_transition.dart';

class PostQuoteScreen extends StatefulWidget {
  final bool isTtsEnabled;

  const PostQuoteScreen({Key? key, required this.isTtsEnabled})
      : super(key: key);

  @override
  State<PostQuoteScreen> createState() => _PostQuoteScreenState();
}

class _PostQuoteScreenState extends State<PostQuoteScreen> {
  final TextEditingController quotesController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
TTSProvider ttsProvider = TTSProvider();
  String _fileContent = '';

  Future<void> _openFileExplorer() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['txt']);

      if (result != null) {
        File file = File(result.files.single.path!);
        String content = await file.readAsString();

        setState(() {
          _fileContent = content;
          quotesController.clear();
          quotesController.text = _fileContent;
        });
      }
    } catch (exc, stack) {
      debugPrint('ExceptionCaughtWhileReadingFile $exc \n $stack');
      if (mounted) {
        showSimpleAlertPopup(
            context, "Couldn't read quote from the file.Try again later");
      }
    }
  }

  final List<String> dropDownList = ['Myself', 'Other'];
  bool isOthers = false;
  String dropdownValue = 'Myself';

  @override
  Widget build(BuildContext context) {
    ttsProvider = Provider.of<TTSProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new Quote'),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: quotesController,
                            validator: (quote) {
                              if (quote == null || quote.isEmpty) {
                                return quoteErrorMsg;
                              }
                              return null;
                            },
                            onChanged: (quote) {},
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '   Your quote goes here...',
                              hintStyle:
                                  Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Colors.grey.shade600,
                                      ),
                            ),
                          ),
                        ),
                        Consumer<TTSProvider>(
                          builder: (context,ttsOb,_) {
                            return OutlinedIconButtonWidget(
                              onPressed: () {
                                if(ttsOb.isSpeaking){
                                  ttsOb.stopSpeaking();
                                }else {
                                  ttsOb.speak(quotesController.text);
                                }
                              },
                              icon: ttsOb.isSpeaking?CupertinoIcons.pause:CupertinoIcons.ear,
                              iconColor: Colors.white,
                              bgColor: Colors.black,
                              borderColor: Colors.transparent,

                              // invert: true,
                            );
                          }
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      const Text('Credit:'),
                      const SizedBox(
                        width: 5,
                      ),
                      DropdownButton<String>(
                        value: dropdownValue,
                        elevation: 2,
                        underline: const SizedBox.shrink(),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue = value!;
                            if (value == dropDownList.last) {
                              isOthers = true;
                            } else {
                              isOthers = false;
                            }
                          });
                        },
                        items: dropDownList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  if (isOthers)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextFormField(
                        controller: authorController,
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
                    height: 60,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 4,
                        child: OutlinedButtonWidget(
                          onPressed: _openFileExplorer,
                          text: 'Import from file',
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          invert: true,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 5,
                        child: OutlinedButtonWidget(
                          onPressed: _showAcknowledgePopup,
                          text: 'Post',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showAcknowledgePopup() {
    debugPrint('postNewQuoteClicked');
    if (_formKey.currentState!.validate()) {
      showAlertPopupWithOptions(
        context: context,
        title: const Text('Acknowledgement'),
        message: [
          Text(
            'By accessing this content, you acknowledge and agree that any outcome or side effects resulting from this action will not hold the app or its creator responsible.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
          const SizedBox(height: 10),
          Text(
            'The creator has made efforts to ensure that no offensive or inappropriate content is shared.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
        ],
        actions: [
          OutlinedButtonWidget(
            onPressed: () {
              _showAnimatedDialog(context);
            },
            text: 'Preview',
            padding: const EdgeInsets.symmetric(horizontal: 10),
            invert: true,
          ),
          OutlinedButtonWidget(
            onPressed: handleQuotePosting,
            text: 'Continue with Posting',
            padding: const EdgeInsets.symmetric(horizontal: 10),
          ),
        ],
      );
    }
  }

  handleQuotePosting() {
    navPop(context);
    debugPrint('posting new quote');
    showSuccessPopup(context: context, message: 'Successfully posted');
    clearForm();
  }

  Future<void> _showAnimatedDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return FadeInAnimation(
          child: QuotePreviewWidget(
            quote: quotesController.text,
            author: authorController.text.isEmpty?'Anonymous':authorController.text,
          ),
        );
      },
    );
  }

  void clearForm() {
    debugPrint('clearing new quote');
    setState(() {
      _formKey.currentState?.reset();
      authorController.clear();
      quotesController.clear();
      isOthers = false;
      dropdownValue = dropDownList.first;
      _formKey.currentState?.reset();
    });
  }
}
