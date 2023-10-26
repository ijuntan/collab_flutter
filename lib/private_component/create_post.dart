import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/post.dart';
import '../services/storage.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  String? uid;
  XFile? pickedImage;

  Future onImageButtonPressed() async {
    try {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        pickedImage = image;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    storage.readStorage("_id").then((value) {
      setState(() {
        uid = value.toString();
      });
    });
  }

  void addPost(context) {
    // Add post to the database
    Object post = {
      'name': titleController.text,
      'content': contentController.text,
      'like': 0,
      'dislike': 0,
      'tag': 'normal',
      'image': '',
      'createdBy': uid,
    };
    if (pickedImage != null)
      PostService().addPost(post, File(pickedImage!.path));
    else
      PostService().addPost(post, null);

    // Clear the post field
    titleController.clear();
    contentController.clear();

    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context, false),
          ),
          title: const Text('Create Post'),
        ),
        body: Column(
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              decoration: const InputDecoration(
                  hintText: 'Title',
                  hintStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10)),
            ),

            Flexible(
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: contentController,
                decoration: const InputDecoration(
                    hintText: 'What do you want to talk about?',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10)),
              ),
            ),

            //Image
            if (pickedImage != null)
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      child:
                          Image.file(File(pickedImage!.path), fit: BoxFit.fill),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                          ),
                          onPressed: () => setState(() => pickedImage = null),
                          child: Icon(Icons.delete, color: Colors.white)),
                    ),
                  ],
                ),
              ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: [
              FloatingActionButton.extended(
                  label: const Text('Image'),
                  heroTag: "btn1",
                  onPressed: () => onImageButtonPressed(),
                  icon: const Icon(Icons.image)),
              const Spacer(),
              FloatingActionButton(
                heroTag: "btn2",
                onPressed: () => addPost(context),
                child: const Icon(Icons.send),
              ),
            ],
          ),
        ));
  }
}
