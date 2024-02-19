import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:wise_verbs/models/login_model.dart';
import 'package:wise_verbs/models/register_user_model.dart';
import 'package:wise_verbs/providers/auth_provider/register_provider.dart';
import 'package:wise_verbs/screens/auth_screen/login_screen.dart';
import 'package:wise_verbs/widget/loading_overlay.dart';
import 'package:wise_verbs/widget/outlined_button.dart';
import 'package:wise_verbs/widget/route_transition.dart';

import '../../constants/constants.dart';
import '../../providers/connectivity_provider.dart';
import '../../utils/formatters_and_extensions.dart';
import '../../utils/utils.dart';
import '../../widget/login_textfield_widget.dart';
import '../index/index.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController(text: 'Aslam');
  TextEditingController occupationController =
      TextEditingController(text: 'Developer');
  TextEditingController aboutYou = TextEditingController(text: 'Fine Man');
  TextEditingController favQuoteController =
      TextEditingController(text: 'This too shall pass');
  TextEditingController inspiredController =
      TextEditingController(text: 'Nelson');

  TextEditingController emailController =
      TextEditingController(text: 'aslamnputhanpurayil@gmail.com');
  TextEditingController passwordController =
      TextEditingController(text: 'Aslam123');
  TextEditingController confirmPasswordController =
      TextEditingController(text: 'Aslam123');

  bool _showFrontSide = true;
  final bool _flipXAxis = true;

  void _switchCard() {
    setState(() {
      _showFrontSide = !_showFrontSide;
    });
  }

  // bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Consumer<RegistrationProvider>(
            builder: (context, registrationProvider, _) {
          return LoadingOverlay(
            isLoading: registrationProvider.isLoading,
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: width * 0.15,
                      ),
                      Text(
                        'Create new account!',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        'Please fill in the form to continue',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(
                        height: width * 0.08,
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 800),
                        transitionBuilder: __transitionBuilder,
                        layoutBuilder: (widget, list) =>
                            Stack(children: [widget!, ...list]),
                        switchInCurve: Curves.easeInBack,
                        switchOutCurve: Curves.easeInBack.flipped,
                        child: _showFrontSide
                            ? _buildFront(width)
                            : _buildRear(width),
                      ),
                      SizedBox(
                        height: width * 0.05,
                      ),
                      if (_showFrontSide == false)
                        SizedBox(
                          height: width * 0.2,
                        ),
                      RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  navPushReplace(context, const LoginScreen());
                                  _resetForm();
                                },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: width * 0.14,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi / 14, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_showFrontSide) != widget!.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.00001;
        tilt *= isUnder ? -1.0 : 1.0;

        // Only show rear when animation is complete
        if (isUnder && animation.value < pi / 2) {
          return const SizedBox
              .shrink(); // Show an empty container or nothing if the rear should not be visible yet
        }

        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: _flipXAxis
              ? (Matrix4.rotationY(value)..setEntry(3, 0, tilt))
              : (Matrix4.rotationX(value)..setEntry(3, 1, tilt)),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }

  Widget __buildLayout(
      {Key? key, Widget? child, String? faceName, Color? backgroundColor}) {
    return Container(
      key: key,
      child: child,
    );
  }

  Widget _buildFront(width) {
    return __buildLayout(
      key: const ValueKey(true),
      backgroundColor: Colors.blue,
      faceName: "Front",
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
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
                          side:
                              const BorderSide(color: Colors.white, width: 0.5),
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
                              right: MediaQuery.of(context).size.width * 0.26,
                              child: Container(
                                padding: const EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.tertiary,
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
              ...detailsSection(width),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRear(width) {
    return __buildLayout(
      key: const ValueKey(false),
      backgroundColor: Colors.blue.shade700,
      faceName: "Rear",
      child: loginForm(width),
    );
  }

  Widget loginForm(
    double width,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Column(
        children: [
          SizedBox(
            height: width * 0.12,
          ),
          AuthFormTextField(
            controller: emailController,
            hintText: 'Email',
            formatters: [EmailInputFormatter()],
            obscureText: false,
            validator: (String? email) {
              if (email == null || email.isEmpty) {
                return noEmailMsg;
              }
              final invalidReason = email.invalidEmailReason;
              if (invalidReason != null) {
                return invalidReason;
              }
              return null;
            },
          ),
          SizedBox(
            height: width * 0.12,
          ),
          AuthFormTextField(
            controller: passwordController,
            hintText: 'Password',
            formatters: [PasswordInputFormatter()],
            obscureText: true,
            validator: (String? password) {
              if (password == null || password.isEmpty) {
                return noPasswordMsg;
              }
              final invalidReason = password.invalidPasswordReason;
              if (invalidReason != null) {
                return invalidReason;
              }
              return null;
            },
          ),
          SizedBox(
            height: width * 0.12,
          ),
          AuthFormTextField(
            controller: confirmPasswordController,
            hintText: 'Confirm Password',
            formatters: [PasswordInputFormatter()],
            obscureText: true,
            validator: (String? confirmPassword) {
              if (confirmPassword == null || confirmPassword.isEmpty) {
                return noConfirmPassMsg;
              }
              final invalidReason = confirmPassword.invalidPasswordReason;
              if (invalidReason != null) {
                return invalidReason;
              }
              return null;
            },
          ),
          SizedBox(
            height: width * 0.12,
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButtonWidget(
                  onPressed: () {
                    _switchCard();
                  },
                  text: 'Previous',
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  invert: true,
                ),
              ),
              SizedBox(
                width: width * 0.12,
              ),
              Expanded(
                flex: 2,
                child: OutlinedButtonWidget(
                  onPressed: _validate,
                  text: 'Register',
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ],
          ),
          SizedBox(
            height: width * 0.08,
          ),
        ],
      ),
    );
  }

  detailsSection(width) {
    return [
      SizedBox(
        height: width * 0.08,
      ),
      AuthFormTextField(
        controller: nameController,
        hintText: 'Name',
        formatters: nameInputFormatter,
        obscureText: false,
        validator: (name) {
          if (name == null || name.isEmpty) {
            return nameErrorMsg;
          }
          return null;
        },
      ),
      // TextFormWidget(
      //   errorMsg: nameErrorMsg,
      //   label: 'Name',
      //   helperText: 'Name',
      //   controller: nameController,
      //   icon: const Icon(Icons.person),
      //   inputFormatter: nameInputFormatter,
      //   validator: (name) {
      //     if (name == null || name.isEmpty) {
      //       return nameErrorMsg;
      //     }
      //     return null;
      //   },
      // ),

      SizedBox(
        height: width * 0.05,
      ),
      AuthFormTextField(
        controller: occupationController,
        validator: (occupation) {
          if (occupation == null || occupation.isEmpty) {
            return occupationErrorMsg;
          }
          return null;
        },
        hintText: 'Occupation',
        formatters: occupationInputFormatter,
        obscureText: false,
      ),
      // TextFormWidget(
      //   errorMsg: occupationErrorMsg,
      //   label: 'Occupation',
      //   helperText: 'Occupation',
      //   controller: occupationController,
      //   inputFormatter: occupationInputFormatter,
      //   icon: const Icon(Icons.work_sharp),
      //   validator: (occupation) {
      //     if (occupation == null || occupation.isEmpty) {
      //       return occupationErrorMsg;
      //     }
      //     return null;
      //   },
      // ),
      SizedBox(
        height: width * 0.05,
      ),
      AuthFormTextField(
        controller: inspiredController,
        validator: (influenced) {
          if (influenced == null || influenced.isEmpty) {
            return mostInfluencedErrorMsg;
          }
          return null;
        },
        hintText: "Who's your biggest inspiration?",
        formatters: nameInputFormatter,
        obscureText: false,
      ),
      // TextFormWidget(
      //   errorMsg: nameErrorMsg,
      //   label: "Who's your biggest inspiration?",
      //   helperText: "Who's your biggest inspiration?",
      //   controller: mostInfController,
      //   icon: const Icon(CupertinoIcons.star_lefthalf_fill),
      //   inputFormatter: nameInputFormatter,
      //   validator: (influenced) {
      //     if (influenced == null || influenced.isEmpty) {
      //       return mostInfluencedErrorMsg;
      //     }
      //     return null;
      //   },
      // ),
      SizedBox(
        height: width * 0.05,
      ),

      AuthFormTextField(
        controller: favQuoteController,
        validator: (favQuote) {
          if (favQuote == null || favQuote.isEmpty) {
            return favouriteQuoteErrorMsg;
          }
          return null;
        },
        hintText: 'Favourite Quote',
        formatters: quoteInputFormatter,
        obscureText: false,
        maxLines: 3,
      ),

      // TextFormWidget(
      //   errorMsg: nameErrorMsg,
      //   label: 'Favourite Quote',
      //   helperText: 'Favourite Quote',
      //   controller: favQuoteController,
      //   maxLine: 3,
      //   outLineBorder: true,
      //   icon: const Icon(Icons.format_quote_outlined),
      //   inputFormatter: quoteInputFormatter,
      //   validator: (favQuote) {
      //     if (favQuote == null || favQuote.isEmpty) {
      //       return favouriteQuoteErrorMsg;
      //     }
      //     return null;
      //   },
      // ),
      SizedBox(
        height: width * 0.05,
      ),
      AuthFormTextField(
        controller: aboutYou,
        hintText: 'About you',
        formatters: aboutYouInputFormatter,
        obscureText: false,
        maxLines: 3,
        validator: (aboutYou) {
          if (aboutYou == null || aboutYou.isEmpty) {
            return selfDescErrorMsg;
          }
          return null;
        },
      ),
      // TextFormWidget(
      //   errorMsg: nameErrorMsg,
      //   label: 'About you',
      //   helperText: 'About you',
      //   controller: descriptionController,
      //   maxLine: 3,
      //   outLineBorder: true,
      //   icon: const Icon(Icons.description),
      //   inputFormatter: aboutYouInputFormatter,
      //   inputAction: TextInputAction.done,
      //   validator: (aboutYou) {
      //     if (aboutYou == null || aboutYou.isEmpty) {
      //       return selfDescErrorMsg;
      //     }
      //     return null;
      //   },
      // ),
      SizedBox(
        height: width * 0.08,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButtonWidget(
            onPressed: _resetForm,
            text: 'Clear',
            bgColor: Colors.black,
            textColor: Colors.white,
          ),
          OutlinedButtonWidget(
            onPressed: _validateSecOne,
            text: 'Next',
          ),
        ],
      ),
    ];
  }

  _validateSecOne() {
    if (nameController.text.isNotEmpty &&
        occupationController.text.isNotEmpty &&
        inspiredController.text.isNotEmpty &&
        favQuoteController.text.isNotEmpty &&
        aboutYou.text.isNotEmpty) {
      _switchCard();
    } else {
      if (mounted) {
        showToast(
          context,
          'Please fillout your information to proceed next',
          info: true,
        );
      }
    }
  }

  void _validate() async {
    if (_formKey.currentState!.validate()) {
      if (_croppedFile == null) {
        showToast(context, 'Please pick a profile picture and try again',
            info: true);
        return;
      }
      if (passwordController.text == confirmPasswordController.text) {
        final connectivityProvider =
            Provider.of<ConnectivityProvider>(context, listen: false);

        if (connectivityProvider.isConnected) {
          final provider =
              Provider.of<RegistrationProvider>(context, listen: false);
          final RegisterUserModel registerData = RegisterUserModel(
            name: nameController.text.trim(),
            occupation: occupationController.text.trim(),
            inspiration: inspiredController.text.trim(),
            favQuote: favQuoteController.text.trim(),
            aboutYou: aboutYou.text.trim(),
            profilePicture: _croppedFile!.path,
          );
          final LoginModel loginCredential = LoginModel(
            email: emailController.text.trim(),
            password: passwordController.text,
          );
          final registerUser = await provider.registerUser(
            registerDetails: registerData,
            loginCredentials: loginCredential,
          );
          if (registerUser == true) {
            debugPrint('registration Success');
            if (mounted) {
              navPushReplace(context, const IndexScreen());
            }
          } else if (registerUser.runtimeType.toString().toLowerCase() ==
              'string') {
            if (mounted) {
              showToast(context, registerUser, info: true);
            }
          }
        } else {
          showToast(context, 'Please connect any network to login', info: true);
        }
      } else {
        showToast(context, "Passwords doesn't match");
      }
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _croppedFile = null;
    nameController.clear();
    occupationController.clear();
    aboutYou.clear();
    favQuoteController.clear();
    inspiredController.clear();
    emailController.clear();
    emailController = TextEditingController();
    passwordController = TextEditingController();
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
        if (cropped == 1) {
          await _saveImage();
          if (mounted) {
            showToast(
              context,
              'Profile picture selected successfully',
              success: true,
            );
            setState(() {});
          }
        } else if (cropped == 0) {
          if (mounted) {
            showToast(
              context,
              'Please crop you profile picture',
              failure: true,
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

  Future<int> _cropImage() async {
    try {
      if (_pickedFile != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: _pickedFile!.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          cropStyle: CropStyle.circle,
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
          setState(() {
            _croppedFile = croppedFile;
          });
          return 1;
        }
        return 0;
      }
      return -1;
    } catch (exc, stack) {
      debugPrint('ExceptionCaughtWhileCroppingImage $exc \n $stack');
      return -1;
    }
  }
}
