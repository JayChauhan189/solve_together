import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solve_together/services/auth.dart';
import 'package:solve_together/services/project.dart';

class OrgUpdateMyProject extends StatefulWidget {
  const OrgUpdateMyProject({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;
  @override
  State<OrgUpdateMyProject> createState() => _OrgUpdateMyProjectState();
}

class _OrgUpdateMyProjectState extends State<OrgUpdateMyProject> {
  final _auth = FirebaseAuth.instance;
  dynamic projectDate,projectStatus;
  final TextEditingController projectTitleController = TextEditingController();
  final TextEditingController projectDescriptionController =
      TextEditingController();
  final TextEditingController projectPreferencesController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _validate = false;
  dynamic indextopass = "";
  void loadProjectData() {
    FirebaseFirestore.instance
        .collection("project")
        .doc("global")
        .get()
        .then((value) {
      final arg1 = ModalRoute.of(context)!.settings.arguments as Map;
      final arg = arg1['itemDetail'];

      indextopass = arg1['index'];
      // print(indextopass);
      projectTitleController.text = arg["project_title"];
      projectDescriptionController.text = arg['project_description'];
      projectPreferencesController.text = arg['project_preferences'];
      projectDate = arg["date"];
      projectStatus = arg["status"];
    });
  }

  @override
  void initState() {
    loadProjectData();
    super.initState();
  }

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
        actions: [
          IconButton(
            onPressed: () async{
              await PostProjectService(uid: widget.auth.currentUser!.uid)
                  .deleteProject(
                  widget.auth.currentUser!.uid,
                  projectTitleController.text.trim(),
                  projectDescriptionController.text.trim(),
                  projectPreferencesController.text.trim(),
                  indextopass,
                  projectDate,
                projectStatus
              );
              final snackBar = SnackBar(
                content: const Text('Project Deleted Successfully..')
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pushNamed(context, "/display_myprojects");

            },
            icon: Icon(Icons.delete),
            iconSize: 30,
          ),
        ],
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    await PostProjectService(uid: widget.auth.currentUser!.uid)
                        .updateProject(
                      widget.auth.currentUser!.uid,
                      projectTitleController.text.trim(),
                      projectDescriptionController.text.trim(),
                      projectPreferencesController.text.trim(),
                      indextopass

                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.amber,
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                child: const Text(
                  "Update Project",
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
