import 'dart:developer';

import 'package:betagram/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> SignUpAuth({
    required String email,
    required String username,
    required String password,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Sorry, Error occured";
    try {
      if (email.isNotEmpty ||
          username.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty ||
          file != Null) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // store user

        String photo_url = await StorageMethods()
            .uploadImageToStorage('profilePic', file, false);
        model.User user = model.User(
            uid: cred.user!.uid,
            bio: bio,
            email: email,
            username: username,
            PhotoUrl: photo_url,
            followers: [],
            following: []);
        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );

        res = "success";

        // await _firestore.collection('users').add({ // uid is diff here
        //   'email':email,
        //   'username':username,
        //   'uid':cred.user!.uid,
        //   'bio':bio,
        //   'followers':[],
        //   'following':[]
        // });
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> LoginAuth({
    required String email,
    required String password,
  }) async {
    String res = "Sorry, Error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    // print("llllllll");
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    // print((snap.data() as Map<String, dynamic>));
    return model.User.fromSnap(snap);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
