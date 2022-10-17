import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PostProjectService {


  PostProjectService({required this.uid});
  final String uid;
  final CollectionReference projectCollection =
      FirebaseFirestore.instance.collection('project');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateProject(
      String uid,
      String projectTitle,
      String projectDescription,
      String projectPreferences,
      int indexToPass) async {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    print(indexToPass);
    return await FirebaseFirestore.instance
        .collection('project')
        .doc("global")
        .get()
        .then((snapshot) {
      final retrievedDateTime =
      snapshot.data()!['project'][indexToPass]['date'];
      final retrievedOrgName =
      snapshot.data()!['project'][indexToPass]['org_name'];
      final retrievedDescription =
      snapshot.data()!['project'][indexToPass]['project_description'];
      final retrievedPreferences =
      snapshot.data()!['project'][indexToPass]['project_preferences'];
      final retrievedTitle =
      snapshot.data()!['project'][indexToPass]['project_title'];
      final retrievedStatus =
      snapshot.data()!['project'][indexToPass]['status'];
      print(retrievedPreferences + retrievedTitle + retrievedDescription);
      List updatedListToBeStored = [], listToBeDeleted = [];
      updatedListToBeStored.add({
        "org_name": retrievedOrgName,
        "project_title": projectTitle,
        "project_description": projectDescription,
        "date": formattedDate,
        "project_preferences": projectPreferences,
        "status": retrievedStatus,
      });
      listToBeDeleted.add({
        "org_name": retrievedOrgName,
        "project_title": retrievedTitle,
        "project_description": retrievedDescription,
        "date": retrievedDateTime,
        "project_preferences": retrievedPreferences,
        "status": retrievedStatus,
      });
      FirebaseFirestore.instance.collection('project').doc('global').update({
        'project': FieldValue.arrayUnion(updatedListToBeStored),
      });

      FirebaseFirestore.instance.collection('project').doc('global').update({
        'project': FieldValue.arrayRemove(listToBeDeleted),
      });
    });
  }

  Future deleteProject(
      String uid,
      String projectTitle,
      String projectDescription,
      String projectPreferences,
      int indexToPass,String projectDate,String projectStatus) async {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    print(indexToPass);
    return await FirebaseFirestore.instance
        .collection('project')
        .doc("global")
        .get()
        .then((snapshot) {
      List listToBeDeleted = [];
      listToBeDeleted.add({
        "org_name": uid,
        "project_title": projectTitle,
        "project_description": projectDescription,
        "date": projectDate,
        "project_preferences": projectPreferences,
        "status": projectStatus,
      });

      FirebaseFirestore.instance.collection('project').doc('global').update({
        'project': FieldValue.arrayRemove(listToBeDeleted),
      });
    });
  }

  Future insertDummyProjectData() async {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return await projectCollection.doc('global').set({
      'project': FieldValue.arrayUnion([
        {
          'project_title': "Project Title",
          'project_preferences': "Project Preference",
          'project_description': "Project Description",
          'date': formattedDate,
          'status': "dummy",
          'org_name': "organisation1",
        }
      ]),
    });
    // return await projectCollection.doc(uid).set({
    //   'project': FieldValue.arrayUnion([
    //     {
    //       'project_title': "Project Title",
    //       'project_preferences': "Project Preference",
    //       'project_description': "Project Description",
    //       'date': formattedDate,
    //       'status': "dummy",
    //     }
    //   ]),
    // });
  }



  Future postProject(
      String ptitle, String ppreferences, String pdescription) async {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    // insertDummyProjectData();
    List newListToBeStored = [];
    List newListToBeStoredInGlobal = [];
    newListToBeStored.add({
      "project_title": ptitle,
      "project_preferences": ppreferences,
      "project_description": pdescription,
      'date': formattedDate,
      'status': "posted",
    });
    // await projectCollection.doc(uid).update({
    //   'project':FieldValue.arrayUnion(newListToBeStored),
    // });
    // await userCollection.doc(uid).get().then((value) => print(value['username']));
    newListToBeStoredInGlobal.add({
      "org_name": uid,
      "project_title": ptitle,
      "project_preferences": ppreferences,
      "project_description": pdescription,
      'date': formattedDate,
      'status': "posted",
    });
    return await projectCollection.doc('global').update({
      'project': FieldValue.arrayUnion(newListToBeStoredInGlobal),
    });
  }
}
