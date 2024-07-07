// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatify_with_firebase/helper/helper_function.dart';
import 'package:chatify_with_firebase/pages/auth/register_page.dart';
import 'package:chatify_with_firebase/pages/home_page.dart';
import 'package:chatify_with_firebase/service/auth_service.dart';
import 'package:chatify_with_firebase/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:chatify_with_firebase/shared/constants.dart';
import 'package:chatify_with_firebase/widgets/widgets.dart';

import '../../widgets/global_button_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
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
                      CircularProgressIndicator(color: Constants.primaryColor))
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
                            'Login now to see what they are talking',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          Image.asset('assets/images/login.png'),
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
                            buttonText: 'Sign In',
                            onTap: () {
                              logIn();
                            },
                          ),
                          const SizedBox(height: 10),
                          Text.rich(TextSpan(
                              text: 'Don\'t have an account ',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                              children: [
                                TextSpan(
                                    text: 'Register here',
                                    style: const TextStyle(
                                        color: Constants.primaryColor,
                                        decoration: TextDecoration.underline,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        gotoNextScreen(
                                            context, const RegisterPage());
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

  logIn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      AuthService()
          .loginWithEmailAndPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);

          await HelperFunctions().saveUserEmailToSP(email);
          await HelperFunctions().saveUserLoggedInState(true);
          await HelperFunctions()
              .saveUserNameToSP(snapshot.docs[0]['fullName']);
          // ignore: use_build_context_synchronously
          gotNextScreenRemoveUntill(context, const HomePage());
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
