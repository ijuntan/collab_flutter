import 'package:flutter/material.dart';
import '../services/functions.dart';
import '../custom_widget/my_profile_pic.dart';

class PostPost extends StatefulWidget {
  final post, commentLength, updateParentPosts;
  const PostPost(
      {super.key,
      required this.post,
      this.commentLength,
      this.updateParentPosts});

  @override
  State<PostPost> createState() => _PostPostState();
}

class _PostPostState extends State<PostPost> {
  late final post = super.widget.post;
  late final commentLength = super.widget.commentLength;
  late final updateParentPosts = super.widget.updateParentPosts;

  void updateAction(String action) {
    updateParentPosts(action);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child:
              // Header - Content
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                ProfilePic(pic: post['createdBy']['profilePic'], size: 30),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${post['createdBy']['username']}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(formatDate('${post['createdAt']}')),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('${post['name']}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Row(children: <Widget>[
              for (var item in post['category'])
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300],
                    ),
                    child: Text(item, style: const TextStyle(fontSize: 12)))
            ]),
            const SizedBox(height: 10),
            Text('${post['content']}'),
            const SizedBox(height: 10),
            if (post['image'] != null && post['image'] != '')
              Image.network('${post['image']}',
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.cover, loadingBuilder: (BuildContext context,
                      Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                    child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 99, 58, 1),
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ));
              }),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.thumb_up),
                color: post['action'] == "Like"
                    ? Colors.green[800]
                    : Colors.grey[800],
                onPressed: () => updateAction("Like"),
              ),
              Text('${post['like']}'),
              IconButton(
                icon: const Icon(Icons.thumb_down),
                color: post['action'] == "Dislike"
                    ? Colors.red[800]
                    : Colors.grey[800],
                onPressed: () => updateAction("Dislike"),
              ),
              Text('${post['dislike']}'),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () {},
              ),
              Text('$commentLength'),
            ],
          ),
        ),
      ],
    );
    // Actions
  }
}
