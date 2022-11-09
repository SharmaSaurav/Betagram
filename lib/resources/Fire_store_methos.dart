import 'package:betagram/models/post.dart';
import 'package:betagram/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> uploadPost(String desc, Uint8List file, String uid,
      String profImage, String username) async {
    String res = "some error";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('post', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        uid: uid,
        desc: desc,
        username: username,
        postUrl: photoUrl,
        profImage: profImage,
        date: DateTime.now(),
        postId: postId,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> LikePost(String postId, String userId, List likes) async {
    try {
      if (likes.contains(userId)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([userId])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([userId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComments(String postId, String text, String uid, String name,
      String photourl) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': photourl,
          'username': name,
          'uid': uid,
          'commentId': commentId,
          'desc': text,
          'Date': DateTime.now()
        });
      } else {
        print('Empty text');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String user_uid, String celeb_uid) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(user_uid).get();

      List following = (snap.data()! as dynamic)['following'];
      if (following.contains(celeb_uid)) {
        await _firestore.collection('users').doc(celeb_uid).update({
          'followers': FieldValue.arrayRemove([user_uid])
        });

        await _firestore.collection('users').doc(user_uid).update({
          'following': FieldValue.arrayRemove([celeb_uid])
        });
      } else {
        await _firestore.collection('users').doc(celeb_uid).update({
          'followers': FieldValue.arrayUnion([user_uid])
        });

        await _firestore.collection('users').doc(user_uid).update({
          'following': FieldValue.arrayUnion([celeb_uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<String> deletePost(String postId) async {
  //   String res = "Some error occurred";
  //   try {
  //     await _firestore.collection('posts').doc(postId).delete();
  //     res = 'success';
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }
}
