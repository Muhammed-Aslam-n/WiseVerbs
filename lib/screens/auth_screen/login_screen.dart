import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise_verbs/constants/constants.dart';
import 'package:wise_verbs/models/login_model.dart';
import 'package:wise_verbs/providers/auth_provider/login_provider.dart';
import 'package:wise_verbs/providers/connectivity_provider.dart';
import 'package:wise_verbs/screens/auth_screen/register_screen.dart';
import 'package:wise_verbs/utils/formatters_and_extensions.dart';
import 'package:wise_verbs/utils/utils.dart';
import 'package:wise_verbs/widget/loading_overlay.dart';
import 'package:wise_verbs/widget/login_textfield_widget.dart';
import 'package:wise_verbs/widget/outlined_button.dart';
import 'package:wise_verbs/widget/route_transition.dart';

import '../index/index.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController =
      TextEditingController(text: 'aslamnputhanpurayil@gmail.com');
  TextEditingController passwordController =
      TextEditingController(text: 'Aslam123');


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Consumer<LoginProvider>(builder: (context, loginProvider, _) {
      return LoadingOverlay(
        isLoading: loginProvider.isLoading,
        child: Scaffold(
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: width * 0.3,
                        ),
                        Text(
                          'Welcome Back!',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        Text(
                          'Sign in to your account',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        loginForm(width),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
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
            formatters: const [],
            obscureText: false,
            validator: (String? username) {
              if (username == null || username.isEmpty) {
                return noUsernameMsg;
              }
              final invalidReason = username.invalidEmailReason;
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
            maxLines: 1,
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
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: _handleForgotPassword,
              child: Text(
                'Forgot password?',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline),
              ),
            ),
          ),
          SizedBox(
            height: width * 0.18,
          ),
          OutlinedButtonWidget(
            onPressed: _validateForm,
            text: 'Login',
            textLarge: true,
            resize: true,
          ),
          SizedBox(
            height: width * 0.15,
          ),
          RichText(
            text: TextSpan(
              text: "Don't have an account? ",
              children: [
                TextSpan(
                  text: 'Sign in',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.blue),
                  // Add onTap or onPressed to navigate to the sign-in page
                  // Example:
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      navPush(context, const RegisterScreen());
                      _clearFrom();
                    },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _clearFrom() {
    // _formKey.currentState?.reset();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _formKey.currentState?.reset();
    setState(() {});
  }

  _validateForm() async {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context, listen: false);

  if (_formKey.currentState!.validate()) {
      if(connectivityProvider.isConnected){
        final LoginModel loginCredentials = LoginModel(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
        final loginProvider = Provider.of<LoginProvider>(context, listen: false);
        final loginRes = await loginProvider.loginUser(loginCredentials);
        if (loginRes == true) {
          debugPrint('registration Success');
          if (mounted) {
            navPushReplace(context, const IndexScreen());
          }
        } else if (loginRes.runtimeType.toString().toLowerCase() == 'string') {
          if (mounted) {
            showToast(context, loginRes, info: true);
          }
        }
      }
      else{
        showToast(context, 'Please connect any network to login', info: true);
      }
      debugPrint('Login Form Validated');
    } else {
      debugPrint('Login Form Not Validated');
    }
  }

  void _handleForgotPassword() {
    if (emailController.text.isEmpty) {
      showToast(context, 'Please enter your email to reset password',
          info: true);
    } else {
      final emailReason = emailController.text.invalidEmailReason;
      if (emailReason == null) {
        showAlertPopupWithOptions(
          context: context,
          title: const Text('Reset Password'),
          message: [
            const Text(
                "We'll send a link to reset the password to your mail, please confirm your mail again")
          ],
          actions: [
            OutlinedButtonWidget(
                onPressed: () {
                  navPop(context);
                  _sendResetLinkToMail();
                },
                text: 'Confirm'),
          ],
        );
      } else {
        showToast(context, 'Please enter a valid mail to send the reset link',
            info: true);
      }
    }
  }

  _sendResetLinkToMail() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final networkProvider = Provider.of<ConnectivityProvider>(context,listen: false);
    if(networkProvider.isConnected){
      final requestReset =
      await loginProvider.resetPassword(emailController.text);


      if (requestReset == true && mounted) {
        showToast(
          context,
          "We've sent you an email to reset the password, please check your inbox",
          success: true,
        );
      }else if (requestReset.runtimeType.toString().toLowerCase() == 'string' && mounted) {

        showToast(context, requestReset, failure: true);
      }
    }else{
      showToast(context, 'Please connect any network to reset the password', info: true);
    }
  }
}
