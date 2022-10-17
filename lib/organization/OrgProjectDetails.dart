import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:solve_together/services/auth.dart';

class OrgProjectsDetails extends StatefulWidget {
  const OrgProjectsDetails({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;
  @override
  State<OrgProjectsDetails> createState() => _OrgProjectsDetails();

}

class _OrgProjectsDetails extends State<OrgProjectsDetails> {
  var orgName;

  Future getOrgName(var arg1) async {
    final arg = arg1['projectDetail'];
    final orgid = arg["org_name"];

    await FirebaseFirestore.instance
        .collection("users")
        .doc(orgid)
        .get()
        .then((value) {
      setState(() {
        orgName = value.data()!["username"];

      });
      // print("Hello"+orgName);
      //orgDetail = value.data()!["username"];
    });
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final arg1 = ModalRoute
          .of(context)!
          .settings
          .arguments as Map;
      getOrgName(arg1);
    });
  }

  Widget build(BuildContext context) {
    var orgEmail=widget.auth.currentUser!.email;
    final arg1 = ModalRoute.of(context)!.settings.arguments as Map;
    final arg = arg1['projectDetail'];
    final orgid = arg["org_name"];

    // print(orgid);
    String orgDetail = "";
    if(orgName!=null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Project Details"),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body:
        SingleChildScrollView(

          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text(
                      arg["project_title"],
                      textScaleFactor: 1.6,
                    ),
                    subtitle: Text(
                      arg["project_description"],
                      textScaleFactor: 1.3,
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  ListTile(
                    title: Text(
                      orgName,
                      textScaleFactor: 1.6,
                    ),
                    subtitle: Text(
                      orgEmail!,
                      textScaleFactor: 1.3,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Preferences",
                      textScaleFactor: 1.6,
                    ),
                    subtitle: Text(arg["project_preferences"]),
                  ),
                  const SizedBox(
                    width: 30,
                    height: 10,
                  ),
                  TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 4, bottom: 4),
                        child: Image.asset(
                          "assets/icons/link.png",
                          height: 15,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: "Link",
                      label: const Text("Enter Solution Link"),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                    height: 10,
                  ),
                  Center(
                    child: ElevatedButton.icon(
                      icon: Image.asset(
                        "assets/icons/rocket.png",
                        height: 30,
                        width: 30,
                      ),
                      label: const Text(
                        "Submit",
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        CircularProgressIndicator(),
        Text(
          "Fetching Data...",
          maxLines: 2,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
