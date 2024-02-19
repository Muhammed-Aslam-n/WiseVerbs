import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:wise_verbs/models/register_user_model.dart';
import 'package:wise_verbs/providers/profile_provider.dart';
import 'package:wise_verbs/screens/auth_screen/update_credentials.dart';
import 'package:wise_verbs/widget/loading_overlay.dart';
import 'package:wise_verbs/widget/loading_widget.dart';
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

  late ProfileProvider provider;

  @override
  void initState() {
    provider = Provider.of<ProfileProvider>(context, listen: false);
    provider.fetchUserProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (pop) {
        provider.changeEditStatus(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Your Profile'),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  // PopupMenuItem(
                  //   child: const Text('Update Email'),
                  //   onTap: () => navPush(
                  //     context,
                  //     UpdateCredentialsScreen(updateType: UpdateType.email,),
                  //   ),
                  // ),
                  PopupMenuItem(
                    child: const Text('Update Password'),
                    onTap: () => navPush(
                      context,
                      UpdateCredentialsScreen(updateType: UpdateType.password,),
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
        body: Consumer<ProfileProvider>(builder: (context, pProvider, _) {
          if (pProvider.userProfileData == null) {
            return const Center(
              child: LoadingWidget(),
            );
          }
          RegisterUserModel userData = pProvider.userProfileData!;
          return LoadingOverlay(
            isLoading: pProvider.isLoading,
            child: GestureDetector(
              // onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        userData.profilePicture.isEmpty &&
                                pProvider.croppedFile == null
                            ? uploadProfilePicWidget(
                                onPressed: () {
                                  _showSelectPlatformOption();
                                },
                              )
                            : pProvider.croppedFile == null
                                ? profileDisplayWidget(
                                    networkImage: true,
                                    isEditing: pProvider.isEditing,
                                    imageFile: userData.profilePicture,
                                    onPressed: () {
                                      _showSelectPlatformOption();
                                    },
                                  )
                                : profileDisplayWidget(
                                    networkImage: false,
                                    isEditing: pProvider.isEditing,
                                    imageFile:
                                        File(pProvider.croppedFile!.path),
                                    onPressed: () {
                                      _showSelectPlatformOption();
                                    },
                                  ),
                        ...detailsSection(provider: pProvider),
                        const SizedBox(
                          height: 25,
                        ),
                        pProvider.isEditing
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  OutlinedButtonWidget(
                                    onPressed: () {
                                      provider.changeEditStatus(false);
                                    },
                                    text: 'Cancel',
                                    bgColor: Colors.black,
                                    textColor: Colors.white,
                                  ),
                                  OutlinedButtonWidget(
                                    onPressed: () =>
                                        _validate(userData.profilePicture),
                                    text: 'Update',
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
        floatingActionButton:
            Consumer<ProfileProvider>(builder: (context, pProvider, _) {
          if (provider.isEditing == false) {
            return FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () {
                provider.changeEditStatus(true);
              },
              child: const Icon(
                Icons.edit_note_outlined,
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }

  detailsSection({required ProfileProvider provider}) {
    return [
      TextFormWidget(
        isEditing: provider.isEditing,
        errorMsg: nameErrorMsg,
        label: 'Name',
        helperText: 'Name',
        controller: provider.nameController,
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
        isEditing: provider.isEditing,
        errorMsg: occupationErrorMsg,
        label: 'Occupation',
        helperText: 'Occupation',
        controller: provider.occupationController,
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
        isEditing: provider.isEditing,
        errorMsg: nameErrorMsg,
        label: "Who's your biggest inspiration?",
        helperText: "Who's your biggest inspiration?",
        controller: provider.mostInfController,
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
        isEditing: provider.isEditing,
        errorMsg: nameErrorMsg,
        label: 'Favourite Quote',
        helperText: 'Favourite Quote',
        controller: provider.favQuoteController,
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
        isEditing: provider.isEditing,
        errorMsg: nameErrorMsg,
        label: 'About you',
        helperText: 'About you',
        controller: provider.descriptionController,
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

  Widget uploadProfilePicWidget({
    required VoidCallback onPressed,
  }) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          _showSelectPlatformOption();
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).highlightColor,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          // Text color
          side: const BorderSide(color: Colors.white, width: 0.5),
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
              style:
                  Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileDisplayWidget({
    required dynamic imageFile,
    required VoidCallback onPressed,
    required bool networkImage,
    required bool isEditing,
    Icon? icon,
  }) {
    return AspectRatio(
      aspectRatio: 2 / 0.9,
      child: Stack(
        children: [
          Center(
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.width * 0.6,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: networkImage
                      ? DecorationImage(
                          image: NetworkImage(
                            imageFile,
                          ),
                        )
                      : DecorationImage(
                          image: FileImage(
                            imageFile,
                          ),
                        )),
            ),
          ),
          isEditing
              ? Positioned(
                  right: MediaQuery.of(context).size.width * 0.26,
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    child: IconButton(
                      onPressed: onPressed,
                      icon: icon ??
                          const Icon(
                            Icons.edit,
                          ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  void _validate(imagePath) async {
    if (_formKey.currentState!.validate()) {
      RegisterUserModel updatedData = RegisterUserModel(
        name: provider.nameController.text,
        occupation: provider.occupationController.text,
        inspiration: provider.mostInfController.text,
        favQuote: provider.favQuoteController.text,
        aboutYou: provider.descriptionController.text,
        profilePicture: provider.croppedFile != null
            ? provider.croppedFile!.path
            : imagePath,
      );
      final updateRes = await provider.updateUserProfile(
          updateData: updatedData,
          profilePicUpdating: provider.croppedFile != null ? true : false);
      if (updateRes == true && mounted) {
        showToast(context, 'Profile updated successfully', success: true);
      } else if (mounted) {
        showToast(context, 'Something went wrong, Try later', failure: true);
      }
    }
  }

  // void _resetForm() {
  //   _formKey.currentState?.reset();
  //   _croppedFile = null;
  //   provider.nameController.clear();
  //   provider.occupationController.clear();
  //   provider.descriptionController.clear();
  //   provider.favQuoteController.clear();
  //   provider.mostInfController.clear();
  //   _formKey.currentState?.reset();
  //   setState(() {
  //     debugPrint('setStateCalled');
  //   });
  // }

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
      provider.pickedFile = await picker.pickImage(source: source);
      if (provider.pickedFile != null) {
        final cropped = await _cropImage();
        if (cropped) {
          await _saveImage();
          if (mounted) {
            showToast(
              context,
              'Profile picture selected successfully',
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
      final file = File(provider.croppedFile!.path);
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
      if (provider.pickedFile != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: provider.pickedFile!.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Adjust your Profile Pic',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
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
          provider.changeCroppedFile(croppedFile);
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
