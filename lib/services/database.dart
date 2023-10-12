import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_crud/models/post.dart';
import 'package:flutter_crud/models/user.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference collection =
      FirebaseFirestore.instance.collection("users");

  // Post list from snapshot

  List<Post> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Post.fromFirestore(doc);
    }).toList();
  }

  // get all posts
  Stream<List<Post>> get posts {
    return FirebaseFirestore.instance
        .collectionGroup('posts')
        .snapshots()
        .map(_postListFromSnapshot);
  }

  // get individual user posts
  Stream<List<Post>> get individualPosts {
    return collection
        .doc(uid)
        .collection('posts')
        .snapshots()
        .map(_postListFromSnapshot);
  }

  Future registerUser(String uid, String name, String email) async {
    try {
      return await collection.doc(uid).set({
        "name": name,
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('An error occurred!! : $e');
    }
  }

  Future getProfile(String uid) async {
    try {
      DocumentSnapshot result =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (result.exists) {
        return Userr.fromFirestore(result);
      }
    } catch (e) {
      print('An error occurred!! : $e');
    }
  }

  Future editProfile(String uid, String name, String userImage) async {
    try {
      return await collection.doc(uid).set({
        "name": name,
        "userImage": userImage,
        "updatedAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('An error occurred!! : $e');
    }
  }

  Future createPost(String uid, String title, String content) async {
    try {
      await collection.doc(uid).collection('posts').doc().set({
        "title": title,
        "content": content,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });
      return uid;
    } catch (e) {
      print('An error occurred!! : $e');
    }
  }

  Future deletePost(
    String id,
  ) async {
    try {
      return await collection.doc(uid).collection('posts').doc(id).delete();
    } catch (e) {
      print('An error occurred!! : $e');
      return null;
    }
  }

  Future editPost(String id, String title, String content) async {
    try {
      await collection.doc(uid).collection('posts').doc(id).set({
        "title": title,
        "content": content,
        "updatedAt": FieldValue.serverTimestamp(),
      });
      return uid;
    } catch (e) {
      print('An error occurred!! : $e');
      return null;
    }
  }
}
