import 'package:collab/services/comment.dart';
import 'package:flutter/material.dart';

class EditComment extends StatefulWidget {
  final content, id;
  const EditComment({super.key, required this.content, required this.id});

  @override
  State<EditComment> createState() => _EditCommentState();
}

class _EditCommentState extends State<EditComment> {
  final _commentFocusNode = FocusNode();
  late final commentController = TextEditingController(text: widget.content);

  @override
  void dispose() {
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Request focus on the comment field when the widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_commentFocusNode);
    });
  }

  void editComment(context) async {
    // Patch comment to the database
    await CommentService().editComment({
      "content": commentController.text,
    }, widget.id);

    // Clear the comment field
    commentController.clear();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: const Text('Edit Comment'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => editComment(context),
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
