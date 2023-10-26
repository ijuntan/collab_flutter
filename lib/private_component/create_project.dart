import 'package:collab/private_component/category.dart';
import 'package:collab/private_component/create_post.dart';
import 'package:collab/services/project.dart';
import 'package:collab/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

class CreateProject extends StatefulWidget {
  const CreateProject({super.key});

  @override
  State<CreateProject> createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  String? uid;
  List<String> selectedCat = [];

  @override
  void initState() {
    super.initState();

    storage.readStorage("_id").then((value) {
      setState(() {
        uid = value.toString();
      });
    });
  }

  void addProject() async {
    Object projectFinal = {
      'name': titleController.text,
      'content': contentController.text,
      'category': selectedCat,
      'document': [],
      'members': [
        {'member': uid, 'permission': "Admin"}
      ],
      'createdBy': uid
    };

    await ProjectService().addProject(projectFinal);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context, false),
          ),
          title: const Text('Create Project'),
        ),
        body: Column(
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              decoration: const InputDecoration(
                  hintText: 'Project Name',
                  hintStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10)),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: DropDownMultiSelect(
                decoration: InputDecoration(),
                onChanged: (List<String> x) {
                  setState(() {
                    selectedCat = x;
                  });
                },
                options: categoryList,
                selectedValues: selectedCat,
                whenEmpty: 'Pilih Kategori',
              ),
            ),
            Flexible(
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: contentController,
                decoration: const InputDecoration(
                    hintText: 'Project Description',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10)),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => addProject(),
          child: const Icon(Icons.send),
        ));
  }
}
