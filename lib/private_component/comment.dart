import 'package:flutter/material.dart';
import '../services/functions.dart';
import '../custom_widget/my_profile_pic.dart';
import 'add_comment.dart';
import '../services/storage.dart';
import '../services/comment.dart';
import 'edit_comment.dart';

class Comment extends StatefulWidget {
  const Comment({Key? key, required this.comment, this.callback})
      : super(key: key);
  final comment, callback;

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  String? uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storage.readStorage("_id").then((value) {
      setState(() {
        uid = value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final comment = super.widget.comment;
    final callback = super.widget.callback;

    void handleDelete() async {
      await CommentService().deleteComment(comment['_id']);
      callback();
    }

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              ProfilePic(pic: comment['createdBy']['profilePic'], size: 30),
              const SizedBox(width: 10),
              Text(
                '${comment['createdBy']['username']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
                softWrap: true,
              ),
              const SizedBox(width: 5),
              CircleAvatar(radius: 1.5, backgroundColor: Colors.grey[800]),
              const SizedBox(width: 5),
              Text(
                formatDate(comment['createdAt']),
                style: TextStyle(color: Colors.grey[800], fontSize: 12),
                softWrap: true,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: PopupMenuButton(
                  itemBuilder: (BuildContext context) =>
                      uid != null && comment['createdBy']['_id'] == uid
                          ? [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ]
                          : [],
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        // Handle edit action
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditComment(
                                        content: comment['content'],
                                        id: comment['_id'])))
                            .then((_) => callback());
                        break;
                      case 'delete':
                        handleDelete();
                        break;
                    }
                  },
                  child: Icon(Icons.more_vert),
                ),
              ),
            ]),
            const SizedBox(height: 10),
            Text(
              '${comment['content']}',
              softWrap: true,
            ),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.thumb_up_alt_outlined,
                      color: Colors.grey),
                  label: Text('${comment['like']}',
                      style: TextStyle(color: Colors.grey[700])),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.thumb_down_alt_outlined,
                      color: Colors.grey),
                  label: Text('${comment['dislike']}',
                      style: TextStyle(color: Colors.grey[700])),
                ),
                IconButton(
                    onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddComment(
                                    root: comment['root'] ?? comment['_id'],
                                    parent: comment['_id'],
                                    postId: comment['postId'])))
                        .then((_) => callback()),
                    icon: const Icon(Icons.reply, color: Colors.grey))
              ],
            ),
          ],
        ),
      ],
    );
  }
}
