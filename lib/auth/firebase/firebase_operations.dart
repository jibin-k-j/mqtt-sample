import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class FirebaseOperations {
  /// LOGIN METHOD
  static Future<dynamic> loginUser({required String email, required String password}) async {
    final auth = FirebaseAuth.instance;
    try {
      final credential = await auth.signInWithEmailAndPassword(email: email, password: password);
      final userData = await getUserDetails(credential.user!.uid);
      if (userData != null) {
        return userData;
      } else {
        return 'er:/Unable to retrieve user data. Try again!';
      }
    } on FirebaseAuthException catch (e) {
      String error = 'er:/Something went wrong!';
      switch (e.code.toString().toLowerCase()) {
        case 'invalid-email':
          error = 'er:/Enter correct email address';
          break;
        case 'user-disabled':
          error = 'er:/User has been disabled';
          break;
        case 'user-not-found':
          error = 'er:/No user associated with this email';
          break;
        case 'wrong-password':
          error = 'er:/Incorrect password. Try again!';
          break;
      }
      return error;
    }
  }

  //USER SIGNUP METHOD
  static Future<dynamic> createUser({required String email, required String password, required String name}) async {
    final auth = FirebaseAuth.instance;
    try {
      final credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        await credential.user!.updateDisplayName(name);
        final result = await addUserData(uid: credential.user!.uid, name: name, email: email);
        // await credential.user!.sendEmailVerification();

        if (result) {
          return credential;
        } else {
          return 'er:/Unable to add user data. Try again!';
        }
      }
    } on FirebaseAuthException catch (e) {
      String error = 'er:/Something went wrong!';
      switch (e.code.toString().toLowerCase()) {
        case 'invalid-email':
          error = 'er:/Enter correct email address';
          break;
        case 'email-already-in-use':
          error = 'er:/Account already exist. Please login';
          break;
        case 'weak-password':
          error = 'er:/Please use a strong password';
          break;
        case 'operation-not-allowed':
          error = 'er:/Account creation not allowed right now.';
          break;
      }
      return error;
    }
  }

  //RESET PASSWORD
  static Future<bool> resetPassword({required String email}) async {
    bool status = true;
    final auth = FirebaseAuth.instance;
    await auth.sendPasswordResetEmail(email: email).catchError((e) {
      log('error in pw reset $e');
      status = false;
    });
    return status;
  }

  /// ADDING USER DATA INTO FIRESTORE
  static Future<bool> addUserData({required String uid, required String name, required String email}) async {
    bool status = true;
    final ref = FirebaseFirestore.instance.collection('users');
    try {
      await ref.doc(uid).set({
        'name': name,
        'email': email,
        'photoUrl': '',
        'createdOn': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      status = false;
      log('Error from creating user in firestore $e');
    }
    return status;
  }

  /// GETTING USER DATA
  static Future<UserModel?> getUserDetails(String userId) async {
    final ref = FirebaseFirestore.instance;
    UserModel? userData;
    try {
      //GETTING USER INFO
      await ref.collection('users').doc(userId).get().then((value) {
        if (value.exists) {
          userData = UserModel(
              uid: userId, email: value.get('email'), name: value.get('name'), photoURl: value.get('photoUrl'));
        }
      });
    } catch (e) {
      log('Error from fetching user data $e');
    }
    return userData;
  }
}
