import 'package:collab/private_component/create_project.dart';
import 'package:collab/private_component/edit_project.dart';
import 'package:collab/services/project.dart';
import 'package:flutter/material.dart';
import 'package:collab/services/storage.dart';

class MyProject extends StatefulWidget {
  const MyProject({super.key});

  @override
  State<MyProject> createState() => _MyProjectState();
}

class _MyProjectState extends State<MyProject> {
  String? uid;

  @override
  void initState() {
    super.initState();
    storage.readStorage("_id").then((value) {
      setState(() {
        uid = value.toString();
      });
    });
  }

//Text(snapshot.data[index]['name'])
  @override
  Widget build(BuildContext context) {
    void handleDelete(projId, context) async {
      await ProjectService().deleteProject(projId);
      Navigator.of(context).pop();
      setState(() {});
    }

    Future<void> showDeleteDialog(projId) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Delete Project'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to delete this project?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () => handleDelete(projId, context),
              ),
            ],
          );
        },
      );
    }

    Future<void> showMembersDialog(members) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Members'),
            content: Column(children: [
              for (var i = 0; i < members.length; i++)
                ListTile(
                  title: Text(members[i]['member']['username']),
                  subtitle: Text(members[i]['permission']),
                ),
            ]),
            actions: <Widget>[
              TextButton(
                child: const Text('Exit'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return FutureBuilder<dynamic>(
        future: uid != null ? ProjectService().getProject(uid) : null,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(snapshot.data[index]['name']),
                              subtitle: Text(snapshot.data[index]['content']),
                              // onTap: () => Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             const CreateProject())),
                            ),
                            Row(children: [
                              for (var i = 0;
                                  i < snapshot.data[index]['category'].length;
                                  i++)
                                Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text(
                                        snapshot.data[index]['category'][i])),
                            ]),

                            //show more members from a button
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ElevatedButton(
                                      onPressed: () => showMembersDialog(
                                          snapshot.data[index]['members']),
                                      child: const Text("Members",
                                          style:
                                              TextStyle(color: Colors.white))),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditProject(
                                                  project: snapshot
                                                      .data[index]))).then(
                                          (_) => setState(() {})),
                                      child: const Text("Edit",
                                          style:
                                              TextStyle(color: Colors.white))),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                      onPressed: () => showDeleteDialog(
                                          snapshot.data[index]['_id']),
                                      child: const Text("Delete",
                                          style:
                                              TextStyle(color: Colors.white))),
                                ],
                              ),
                            ),

                            const Divider(),
                          ],
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: FloatingActionButton.extended(
                      label: const Text('Create Project'),
                      backgroundColor: Colors.amber[200],
                      foregroundColor: Colors.black,
                      onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CreateProject()))
                          .then((_) => setState(() {})),
                      icon: const Icon(Icons.add)),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
