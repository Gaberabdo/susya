import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/user_page.dart';

class Authentication {
  static User? currentUser;

  static getCurrentUser() {
    return currentUser = FirebaseAuth.instance.currentUser;
  }

  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  // Sign Up with Email and Password
  static Future<void> signUp(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      currentUser = userCredential.user;
      Get.off(() => UserInfoScreen(user: currentUser!));
      Get.snackbar('Success', 'Account created successfully!');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message!);
    }
  }

  // Login with Email and Password
  static Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      currentUser = userCredential.user;
      Get.off(() => UserInfoScreen(user: currentUser!));

      Get.snackbar('Success', 'Logged in successfully!');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message!);
    }
  }

  // Sign Out
  static Future<void> signOut({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.snackbar('Success', 'Logged out successfully!');
    } catch (e) {
      Get.snackbar(
        'Oooppss!',
        'Error signing out. Try again.',
      );
    }
    currentUser = null;
  }
}
