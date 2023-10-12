import 'package:cloud_firestore/cloud_firestore.dart';

class Userr {
  final String? uid;
  final String? name;
  final String? email;
  final String? userImage;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  Userr({
    this.uid,
    this.name,
    this.email,
    this.userImage,
    this.createdAt,
    this.updatedAt,
  });

  Userr.fromFirestore(DocumentSnapshot document)
      : uid = document.id,
        name = document['name'],
        email = document['email'],
        userImage = document['userImage'],
        createdAt = document['createdAt'],
        updatedAt = document['updatedAt'];
}
