import 'package:cloud_firestore/cloud_firestore.dart';
class UpdateProfileService{
  UpdateProfileService({required this.uid});
  final String uid;

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  Future updateProfile(String username,String college,String passyear) async{
    return await usersCollection.doc(uid).update({
      'username':username,
      'passyear':college,
      'college':passyear,
    });
  }
}