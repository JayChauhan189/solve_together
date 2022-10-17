import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solve_together/services/auth.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _validate = false;
  String AccountType = "user";
  @override
  Widget build(BuildContext context) {
    String? validateEmail(String value) {
      value = value.trim();
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern);
      if (value.isEmpty) {
        return 'Email is required';
      } else if (!regExp.hasMatch(value)) {
        return 'Invalid email';
      } else {
        return null;
      }
    }

    String? validatePassword(String value) {
      if (value.isEmpty) {
        return 'Password is required...';
      } else if (value.length < 6) {
        return 'Password must be at least 6 characters';
      }
      return null;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pass the baton"),
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Image
                Container(
                  padding: EdgeInsets.zero,
                  child: const Image(
                    image: AssetImage("assets/img_user/login.png"),
                  ),
                ),
                Form(
                  key: _formKey,
                  autovalidateMode: _validate
                      ? AutovalidateMode.always
                      : AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: <Widget>[
                      //For email
                      TextFormField(
                        autofocus: false,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => validateEmail(value!),
                        onSaved: (value) {
                          emailController.text = value!;
                        },
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 4, bottom: 4),
                              child: Image.asset(
                                "assets/img_user/email.png",
                                height: 15,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "Enter Your Email",
                            labelText: "Email"),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(width: 20.0, height: 30.0),
                      //For password
                      TextFormField(
                        obscureText: true,
                        autofocus: false,
                        validator: (value) => validatePassword(value!),
                        onSaved: (value) {
                          passwordController.text = value!;
                        },
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 4, bottom: 4),
                              child: Image.asset(
                                "assets/img_user/password.png",
                                height: 15,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "Enter Your Password",
                            labelText: "Password"),
                        textInputAction: TextInputAction.done,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                        child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Select Your Account Type",
                              style: TextStyle(fontSize: 18),
                            )),
                      ),
                      RadioListTile(
                        activeColor: Colors.green,
                        title: Text("Organization"),
                        value: "organization",
                        groupValue: AccountType,
                        onChanged: (value) {
                          setState(() {
                            AccountType = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        activeColor: Colors.green,
                        title: Text("User"),
                        value: "user",
                        groupValue: AccountType,
                        onChanged: (value) {
                          setState(() {
                            AccountType = value.toString();
                          });
                        },
                      ),
                      const SizedBox(width: 20.0, height: 30.0),
                      ElevatedButton.icon(
                        onPressed: () {
                          logInUser(emailController.text.trim(),
                              passwordController.text.trim());
                          // Navigator.pushNamed(context, "/userHome");
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 125,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            primary: Colors.black,
                            onPrimary: Colors.yellow),
                        icon: Image.asset("assets/img_user/loginBtn.png",
                            height: 50, width: 30),
                        label: const Text(
                          "Login",
                          style: TextStyle(fontSize: 17),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                // Extra Navigation
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: const Divider(
                          color: Colors.black,
                          height: 36,
                        ),
                      ),
                    ),
                    const Text(
                      "OR",
                      style: TextStyle(fontSize: 20),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                        child: const Divider(
                          color: Colors.black,
                          height: 36,
                        ),
                      ),
                    ),
                  ],
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, "/register");
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 90,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      primary: Colors.black,
                      onPrimary: Colors.yellow),
                  icon: Image.asset("assets/img_user/signup.png",
                      height: 50, width: 30),
                  label: const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void logInUser(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String emailLocal = emailController.text.trim();
      String passwordLocal = passwordController.text.trim();
      dynamic response = widget.auth.signInWithEmailAndPassword(emailLocal, passwordLocal);

      if(response=="User with this email doesn't exist.") {

      }
      else{
        Navigator.pushNamed(context, "/home");
      }
    }
  }
}
