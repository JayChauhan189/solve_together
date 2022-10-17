import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solve_together/services/auth.dart';
import 'package:solve_together/services/project.dart';

class OrgPostProject extends StatefulWidget {
  const OrgPostProject({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;
  @override
  State<OrgPostProject> createState() => _OrgPostProjectState();
}

class _OrgPostProjectState extends State<OrgPostProject> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController projectTitleController = TextEditingController();
  final TextEditingController projectDescriptionController =
      TextEditingController();
  final TextEditingController projectPreferencesController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    String? validateField(String value, String field) {
      value = value.trim();
      if (value.isEmpty) {
        return (field + ' is required...');
      } else {
        return null;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Details"),
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: _validate
              ? AutovalidateMode.always
              : AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/icons/project.png",
                height: 150,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "New Project Details:",
                style: TextStyle(fontSize: 25),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextFormField(
                  autofocus: false,
                  controller: projectTitleController,
                  validator: (value) => validateField(value!, "Project Title"),
                  onSaved: (value) => {projectTitleController.text = value!},
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    hintText: "Enter Project Title:",
                    labelText: "Project Title",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 4, bottom: 4),
                      child: Image.asset("assets/icons/projecttitle.png",
                          height: 15),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextFormField(
                  autofocus: false,
                  controller: projectDescriptionController,
                  validator: (value) =>
                      validateField(value!, "Project Description"),
                  onSaved: (value) =>
                      {projectDescriptionController.text = value!},
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      hintText: "Enter Project Description:",
                      labelText: "Project Description",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 4, bottom: 4),
                        child: Image.asset("assets/icons/description.png",
                            height: 15),
                      )),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextFormField(
                  autofocus: false,
                  controller: projectPreferencesController,
                  validator: (value) =>
                      validateField(value!, "Project Preferences"),
                  onSaved: (value) =>
                      {projectPreferencesController.text = value!},
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      hintText: "Enter Project Preferences:",
                      labelText: "Project Preferences",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 4, bottom: 4),
                        child: Image.asset("assets/icons/preferences.png",
                            height: 15),
                      )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async{
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    await PostProjectService(uid: widget.auth.currentUser!.uid).postProject(
                        projectTitleController.text.trim(),
                        projectDescriptionController.text.trim(),
                        projectPreferencesController.text.trim());
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.amber,
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                child: const Text(
                  "Post Project",
                  style: TextStyle(color: Colors.black87),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
