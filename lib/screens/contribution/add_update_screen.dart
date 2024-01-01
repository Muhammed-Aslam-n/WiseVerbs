import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wise_verbs/widget/outlined_button.dart';
import 'package:wise_verbs/widget/route_transition.dart';
import 'package:wise_verbs/widget/text_form_widget.dart';

import '../../constants/constants.dart';
import '../../utils/utils.dart';

class AddUpdateProfile extends StatefulWidget {
  const AddUpdateProfile({Key? key}) : super(key: key);

  @override
  State<AddUpdateProfile> createState() => _AddUpdateProfileState();
}

class _AddUpdateProfileState extends State<AddUpdateProfile> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Profile'),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: _croppedFile == null
                        ? ElevatedButton(
                            onPressed: () async {
                              _showSelectPlatformOption();
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
                                const Icon(CupertinoIcons.cloud_upload),
                                Text(
                                  '\nUpload  Photo',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(fontSize: 11),
                                ),
                              ],
                            ),
                          )
                        : AspectRatio(
                            aspectRatio: 2 / 0.9,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: FileImage(
                                        File(
                                          _croppedFile!.path,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right:
                                      MediaQuery.of(context).size.width * 0.26,
                                  child: Container(
                                    padding: const EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        _showSelectPlatformOption();
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                  ),
                  ...detailsSection(),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButtonWidget(onPressed: _resetForm, text: 'Clear',bgColor: Colors.black,textColor: Colors.white,),
                      OutlinedButtonWidget(onPressed: _validate, text: 'Upload'),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController favQuoteController = TextEditingController();
  TextEditingController mostInfController = TextEditingController();

  detailsSection() {
    return [
      TextFormWidget(
        errorMsg: nameErrorMsg,
        label: 'Name',
        helperText: 'Name',
        controller: nameController,
        icon: const Icon(Icons.person),
        inputFormatter: nameInputFormatter,
        validator: (name) {
          if (name == null || name.isEmpty) {
            return nameErrorMsg;
          }
          return null;
        },
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormWidget(
        errorMsg: occupationErrorMsg,
        label: 'Occupation',
        helperText: 'Occupation',
        controller: occupationController,
        inputFormatter: occupationInputFormatter,
        icon: const Icon(Icons.work_sharp),
        validator: (occupation) {
          if (occupation == null || occupation.isEmpty) {
            return occupationErrorMsg;
          }
          return null;
        },
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormWidget(
        errorMsg: nameErrorMsg,
        label: "Who's your biggest inspiration?",
        helperText: "Who's your biggest inspiration?",
        controller: mostInfController,
        icon: const Icon(CupertinoIcons.star_lefthalf_fill),
        inputFormatter: nameInputFormatter,
        validator: (influenced) {
          if (influenced == null || influenced.isEmpty) {
            return mostInfluencedErrorMsg;
          }
          return null;
        },
      ),
      const SizedBox(
        height: 30,
      ),
      TextFormWidget(
        errorMsg: nameErrorMsg,
        label: 'Favourite Quote',
        helperText: 'Favourite Quote',
        controller: favQuoteController,
        maxLine: 3,
        outLineBorder: true,
        icon: const Icon(Icons.format_quote_outlined),
        inputFormatter: quoteInputFormatter,
        validator: (favQuote) {
          if (favQuote == null || favQuote.isEmpty) {
            return favouriteQuoteErrorMsg;
          }
          return null;
        },
      ),
      const SizedBox(
        height: 30,
      ),
      TextFormWidget(
        errorMsg: nameErrorMsg,
        label: 'About you',
        helperText: 'About you',
        controller: descriptionController,
        maxLine: 3,
        outLineBorder: true,
        icon: const Icon(Icons.description),
        inputFormatter: aboutYouInputFormatter,
        inputAction: TextInputAction.done,
        validator: (aboutYou) {
          if (aboutYou == null || aboutYou.isEmpty) {
            return selfDescErrorMsg;
          }
          return null;
        },
      ),
    ];
  }

  void _validate() {
    if (_formKey.currentState!.validate()) {}
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _croppedFile=null;
    nameController.clear();
    occupationController.clear();
    descriptionController.clear();
    favQuoteController.clear();
    mostInfController.clear();
    _formKey.currentState?.reset();
    setState(() {
      debugPrint('setStateCalled');
    });
  }

  XFile? _pickedFile;

  CroppedFile? _croppedFile;

  void _showSelectPlatformOption() {
    showDialog(
        context: context,
        builder: (builder) {
          return Dialog(
            backgroundColor: Theme.of(context).highlightColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Upload From',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.w600),
                  ),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            navPop(context);
                            await _requestPermissionForProfilePic(
                                ImageSource.gallery);
                          },
                          icon: Column(
                            children: [
                              Image.asset(
                                'assets/icons/gallery_icon.png',
                                height: 60,
                                width: 60,
                              ),
                              Text('Gallery',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.grey.shade900)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        IconButton(
                          icon: Column(
                            children: [
                              Image.asset('assets/icons/camera_icon.png',
                                  height: 60, width: 60),
                              Text('Camera',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.grey.shade900)),
                            ],
                          ),
                          onPressed: () async {
                            navPop(context);
                            await _requestPermissionForProfilePic(
                                ImageSource.camera);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future _requestPermissionForProfilePic(ImageSource source) async {
    _pickProfile(source);
    // await Permission.storage.request();
    // if (await Permission.storage.status == PermissionStatus.granted) {
    //   await Permission.camera.request();
    //   if (await Permission.camera.status == PermissionStatus.granted) {
    //     _pickProfile(source);
    //   } else {
    //     if (mounted) {
    //       showSimpleAlertPopup(
    //           context, 'Please grant camera permission to proceed further');
    //     }
    //   }
    // } else {
    //   if (mounted) {
    //     showSimpleAlertPopup(
    //         context, 'Please grant storage permission to proceed further');
    //   }
    // }
  }

  void _pickProfile(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      _pickedFile = await picker.pickImage(source: source);
      if (_pickedFile != null) {
        final cropped = await _cropImage();
        if (cropped) {
          await _saveImage();
          if (mounted) {
            showToast(
              context,
              'Profile picture uploaded successfully',
              success: true,
            );
            setState(() {});
          }
        } else {
          if (mounted) {
            showToast(
              context,
              'Some error occurred while preparing profile pic',
              failure: true,
            );
            setState(() {});
          }
        }
      } else {
        if (mounted) {
          showToast(context,
              'Please ${source == ImageSource.camera ? 'capture' : 'pick'} an image to upload',
              info: true);
          setState(() {});
        }
      }
    } catch (exc, stack) {
      debugPrint('ExceptionCaughtWhilePickingImage $exc \n $stack');
      if (mounted) {
        showToast(context, 'Profile picture uploading failed.Try again later',
            failure: true);
      }
    }
  }

  Future<bool> _saveImage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final now = DateTime.now();
      final formattedDate = '${now.year}-${now.month}-${now.day}';
      final imageName = 'profile_pic_$formattedDate.png';
      final imagePath = '${directory.path}/$imageName';
      final file = File(_croppedFile!.path);
      await file.copy(imagePath);
      debugPrint('Image saved as $imagePath');
      return true;
    } catch (exc, stack) {
      debugPrint('ExceptionCaughtWhileSavingImage $exc \n $stack');
      return false;
    }
  }

  Future<bool> _cropImage() async {
    try {
      if (_pickedFile != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: _pickedFile!.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Adjust your Profile Pic',
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Adjust your Profile Pic',
            ),
            WebUiSettings(
              context: context,
              presentStyle: CropperPresentStyle.dialog,
              boundary: const CroppieBoundary(
                width: 520,
                height: 520,
              ),
              viewPort: const CroppieViewPort(
                  width: 480, height: 480, type: 'circle'),
              enableExif: true,
              enableZoom: true,
              showZoomer: true,
            ),
          ],
        );
        if (croppedFile != null) {
          setState(() {
            _croppedFile = croppedFile;
          });
        }
        return true;
      }
      return false;
    } catch (exc, stack) {
      debugPrint('ExceptionCaughtWhileCroppingImage $exc \n $stack');
      return false;
    }
  }
}
