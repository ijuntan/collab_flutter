import 'package:collab/services/post.dart';
import 'package:flutter/material.dart';
import 'package:collab/custom_widget/my_profile_pic.dart';
import '../../services/functions.dart';
import '../services/storage.dart';
import 'post.dart';

class PostHome extends StatefulWidget {
  const PostHome({super.key, required this.post, required this.handleDelete});
  final post, handleDelete;

  @override
  State<PostHome> createState() => _PostHomeState();
}

class _PostHomeState extends State<PostHome> {
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
    var post = super.widget.post;

    void updateAction(String action) {
      PostService().actionPost(action, post['action'], post['_id']);

      switch (action) {
        case 'Like':
          switch (post['action']) {
            case 'Like':
              setState(() {
                post['like']--;
                post['action'] = '';
              });
              break;
            case 'Dislike':
              setState(() {
                post['like']++;
                post['dislike']--;
                post['action'] = 'Like';
              });
              break;
            default:
              setState(() {
                post['like']++;
                post['action'] = 'Like';
              });
          }

        case 'Dislike':
          switch (post['action']) {
            case 'Like':
              setState(() {
                post['like']--;
                post['dislike']++;
                post['action'] = 'Dislike';
              });
              break;
            case 'Dislike':
              setState(() {
                post['dislike']--;
                post['action'] = '';
              });
              break;
            default:
              setState(() {
                post['dislike']++;
                post['action'] = 'Dislike';
              });
          }
      }
    }

    void goToSinglePostPage(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Post(post: post, updateParentPosts: updateAction)),
      );
    }

    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            goToSinglePostPage(context);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 15, top: 10, right: 5),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  ProfilePic(pic: post['createdBy']['profilePic'], size: 30),
                  const SizedBox(width: 10),
                  Text('${post['createdBy']['username']}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 5),
                  CircleAvatar(radius: 1.5, backgroundColor: Colors.grey[800]),
                  const SizedBox(width: 5),
                  Text(formatDate('${post['createdAt']}')),
                  const Spacer(),
                  post['createdBy']['_id'] == uid
                      ? PopupMenuButton(
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                          onSelected: (value) {
                            switch (value) {
                              case 'edit':
                                // Handle edit action

                                break;
                              case 'delete':
                                super.widget.handleDelete(post['_id']);
                                break;
                            }
                          },
                          child: const Icon(Icons.more_vert),
                        )
                      : const SizedBox(),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text('${post['name']}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const Spacer(),
                ],
              ),
              Row(children: <Widget>[
                for (var item in post['category'])
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300],
                      ),
                      child: Text(item, style: const TextStyle(fontSize: 12)))
              ]),
              const SizedBox(height: 10),
              Text('${post['content']}', softWrap: true),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.thumb_up),
                        color: post['action'] == "Like"
                            ? Colors.green[800]
                            : Colors.grey[800],
                        onPressed: () => updateAction("Like")),
                    Text('${post['like']}'),
                    IconButton(
                      icon: const Icon(Icons.thumb_down),
                      color: post['action'] == "Dislike"
                          ? Colors.red[800]
                          : Colors.grey[800],
                      onPressed: () => updateAction("Dislike"),
                    ),
                    Text('${post['dislike']}'),
                  ],
                ),
              ),
            ]),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
