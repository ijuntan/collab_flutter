import 'package:flutter/material.dart';
import 'package:collab/private_component/post_home.dart';
import 'package:collab/services/storage.dart';
import 'package:collab/services/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> posts = [];
  List<dynamic> actions = [];
  String uid = "";

  @override
  void initState() {
    super.initState();
    storage.readStorage("_id").then((value) {
      setState(() {
        uid = value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: Future.wait([
          PostService().getPost(posts.length),
          if (uid != "") PostService().getActions(uid),
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            posts.addAll(snapshot.data[0] as List<dynamic>);
            actions.addAll(snapshot.data[1] as List<dynamic>);
            for (var post in posts) {
              post['action'] = "";
            }
            for (var action in actions) {
              final index =
                  posts.indexWhere((post) => post['_id'] == action['to']);
              if (index != -1) {
                posts[index]['action'] = action['action'];
              }
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  //make a padding for the
                  return PostHome(post: posts[index]);
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
