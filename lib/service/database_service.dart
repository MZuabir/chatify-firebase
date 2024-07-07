// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({
    this.uid,
  });

  //refrece for our collection

  final CollectionReference userRefrence =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference groupRefrence =
      FirebaseFirestore.instance.collection('groups');

  ///saving user data
  Future savingUserDataToFireStore(String fullName, String email) async {
    return await userRefrence.doc(uid).set({
      'fullName': fullName,
      'email': email,
      'groups': [],
      'profilePic': '',
      'uid': uid,
    });
  }

  //getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userRefrence.where('email', isEqualTo: email).get();
    return snapshot;
  }

  getAllGroupsOfUser() async {
    return userRefrence.doc(uid).snapshots();
  }

  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentRef = await groupRefrence.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': '${id}_$userName',
      'createdAt': Timestamp.now(),
      'members': [],
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': '',
    });

    await groupDocumentRef.update({
      'members': FieldValue.arrayUnion(['${id}_$userName']),
      'groupId': groupDocumentRef.id,
    });

    DocumentReference userDocumentRefr = userRefrence.doc(id);
    userDocumentRefr.update({
      'groups': FieldValue.arrayUnion(['${groupDocumentRef.id}_$groupName'])
    });
  }

  getChats(String groupId) async {
    return groupRefrence
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference ref = groupRefrence.doc(groupId);
    DocumentSnapshot documentSnapshot = await ref.get();
    return documentSnapshot['admin'];
  }

  getGroupMembers(String grouId) {
    return groupRefrence.doc(grouId).snapshots();
  }
}
