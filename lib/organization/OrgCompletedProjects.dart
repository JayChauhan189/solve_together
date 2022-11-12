import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:solve_together/services/auth.dart';
class OrgCompletedProjects extends StatefulWidget {
  const OrgCompletedProjects({Key? key,required this.auth}) : super(key: key);
final AuthBase auth;
  @override
  State<OrgCompletedProjects> createState() => _OrgCompletedProjectsState();
}

class _OrgCompletedProjectsState extends State<OrgCompletedProjects> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Completed Projects"),
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
                          "Project List is Empty !",
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

              final List<Map<String, dynamic>> modifiedlist = [];
              var i=0;
              for (var name in itemDetailList)
              {
                String checkstatus = name['org_name'];
                String status = name['status'];
                if(checkstatus==widget.auth.currentUser!.uid && status=="completed") {
                  modifiedlist.add(name);
                }
                i++;
              }
              var itemDetailsListReversed = modifiedlist.reversed.toList();
              dynamic orgname=" ";
              getOrgNameFromDb(String orgnamearg) async
              {
                // print(orgnamearg);
                final CollectionReference userCollection =
                FirebaseFirestore.instance.collection('users');
                await userCollection.doc(orgnamearg).get().then((value) => {orgname=value['username']});
                // print(orgname);
              }

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
                      subtitle:
                      // getOrgNameFromDb(widget.auth.currentUser!.uid);
                      Text(date),
                      onTap: () {
                        setState(() {
                          // print(project_title);
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
