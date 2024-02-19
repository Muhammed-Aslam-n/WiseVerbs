// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise_verbs/utils/utils.dart';
import 'package:wise_verbs/widget/loading_overlay.dart';

import '../../constants/constants.dart';
import '../../providers/profile_provider.dart';
import '../../utils/formatters_and_extensions.dart';
import '../../widget/login_textfield_widget.dart';
import '../../widget/outlined_button.dart';

enum UpdateType {
  email,
  password,
}

class UpdateCredentialsScreen extends StatelessWidget {
  final UpdateType updateType;

  UpdateCredentialsScreen({Key? key, required this.updateType})
      : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: true,
      onPopInvoked: (pop) {
        final provider = Provider.of<ProfileProvider>(context, listen: false);
        provider.resetUpdateCred();
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text(UpdateProfileConstants.appBarTitle),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Consumer<ProfileProvider>(
              builder: (context, pProvider, _) {
                return LoadingOverlay(
                  isLoading: pProvider.isSomethingGoingOn,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: width * 0.25,
                        ),
                        if (updateType == UpdateType.email)
                          ...showUpdateEmailWidget(
                            context,
                            pProvider,
                            width,
                          )
                        else
                          ...showUpdatePasswordWidget(
                            context,
                            pProvider,
                            width,
                          ),
                        SizedBox(
                          height: width * 0.08,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> showUpdateEmailWidget(
    context,
    ProfileProvider pProvider,
    double width,
  ) {
    return [
      SizedBox(
        height: width * 0.08,
      ),
      AuthFormTextField(
        // enabled: !(pProvider.updateState == UpdatePassCredEnum.mailVerified),
        controller: pProvider.newEmailController,
        keyboardType: TextInputType.emailAddress,
        hintText: UpdateProfileConstants.emailHintText,
        formatters: const [],
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
        // onChanged: (String v) async {
        //   debugPrint('emailEditingComplete');
        //   if (v.invalidEmailReason == null) {
        //     debugPrint('validEmailEntered');
        //     await pProvider.checkNewEmailIsSame();
        //   } else {
        //     pProvider.changeEmailVerifiedStatus(
        //       UpdatePassCredEnum.initial,
        //     );
        //   }
        // },
      ),
      SizedBox(
        height: width * 0.12,
      ),
      AuthFormTextField(
        controller: pProvider.currentPasswordController,
        hintText: UpdateProfileConstants.currentPasswordHint,
        // enabled: pProvider.updateState == UpdatePassCredEnum.mailVerified,
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
      // if (pProvider.updateState == UpdatePassCredEnum.mailNotVerified)
      Padding(
        padding: EdgeInsets.only(top: width * 0.05),
        child: pProvider.isSomethingGoingOn
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : OutlinedButtonWidget(
                invert: true,
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (pProvider.updateState ==
                      UpdatePassCredEnum.mailNotVerified) {
                    await verifyNewMail(
                      context,
                      pProvider,
                    );
                  } else if (pProvider.updateState ==
                      UpdatePassCredEnum.mailSent) {
                    await confirmVerification(
                      context,
                      pProvider,
                    );
                    await pProvider.confirmVerification();
                  } else {
                    await updateEmail(
                      context,
                      pProvider,
                    );
                  }
                },
                text:
                    pProvider.updateState == UpdatePassCredEnum.mailNotVerified
                        ? UpdateProfileConstants.verifyEmailText
                        : pProvider.updateState == UpdatePassCredEnum.mailSent
                            ? UpdateProfileConstants.confirmVerification
                            : UpdateProfileConstants.updateEmail,
              ),
      ),
    ];
  }

  updateEmail(BuildContext context, ProfileProvider pProvider) async {
    if (_formKey.currentState!.validate()) {
      final verifyEmail = await pProvider.updateNewEmail();
      if (verifyEmail is String) {
        showToast(
          context,
          verifyEmail.isNotEmpty
              ? verifyEmail
              : UpdateProfileConstants.someErrorOccurred,
          failure: true,
        );
      } else if (verifyEmail) {
        showToast(context, UpdateProfileConstants.emailVerifiedSuccess, success: true);
      } else {
        showSimpleAlertPopup(
            context, '');
      }
    }
  }

  verifyNewMail(context, ProfileProvider pProvider) async {
    final verifyRes = await pProvider.verifyNewEmail();
    if (verifyRes is String) {
      showToast(
        context,
        verifyRes.isNotEmpty ? verifyRes : UpdateProfileConstants.someErrorOccurred,
        info: true,
      );
    } else if (!verifyRes) {
      showToast(context, UpdateProfileConstants.verifyMailSendingFailed, failure: true);
    } else {
      showSimpleAlertPopup(
        context,
        UpdateProfileConstants.verificationMailSent,
      );
    }
  }

  confirmVerification(context, ProfileProvider pProvider) async {
    final confirmRes = await pProvider.confirmVerification();
    if (confirmRes is String) {
      showToast(
        context,
        confirmRes.isNotEmpty ? confirmRes : UpdateProfileConstants.someErrorOccurred,
        info: true,
      );
    } else if (!confirmRes) {
      showToast(context, UpdateProfileConstants.failedNewMailVerification, failure: true);
    } else {
      showSimpleAlertPopup(
        context,
        UpdateProfileConstants.newMailVerified,
      );
    }
  }

  List<Widget> showUpdatePasswordWidget(
      BuildContext context, ProfileProvider pProvider, double width) {
    return [
      SizedBox(
        height: width * 0.12,
      ),
      AuthFormTextField(
        controller: pProvider.currentPasswordController,
        hintText: UpdateProfileConstants.currentPasswordHint,
        // enabled: pProvider.updateState == UpdatePassCredEnum.mailVerified,
        formatters: [PasswordInputFormatter()],
        obscureText: false,
        validator: pProvider.updateState == UpdatePassCredEnum.mailVerified
            ? (String? password) {
                if (password == null || password.isEmpty) {
                  return noPasswordMsg;
                }
                final invalidReason = password.invalidPasswordReason;
                if (invalidReason != null) {
                  return invalidReason;
                }
                return null;
              }
            : null,
      ),
      SizedBox(
        height: width * 0.12,
      ),
      AuthFormTextField(
        controller: pProvider.passwordController,
        hintText: UpdateProfileConstants.newPassword,
        // enabled: pProvider.updateState == UpdatePassCredEnum.mailVerified,
        formatters: [PasswordInputFormatter()],
        obscureText: false,
        validator: pProvider.updateState == UpdatePassCredEnum.mailVerified
            ? (String? password) {
                if (password == null || password.isEmpty) {
                  return noPasswordMsg;
                }
                final invalidReason = password.invalidPasswordReason;
                if (invalidReason != null) {
                  return invalidReason;
                }
                return null;
              }
            : null,
      ),
      SizedBox(
        height: width * 0.12,
      ),
      AuthFormTextField(
        controller: pProvider.confirmPasswordController,
        hintText: UpdateProfileConstants.confirmNewPass,
        // enabled: pProvider.updateState == UpdatePassCredEnum.mailVerified,
        formatters: [PasswordInputFormatter()],
        obscureText: false,
        validator: pProvider.updateState == UpdatePassCredEnum.mailVerified
            ? (String? confirmPassword) {
                if (confirmPassword == null || confirmPassword.isEmpty) {
                  return noConfirmPassMsg;
                }
                final invalidReason = confirmPassword.invalidPasswordReason;
                if (invalidReason != null) {
                  return invalidReason;
                }
                return null;
              }
            : null,
      ),
      SizedBox(
        height: width * 0.12,
      ),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: OutlinedButtonWidget(
              onPressed:
                  // pProvider.updateState == UpdatePassCredEnum.mailVerified
                  //     ?
                  () {
                updatePassword(context, pProvider);
              },
              // : () {},
              text: UpdateProfileConstants.updatePass,
              // bgColor: pProvider.updateState != UpdatePassCredEnum.mailVerified
              //     ? Colors.white60
              //     : null,
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
        ],
      ),
    ];
  }

  updatePassword(BuildContext context, ProfileProvider pProvider) async {
    if (_formKey.currentState!.validate()) {
      final updatePassRes = await pProvider.updatePassword();
      if (updatePassRes is String) {
        showToast(
          context,
          updatePassRes.isNotEmpty
              ? updatePassRes
              : UpdateProfileConstants.someErrorOccurred,
          info: true,
        );
      } else if (!updatePassRes) {
        showToast(context, UpdateProfileConstants.passUpdateFailed,failure: true);
      } else {
        showSimpleOneliner(
          context,
            UpdateProfileConstants.passChangedSuccess,
        );
      }
    }

  }
}
