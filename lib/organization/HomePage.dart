import 'package:flutter/material.dart';
import 'package:solve_together/services/auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.auth,
  }) : super(key: key);
  final AuthBase auth;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
        width: 250,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.amber),
                child: Image.asset(
                  "assets/icons/progress.png",
                ),
              ),
              ListTile(
                title: Text("My Projects"),
                onTap: () {
                  Navigator.pushNamed(context, "/display_myprojects");
                },
              ),
              ListTile(
                title: Text("Ongoing Projects"),
                onTap: () {
                  Navigator.pushNamed(context, "/display_ongoingprojects");
                },
              ),
              ListTile(
                title: Text("Completed Projects"),
                onTap: () {
                  Navigator.pushNamed(context, "/display_completedprojects");
                },
              ),
              // ListTile(
              //   title: Text("Issued Certificates"),
              //   onTap: () {
              //     Navigator.pushNamed(context, "/display_issuedcertificates");
              //   },
              // ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/org_update_profile");
              },
              icon: Image.asset("assets/icons/account.png"))
        ],
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
                return Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 250.0, 10.0, 10.0),
                  child: SpinKitFadingCube(
                    color: Colors.blue,
                    size: 90.0,
                  ),
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
              final List<Map<String, dynamic>> modifiedlist = [];
              var i = 0;
              List index1 = [];
              for (var name in itemDetailList) {
                String checkstatus = name['org_name'];
                String status = name['status'];
                if (status == "posted") {
                  modifiedlist.add(name);
                  index1.add(i);
                }
                i++;
              }
              index1 = index1.reversed.toList();
              var itemDetailsListReversed = modifiedlist.reversed.toList();
              if(itemDetailsListReversed.isEmpty)
              {
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
                          "No Projects Available ..",
                          textScaleFactor: 1.4,
                          style: TextStyle(color: Colors.blue, letterSpacing: 2.0),
                        ),
                      ),
                    ],
                  ),
                );
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
                      subtitle: Text(date),
                      onTap: () {
                        setState(() {

                          Navigator.pushNamed(context, "/org_projectdetails",
                              arguments: {"projectDetail": itemDetail,'index':index1[index]});
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
