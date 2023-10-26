import 'package:collab/custom_widget/my_profile_pic.dart';
import 'package:collab/private_component/create_post.dart';
import 'package:collab/private_component/home.dart';
import 'package:collab/private_component/my_projects.dart';
import 'package:collab/private_component/settings.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  //final title;

  @override
  State<DashboardPage> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  int currentMenuNow = 0;

  List<Widget> menu = [
    HomePage(),
    MyProject(),
    Container(),
    Container(),
    Container()
  ];

  List<String> menuName = [
    "Home",
    "Projects",
    "Create Post",
    "Chat",
    "Notification"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(menuName[currentMenuNow]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Setting()),
                  );
                },
                child: const ProfilePic(pic: null, size: 20)),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        //I want to change the background color of navigation bar
        currentIndex: currentMenuNow,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Project',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
        ],
        onTap: (value) => setState(() => {
              currentMenuNow = value,
              if (value == 2)
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreatePost()),
                  ).then((_) => setState(() => currentMenuNow = 0))
                }
            }),
      ),
      body: menu[currentMenuNow],
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
