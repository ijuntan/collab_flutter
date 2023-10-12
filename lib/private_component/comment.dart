import 'package:flutter/material.dart';
import '../services/functions.dart';
import '../custom_widget/my_profile_pic.dart';

class Comment extends StatefulWidget {
  const Comment({Key? key, required this.comment}) : super(key: key);
  final comment;

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  late final comment = super.widget.comment;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Flexible(
                  child: ProfilePic(
                      pic: comment['createdBy']['profilePic'], size: 30)),
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
                    onPressed: () {},
                    icon: const Icon(Icons.reply, color: Colors.grey))
              ],
            ),
          ],
        ),
      ],
    );
  }
}
