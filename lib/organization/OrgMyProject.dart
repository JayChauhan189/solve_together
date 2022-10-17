import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:solve_together/services/auth.dart';

class OrgMyProjects extends StatefulWidget {
  const OrgMyProjects({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  State<OrgMyProjects> createState() => _OrgMyProjectsState();
}

class _OrgMyProjectsState extends State<OrgMyProjects> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Projects"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/org_postproject");
            },
            icon: Icon(Icons.add),
            iconSize: 30,
          ),
        ],
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

              final DocumentSnapshot document =
                  snapshot.data as DocumentSnapshot;

                final Map<String, dynamic> documentData =
                document.data() as Map<String, dynamic>;

                List checkingForEmptyList = documentData["project"];
                if (documentData["project"] == null ||
                    checkingForEmptyList.isEmpty) {
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


              final List<Map<String, dynamic>> itemDetailList =
                  (documentData['project'] as List)
                      .map((itemDetail) => itemDetail as Map<String, dynamic>)
                      .toList();
              final List<Map<String, dynamic>> modifiedlist = [];
              var i=0;
              List index1 = [];
              for (var name in itemDetailList)
              {
                String checkstatus = name['org_name'];
                if(checkstatus==widget.auth.currentUser!.uid) {
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

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 1.0),
                    child: ListTile(
                      contentPadding:
                      const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                      tileColor: Colors.yellow[200],
                      shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      leading:
                      Image(image: AssetImage("assets/img_user/org.png")),
                      title: Text(
                        project_title,
                        textScaleFactor: 1.3,
                      ),
                      subtitle: Text(date),
                      onTap: () {

                        setState(() {
                          // print(project_title);
                          Navigator.pushNamed(context, "/org_updatemyproject",arguments: {'itemDetail':itemDetail,'index':index1[index]});
                        });
                      },
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
