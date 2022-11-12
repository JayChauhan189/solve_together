import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solve_together/organization/HomePage.dart';
import 'package:solve_together/services/auth.dart';
import 'package:solve_together/user/homepage.dart';
import 'package:solve_together/user/login.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  dynamic status;
  @override
  void initState() {
    super.initState();
    checkNavigation();
  }
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User?>(
      stream: widget.auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return LoginUser(auth: widget.auth);
          } else {
            checkNavigation();
            print(status);
            if(status=="UserHome")
              return HomePageUser(auth: Auth());
            return HomePage(auth: Auth());
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<void> checkNavigation() async {
    var isanOrgOrUser = "";
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.auth.currentUser!.uid)
        .get()
        .then((value) => {isanOrgOrUser = value.data()!["accounttype"]});
    if (isanOrgOrUser == "user") {
      status = "UserHome";
      return;
    }
    status = "OrgHome";
    return;
  }
}
