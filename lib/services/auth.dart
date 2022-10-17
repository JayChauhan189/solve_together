import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthBase {
  User? get currentUser;
  Stream<User?> authStateChanges();
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> signUpWithEmailAndPassword(String email, String password,String username,String clg,String passyear,String accounttype);
  Future<void> signOut();
}

class Auth implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    var errorMessage;

    try {
      final userCredential = await _firebaseAuth.signInWithCredential(
        EmailAuthProvider.credential(email: email, password: password),
      );
      return userCredential.user;
    }on FirebaseAuthException catch (error) {
      print(error.code);
      var e = error.code.toUpperCase();
      switch (e) {
        case "INVALID-EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "WRONG-PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "USER-NOT-FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "USER-DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "TOO-MANY-REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "OPERATION-NOT-ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      // return errorMessage;
    }
  }
  @override
  Future<User?> signUpWithEmailAndPassword(String email, String password, String username,String clg,String passyear,String accounttype) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    // Save Name to the Firestore
    await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).set({
      'username': username,
      "college": clg,
      "passyear": passyear,
      "accounttype": accounttype
    });
    return userCredential.user;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }


}