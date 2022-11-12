import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solve_together/screens/wrapper.dart';

abstract class AuthBase {
  User? get currentUser;
  Stream<User?> authStateChanges();
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> signUpWithEmailAndPassword(String email, String password,
      String username, String clg, String passyear, String accounttype);
  Future<User?> signUpOrgWithEmailAndPassword(String email, String password,
      String username, String orgdes, String accounttype);
  Future<void> signOut();
}

class Auth implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithCredential(
      EmailAuthProvider.credential(email: email, password: password),
    );
    return userCredential.user;
  }

  @override
  Future<User?> signUpWithEmailAndPassword(String email, String password,
      String username, String clg, String passyear, String accounttype) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    // Save Name to the Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .set({
      'username': username,
      "college": clg,
      "passyear": passyear,
      "accounttype": accounttype
    });
    return userCredential.user;
  }

  @override
  Future<User?> signUpOrgWithEmailAndPassword(String email, String password,
      String username, String orgdes, String accounttype) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    // Save Name to the Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .set({
      'username': username,
      'orgdes':orgdes,
      "accounttype": accounttype
    });
    return userCredential.user;
  }
  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
