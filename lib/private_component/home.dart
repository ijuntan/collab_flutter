import 'package:flutter/material.dart';
import '../../services/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  //final title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> posts = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: PostService().getPost(posts.length),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            posts.addAll(snapshot.data as List<dynamic>);
            print(posts);
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('${posts[index]['name']}'),
                    subtitle: Text('${posts[index]['content']}'),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
