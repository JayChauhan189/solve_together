import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:solve_together/services/auth.dart';

import '../services/project.dart';

class DisplaySolutionUrl extends StatefulWidget {
  const DisplaySolutionUrl({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;
  @override
  State<DisplaySolutionUrl> createState() => _DisplaySolutionUrlState();
}

class _DisplaySolutionUrlState extends State<DisplaySolutionUrl> {
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final indextopass = arg['indextopass'];
    final indexLocal = int.parse(indextopass);
    return Scaffold(
      appBar: AppBar(
        title: Text("Project Submissions"),
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('project')
                .doc("global")
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
              final DocumentSnapshot document = snapshot.data as DocumentSnapshot;

              final Map<String, dynamic> documentData =
              document.data() as Map<String, dynamic>;
              // print(documentData["project"]);
              List checkingForEmptyList = documentData["project"];
              if (documentData["project"] == null || checkingForEmptyList.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      "No Project Available...",
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    )
                  ],
                );
              }
              final String project_title =
              documentData["project"][indexLocal]["project_title"];
              final String project_description =
              documentData["project"][indexLocal]["project_description"];
              final List<Map<String, dynamic>> itemDetailList =
              (documentData['project'][indexLocal]["solutionurl"] as List)
                  .map((itemDetail) => itemDetail as Map<String, dynamic>)
                  .toList();
              Future<String?> getUserName(int index) async {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(itemDetailList[index]['uid'])
                    .get()
                    .then((value) {
                  print("insider: ${value.data()!['username']}");
                  return value.data()!['username'];
                });
              }
              _buildListTileHere(int index) {

                dynamic submitid = itemDetailList[index]['uid'];
                dynamic submiturl = itemDetailList[index]['url'];


                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 1.0),
                    child:
                    ListTile(
                      contentPadding:
                      const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                      tileColor: Colors.yellow,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      leading:
                      Image(image: AssetImage("assets/img_user/org.png")),
                      title: Text(
                        submitid,
                        textScaleFactor: 1.3,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(submiturl),
                          ElevatedButton.icon(
                              onPressed: () async {
                                await PostProjectService(uid: widget.auth.currentUser!.uid)
                                    .updateProjectStatusToCompleted(
                                    widget.auth.currentUser!.uid,
                                    indexLocal,"ongoing"
                                );
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.check),
                              label: Text("Approve Solution"),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green)),
                        ],
                      ),

                    ),
                  ),
                );
              }

              return Expanded(
                child: ListView.builder(

                  itemCount: itemDetailList.length,
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
