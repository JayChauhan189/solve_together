import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:solve_together/services/auth.dart';
import '../services/project.dart';

class UserRequestedProject extends StatefulWidget {
  const UserRequestedProject({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  State<UserRequestedProject> createState() => _UserRequestedProjectState();
}

class _UserRequestedProjectState extends State<UserRequestedProject> {
  dynamic usernamelocalstore;
  void loadUsername() async{
    await FirebaseFirestore.instance.collection("users").doc(widget.auth.currentUser!.uid).get().then((value) {
      setState((){
        usernamelocalstore = value['username'];
      });
    });
  }
  @override
  void initState() {
    super.initState();
    loadUsername();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Requested Projects"),
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('project')
                .doc('global')
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.data == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    CircularProgressIndicator(),
                    Text(
                      "Fetching Data...",
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    )
                  ],
                );
              }

              final DocumentSnapshot document =
                  snapshot.data as DocumentSnapshot;

              final Map<String, dynamic> documentData =
                  document.data() as Map<String, dynamic>;

              List checkingForEmptyList = documentData["project"];
              if (documentData["project"] == null ||
                  checkingForEmptyList.isEmpty) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(55.0, 10.0, 0.0, 0.0),
                  child: Column(
                    children: [
                      Container(
                        height: 250.0,
                        width: 250.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/icons/errorgif.gif"),
                            fit: BoxFit.fill,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        width: 30,
                      ),
                      Container(
                        child: Text(
                          "No Projects Available..",
                          textScaleFactor: 1.4,
                          style: TextStyle(color: Colors.blue, letterSpacing: 2.0),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final List<Map<String, dynamic>> itemDetailList =
                  (documentData['project'] as List)
                      .map((itemDetail) => itemDetail as Map<String, dynamic>)
                      .toList();

              var i = 0;
              List index1 = [];
              print("pruinted");
              final List<Map<String, dynamic>> modifiedlist = [];
              for (var name in itemDetailList) {
                var flag = 0;
                for (int j = 0; j < name['totalurl']; j++) {
                  if (name['solutionurl'][j]['uid'] ==
                      usernamelocalstore) {
                    flag = 1;
                  }
                }
                String checkstatus = name['status'];
                if (checkstatus == "posted" && flag == 1) {
                  modifiedlist.add(name);
                  index1.add(i);
                }
                i++;
              }
              index1 = index1.reversed.toList();
              var itemDetailsListReversed = modifiedlist.reversed.toList();

              _buildListTileHere(int index) {
                final Map<String, dynamic> itemDetail =
                    itemDetailsListReversed[index];
                final String project_title = itemDetail['project_title'];
                final String date = itemDetail['date'];
                final String project_preference =
                    itemDetail["project_preferences"];
                final String project_description =
                    itemDetail["project_description"];
                final String project_date =
                itemDetail["date"];

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 1.0),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                      tileColor: Colors.yellow,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      leading:
                          Image(image: AssetImage("assets/img_user/org.png")),
                      title: Text(
                        project_title,
                        textScaleFactor: 1.3,
                      ),
                      subtitle: Text(project_date),
                    ),
                  ),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: itemDetailsListReversed.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildListTileHere(index);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
