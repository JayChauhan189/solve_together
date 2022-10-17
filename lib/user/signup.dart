import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solve_together/services/auth.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController clgController = TextEditingController();
  final TextEditingController passingYearController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  String AccountType = "user";
  bool _validate = false;
  final _auth = FirebaseAuth.instance;
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

    String? validateUsername(String value) {
      value = value.trim();
      if (value.isEmpty) {
        return 'Username is required';
      } else {
        return null;
      }
    }

    String? validateClg(String value) {
      value = value.trim();
      if (value.isEmpty) {
        return 'Username is required';
      } else {
        return null;
      }
    }

    String? validatePassingYear(String value) {
      value = value.trim();
      if (value.isEmpty) {
        return 'Username is required';
      } else {
        return null;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Form(
                key: _formKey,
                autovalidateMode: _validate
                    ? AutovalidateMode.always
                    : AutovalidateMode.onUserInteraction,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        autofocus: false,
                        controller: usernameController,
                        keyboardType: TextInputType.text,
                        validator: (value) => validateUsername(value!),
                        onSaved: (value) {
                          usernameController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 4, bottom: 4),
                              child: Image.asset("assets/img_user/userName.png",
                                  height: 15),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            hintText: "Enter Username",
                            labelText: "Username"),
                      ),
                      const SizedBox(
                        height: 20.0,
                        width: 20.0,
                      ),
                      TextFormField(
                        autofocus: false,
                        controller: passwordController,
                        obscureText: true,
                        validator: (value) => validatePassword(value!),
                        onSaved: (value) {
                          passwordController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 4, bottom: 4),
                              child: Image.asset("assets/img_user/password.png",
                                  height: 15),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            hintText: "Enter Password",
                            labelText: "Password"),
                      ),
                      const SizedBox(
                        height: 20.0,
                        width: 20.0,
                      ),
                      TextFormField(
                        autofocus: false,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => validateEmail(value!),
                        onSaved: (value) {
                          emailController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 4, bottom: 4),
                              child: Image.asset("assets/img_user/email.png",
                                  height: 15),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            hintText: "Enter Email Id",
                            labelText: "Email Id"),
                      ),
                      const SizedBox(
                        height: 20.0,
                        width: 20.0,
                      ),
                      TextFormField(
                        autofocus: false,
                        validator: (value) => validateClg(value!),
                        controller: clgController,
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          clgController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 4, bottom: 4),
                              child: Image.asset("assets/img_user/college.png",
                                  height: 15),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            hintText: "Enter your College Name",
                            labelText: "College"),
                      ),
                      const SizedBox(
                        height: 20.0,
                        width: 20.0,
                      ),
                      TextFormField(
                        autofocus: false,
                        controller: passingYearController,
                        keyboardType: TextInputType.number,
                        validator: (value) => validatePassingYear(value!),
                        onSaved: (value) {
                          passingYearController.text = value!;
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 4, bottom: 4),
                              child: Image.asset("assets/img_user/year.png",
                                  height: 15),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            hintText: "Enter your Passing Year",
                            labelText: "Passing Year"),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                            child: const Align(
                                alignment: Alignment.centerLeft,

                                child: Text("Select Your Account Type",style: TextStyle(fontSize: 18),)),
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
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                        width: 20.0,
                      ),
                      ElevatedButton.icon(
                          onPressed: () {
                            signUpUser(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                                usernameController.text.trim(),
                                clgController.text.trim(),
                                passingYearController.text.trim());
                            Navigator.pushReplacementNamed(context, "/home");
                          },
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 100,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              primary: Colors.black,
                              onPrimary: Colors.yellow),
                          icon: Image.asset("assets/img_user/registerBtn.png",
                              height: 50, width: 30),
                          label: const Text(
                            "Submit",
                            style: TextStyle(fontSize: 17),
                          ))
                    ]),
              )),
        ),
      ),
    );
  }

  void signUpUser(String email, String password, String username, String clg,
      String passyear) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String emailLocal = emailController.text.trim();
      String passwordLocal = passwordController.text.trim();
      dynamic response = widget.auth
          .signUpWithEmailAndPassword(email, password, username, clg, passyear,AccountType);
      if (response != null) {
        Navigator.pushNamed(context, "/home");
      }
    }
  }
}
