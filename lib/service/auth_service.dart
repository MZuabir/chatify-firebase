import 'package:chatify_with_firebase/helper/helper_function.dart';
import 'package:chatify_with_firebase/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//login
  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());

      return e;
    }
  }

//register
  Future registerUserWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        //call database service to update user data
        await DatabaseService(uid: user.uid)
            .savingUserDataToFireStore(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());

      return e;
    }
  }

//signout
  Future signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      await preferences.remove(HelperFunctions.userNameKey);
      await preferences.remove(HelperFunctions.userEmailKey);
      await preferences.remove(HelperFunctions.userLoggedInKey);
      await firebaseAuth.signOut();
    } catch (e) {}
  }
}
