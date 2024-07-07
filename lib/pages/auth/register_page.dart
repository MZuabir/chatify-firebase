import 'package:chatify_with_firebase/helper/helper_function.dart';
import 'package:chatify_with_firebase/pages/auth/login_page.dart';
import 'package:chatify_with_firebase/pages/home_page.dart';
import 'package:chatify_with_firebase/service/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../shared/constants.dart';
import '../../widgets/global_button_widget.dart';
import '../../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String fullName = '';
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator(color: Constants.primaryColor),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Chatify',
                            style: TextStyle(
                                color: Constants.primaryColor,
                                fontSize: 40,
                                fontWeight: FontWeight.w700),
                          ),
                          const Text(
                            'Create your account now to chat and explore',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          Image.asset('assets/images/register.png'),
                          TextFormField(
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  return null;
                                } else {
                                  return 'Name cannot be empty';
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  fullName = value;
                                });
                              },
                              decoration: textinputDecoration.copyWith(
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Constants.primaryColor,
                                  ),
                                  label: const Text(
                                    'Full Name',
                                    style: TextStyle(
                                        color: Constants.primaryColor),
                                  ))),
                          const SizedBox(height: 10),
                          TextFormField(
                              validator: (value) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value!)
                                    ? null
                                    : 'Please enter valid mail';
                              },
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                });
                                debugPrint('email $email');
                              },
                              decoration: textinputDecoration.copyWith(
                                  prefixIcon: const Icon(
                                    Icons.email,
                                    color: Constants.primaryColor,
                                  ),
                                  label: const Text(
                                    'Email',
                                    style: TextStyle(
                                        color: Constants.primaryColor),
                                  ))),
                          const SizedBox(height: 10),
                          TextFormField(
                              validator: (value) {
                                if (value!.length < 6) {
                                  return 'Password must be 6 characters';
                                } else {
                                  return null;
                                }
                              },
                              obscureText: true,
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                });
                              },
                              decoration: textinputDecoration.copyWith(
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: Constants.primaryColor,
                                  ),
                                  label: const Text(
                                    'Password',
                                    style: TextStyle(
                                        color: Constants.primaryColor),
                                  ))),
                          const SizedBox(height: 20),
                          GlobalButtonWidget(
                            buttonText: 'Sign Up',
                            onTap: () {
                              register(fullName, email, password);
                            },
                          ),
                          const SizedBox(height: 10),
                          Text.rich(TextSpan(
                              text: 'Already have an account? ',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                              children: [
                                TextSpan(
                                    text: 'Login Now',
                                    style: const TextStyle(
                                        color: Constants.primaryColor,
                                        decoration: TextDecoration.underline,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        gotoNextScreenReplace(
                                            context, const LoginPage());
                                      })
                              ])),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  register(String fullName, String email, String password) async {
    if (formKey.currentState!.validate()) {
      debugPrint('this is email receiving $email');
      setState(() {
        isLoading = true;
      });
      await AuthService()
          .registerUserWithEmailAndPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          setState(() {
            isLoading = false;
          });
          await HelperFunctions().saveUserEmailToSP(email);
          await HelperFunctions().saveUserLoggedInState(true);
          await HelperFunctions().saveUserNameToSP(fullName);
          showToastMessage('Created account successfully');
          // ignore: use_build_context_synchronously
          gotNextScreenRemoveUntill(context, const HomePage());
          //saving user data to share pref
        } else {
          setState(() {
            isLoading = false;
          });
          showToastMessage(value.toString());
        }
      });
    }
  }
}
