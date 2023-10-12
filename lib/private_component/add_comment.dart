import 'package:collab/services/comment.dart';
import 'package:flutter/material.dart';
import 'package:collab/services/storage.dart';

class AddComment extends StatefulWidget {
  const AddComment({super.key});

  @override
  State<AddComment> createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  final _commentFocusNode = FocusNode();
  final commentController = TextEditingController();
  String uid = "";

  @override
  void dispose() {
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Get the user id from the local storage
    storage.readStorage("_id").then((value) {
      setState(() {
        uid = value.toString();
      });
    });
    // Request focus on the comment field when the widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_commentFocusNode);
    });
  }

  void addComment(context) async {
    // Add comment to the database
    await CommentService().addComment({
      'content': commentController.text,
      'like': 0,
      'dislike': 0,
    });

    // Clear the comment field
    commentController.clear();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    print(uid);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context, false),
          ),
          title: const Text('Add Comment'),
          actions: [
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => addComment(context),
            ),
          ],
        ),
        body: Container(
          child: FocusScope(
            canRequestFocus: true,
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: commentController,
              focusNode: _commentFocusNode,
              decoration: const InputDecoration(
                  hintText: 'Enter your comment',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10)),
            ),
          ),
        ));
  }
}
