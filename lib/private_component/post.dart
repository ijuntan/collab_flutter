import 'package:collab/private_component/add_comment.dart';
import 'package:collab/private_component/child_comment.dart';
import 'package:flutter/material.dart';
import 'settings.dart';
import '../services/comment.dart';
import 'comment.dart';
import 'post_post.dart';

class Post extends StatefulWidget {
  const Post({Key? key, required this.post, required this.updateParentPosts})
      : super(key: key);
  final post, updateParentPosts;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  late final post = super.widget.post;
  List<dynamic> comments = [];
  @override
  Widget build(BuildContext context) {
    Widget commentSection(parentComments, comments) {
      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: parentComments.length,
          itemBuilder: (context, index) {
            List<dynamic> childComments = comments
                .where((comment) =>
                    comment['parent'] == parentComments[index]['_id'])
                .toList();

            List<dynamic> allChildComments = comments
                .where((comment) =>
                    comment['root'] == parentComments[index]['_id'])
                .toList();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      Comment(
                        comment: parentComments[index],
                      ),
                      childComments.isNotEmpty
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: childComments.length,
                              itemBuilder: (context, childIndex) {
                                return ChildComment(
                                  parentComment: childComments[childIndex],
                                  allComments: allChildComments,
                                );
                              })
                          : Container(),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(height: 10, color: Colors.amber[100]),
                const SizedBox(height: 10),
              ],
            );
          });
    }

    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Setting()),
            );
          },
        ),
      ]),
      body: FutureBuilder<Object>(
          future: CommentService().getComments(post['_id']),
          builder: (context, AsyncSnapshot snapshot) {
            dynamic parentComments = [];
            if (snapshot.hasData) {
              parentComments = snapshot.data!
                  .where((comment) => comment['parent'] == null)
                  .toList(); // Filter comments where parent is null;

              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PostPost(
                          post: post,
                          commentLength: snapshot.data.length,
                          updateParentPosts: widget.updateParentPosts),
                      // Comments
                      Container(height: 10, color: Colors.amber[100]),
                      const SizedBox(height: 10),

                      parentComments.length > 0
                          ? commentSection(parentComments, snapshot.data)
                          : Center(
                              child: Text(
                              "No Comment Yet",
                              style: TextStyle(color: Colors.grey[800]),
                            )),

                      // Add Comment
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          }),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddComment())),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Add a comment',
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
