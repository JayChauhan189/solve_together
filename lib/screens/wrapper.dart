import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solve_together/organization/HomePage.dart';
import 'package:solve_together/services/auth.dart';
import 'package:solve_together/user/login.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {



  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User?>(
      stream: widget.auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            // print(user);
            // print("Not logged in");

            return LoginUser(auth: widget.auth);
          }else {
            return HomePage(auth: Auth(),);
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}