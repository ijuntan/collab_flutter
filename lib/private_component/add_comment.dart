import 'package:collab/services/comment.dart';
import 'package:flutter/material.dart';
import '../services/storage.dart';

class AddComment extends StatefulWidget {
  final root, parent, postId;
  const AddComment({
    super.key,
    required this.root,
    required this.parent,
    this.postId,
  });

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
    Object comment = {
      'content': commentController.text,
      'like': 0,
      'dislike': 0,
      'root': widget.root,
      'parent': widget.parent,
      'postId': widget.postId,
      'createdBy': uid,
    };
    await CommentService().addComment(comment);

    // Clear the comment field
    commentController.clear();

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
        title: const Text('Add Comment'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => addComment(context),
          ),
        ],
      ),
      body: FocusScope(
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
    );
  }
}
