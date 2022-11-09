import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import '../utils/colors.dart';

class commentCard extends StatefulWidget {
  final snap;
  const commentCard({super.key, required this.snap});

  @override
  State<commentCard> createState() => _commentCardState();
}

class _commentCardState extends State<commentCard> {
  bool isLiked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(children: [
        CircleAvatar(
          backgroundImage: NetworkImage(widget.snap['profilePic']),
          radius: 18,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: widget.snap['username'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '  ${widget.snap['desc']}')
                  ])),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        widget.snap['Date'].toDate(),
                      ),
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  )
                ]),
          ),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                isLiked = isLiked ? false : true;
              });
            },
            icon: isLiked
                ? Icon(
                    Icons.favorite,
                    size: 16,
                    color: Colors.red,
                  )
                : Icon(
                    Icons.favorite,
                    size: 16,
                  )),
      ]),
    );
  }
}
