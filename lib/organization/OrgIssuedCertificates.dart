import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';

class OrgIssuedCertificates extends StatefulWidget {
  const OrgIssuedCertificates({Key? key,required this.auth}) : super(key: key);
  final AuthBase auth;
  @override
  State<OrgIssuedCertificates> createState() => _OrgIssuedCertificatesState();
}

class _OrgIssuedCertificatesState extends State<OrgIssuedCertificates> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Issued Certificates"),
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('project')
                .doc(widget.auth.currentUser!.uid)
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
              var i=0;
              final List<Map<String, dynamic>> modifiedlist = [];
              for (var name in itemDetailList)
              {
                String checkstatus = name['status'];
                if(checkstatus=="ongoing") {
                  modifiedlist.add(name);
                }
                i++;
              }
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

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 5.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.lightGreenAccent,
                    child: InkWell(
                      splashColor: Colors.yellow,
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 400,
                          height: 100,
                          child: Text(project_title),
                        ),
                      ),
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
