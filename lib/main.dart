import 'package:chatify_with_firebase/helper/helper_function.dart';
import 'package:chatify_with_firebase/pages/home_page.dart';
import 'package:chatify_with_firebase/pages/auth/login_page.dart';
import 'package:chatify_with_firebase/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSignedIn = false;
  @override
  void initState() {
    getUserLoggedInStatus();
    super.initState();
  }

  getUserLoggedInStatus() async {
    HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        isSignedIn = value;
        setState(() {});
        debugPrint('this is signed in $isSignedIn');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Constants.primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isSignedIn ? const HomePage() : const LoginPage(),
    );
  }
}
