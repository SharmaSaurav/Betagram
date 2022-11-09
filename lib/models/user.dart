import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String PhotoUrl;
  final String email;
  final String username;
  final String bio;
  final List followers;
  final List following;

  const User({
    required String this.uid,
    required String this.email,
    required String this.username,
    required List this.followers,
    required List this.following,
    required String this.bio,
    required String this.PhotoUrl,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "uid": uid,
        "PhotoUrl": PhotoUrl,
        "following": following,
        "followers": followers,
        "bio": bio,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapShot = (snap.data() as Map<String, dynamic>);

    return User(
      username: snapShot['username'],
      uid: snapShot['uid'],
      email: snapShot['email'],
      PhotoUrl: snapShot['PhotoUrl'],
      bio: snapShot['bio'],
      followers: snapShot['followers'],
      following: snapShot['following'],
    );
  }
}
