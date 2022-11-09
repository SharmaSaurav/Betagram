import 'package:betagram/screens/Profile_Screen.dart';
import 'package:betagram/screens/add_post.dart';
import 'package:betagram/screens/feed.dart';
import 'package:betagram/screens/search_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const webScreenSize = 600;

List<Widget> navBarWidgets = [
  const FeedScreen(),
  const SearchScreen(),
  const add_post(),
  const Center(child: Text('Itna ni aata mujhe')),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
