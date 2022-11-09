import 'package:betagram/Provider/user_provider.dart';
import 'package:betagram/models/user.dart';
import 'package:betagram/resources/Fire_store_methos.dart';
import 'package:betagram/utils/colors.dart';
import 'package:betagram/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class add_post extends StatefulWidget {
  const add_post({super.key});
  State<add_post> createState() => _add_postState();
}

class _add_postState extends State<add_post> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descController = TextEditingController();
  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FirestoreMethods()
          .uploadPost(_descController.text, _file!, uid, profImage, username);
      setState(() {
        isLoading = false;
      });
      if (res == 'success') {
        showSnackBar('Raven flew away with the post', context);
      } else {
        showSnackBar(res, context);
      }
      clearImage();
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  clearImage() {
    setState(() {
      _file = null;
    });
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
        context: parentContext,
        builder: (BuildContext) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(30),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List image = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = image;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(30),
                child: const Text('Choose a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List image = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = image;
                  });
                },
              ),
            ],
          );
        });
  }

  void dispose() {
    super.dispose();
    _descController.dispose();
  }

  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return _file == null
        ? Center(
            child: IconButton(
            icon: Icon(Icons.upload),
            onPressed: () => _selectImage(context),
          ))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => clearImage(),
              ),
              title: const Text('Send A Raven'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => postImage(
                    userProvider.getUser.uid,
                    userProvider.getUser.username,
                    userProvider.getUser.PhotoUrl,
                  ),
                  child: const Text('Post',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                )
              ],
            ),
            body: Column(children: [
              isLoading
                  ? const LinearProgressIndicator()
                  : const Padding(
                      padding: EdgeInsets.only(top: 0),
                    ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(userProvider.getUser.PhotoUrl),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextField(
                      controller: _descController,
                      decoration: const InputDecoration(
                          hintText: 'Write a racist caption...',
                          border: InputBorder.none),
                      maxLines: 8,
                    ),
                  ),
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: AspectRatio(
                      aspectRatio: 487 / 451,
                      child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: MemoryImage(_file!),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter))),
                    ),
                  ),
                  const Divider(),
                ],
              )
            ]),
          );
  }
}
