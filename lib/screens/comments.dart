import 'package:betagram/Provider/user_provider.dart';
import 'package:betagram/resources/Fire_store_methos.dart';
import 'package:betagram/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../widgets/comment_card.dart';

class Comments extends StatefulWidget {
  final snap;
  const Comments({super.key, required this.snap});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final TextEditingController commentsController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text('Racist Confrence'),
        centerTitle: false,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.snap['postId'])
              .collection('comments')
              .orderBy('Date', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }
            return ListView.builder(
                itemCount: (snapshot.data! as dynamic).docs.length,
                itemBuilder: (context, index) => commentCard(
                    snap: (snapshot.data! as dynamic).docs[index].data()));
          }),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: EdgeInsets.only(left: 16, right: 8),
          child: Row(children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.PhotoUrl),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: TextField(
                  controller: commentsController,
                  decoration: InputDecoration(
                      hintText: 'Comment with ${user.username}',
                      border: InputBorder.none),
                ),
              ),
            ),
            IconButton(
                onPressed: () async {
                  await FirestoreMethods().postComments(
                      widget.snap['postId'],
                      commentsController.text,
                      user.uid,
                      user.username,
                      user.PhotoUrl);
                  setState(() {
                    commentsController.text = "That's What She Said";
                  });
                },
                icon: Icon(
                  Icons.arrow_circle_right_outlined,
                  color: blueColor,
                )),
          ]),
        ),
      ),
    );
  }
}
