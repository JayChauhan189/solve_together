import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:solve_together/services/auth.dart';
import 'package:solve_together/services/profile.dart';

class UserUpdateProfile extends StatefulWidget {
  const UserUpdateProfile({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  State<UserUpdateProfile> createState() => _UserUpdateProfileState();
}

class _UserUpdateProfileState extends State<UserUpdateProfile> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _collegeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passYearController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  bool _isValidTitle = false;

  void loadProfileData() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.auth.currentUser!.uid)
        .get()
        .then((snapshot) {
      _usernameController.text = snapshot.data()!['username'];
      _collegeController.text = snapshot.data()!['college'];
      _passYearController.text = snapshot.data()!['passyear'];
    });
  }

  @override
  void initState() {
    _emailController.text = widget.auth.currentUser!.email.toString();
    loadProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
              onPressed: () {
                widget.auth.signOut();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              child: Image.asset(
                "assets/icons/user_cover.png",
                height: 100,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Profile Settings:",
              style: TextStyle(fontSize: 25),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    hintText: "Update your Username:",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 4, bottom: 4),
                      child:
                      Image.asset("assets/icons/id-card.png", height: 15),
                    ),
                    labelText: "Username"),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                controller: _emailController,
                readOnly: true,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    hintText: "Update your College:",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 4, bottom: 4),
                      child:
                      Image.asset("assets/icons/email.png", height: 15),
                    ),
                    labelText: "Email"),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                controller: _collegeController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    hintText: "Update your College:",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 4, bottom: 4),
                      child: Image.asset("assets/icons/clg.png", height: 15),
                    ),
                    labelText: "College"),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                controller: _passYearController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    hintText: "Update your Passing Year:",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 4, bottom: 4),
                      child:
                      Image.asset("assets/icons/passyear.png", height: 15),
                    ),
                    labelText: "Passing Year"),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                UpdateProfileService _updateProfile = UpdateProfileService(uid: widget.auth.currentUser!.uid,);
                dynamic res = await _updateProfile.updateProfile(
                  _usernameController.text.trim(),
                  _collegeController.text.trim(),
                  _passYearController.text.trim(),
                );
                Navigator.pop(context);
              },
              child: Text(
                "Update Profile",
                style: TextStyle(color: Colors.black87),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.amber,
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
