import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String desc;
  final String postId;
  final String username;
  final date;
  final String postUrl;
  final String profImage;
  final likes;

  const Post(
      {required String this.uid,
      required String this.desc,
      required String this.username,
      required String this.postUrl,
      required String this.profImage,
      required this.date,
      required String this.postId,
      this.likes});

  Map<String, dynamic> toJson() => {
        "username": username,
        "desc": desc,
        "uid": uid,
        "postUrl": postUrl,
        "profImage": profImage,
        "postId": postId,
        "date": date,
        "likes": likes
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapShot = (snap.data() as Map<String, dynamic>);

    return Post(
        username: snapShot['username'],
        uid: snapShot['uid'],
        desc: snapShot['desc'],
        postUrl: snapShot['postUrl'],
        date: snapShot['date'],
        profImage: snapShot['profImage'],
        postId: snapShot['postId'],
        likes: snapShot['likes']);
  }
}
