import 'package:collab/private_component/category.dart';
import 'package:collab/services/project.dart';
import 'package:collab/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

class EditProject extends StatefulWidget {
  const EditProject({super.key, required this.project});
  final project;

  @override
  State<EditProject> createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  late final titleController =
      TextEditingController(text: widget.project['name']);
  late final contentController =
      TextEditingController(text: widget.project['content']);
  String? uid;
  late List<String> selectedCat = widget.project['category'].cast<String>();

  @override
  void initState() {
    super.initState();

    storage.readStorage("_id").then((value) {
      setState(() {
        uid = value.toString();
      });
    });
  }

  void editProject(context) async {
    Object projectFinal = {
      'name': titleController.text,
      'content': contentController.text,
      'category': selectedCat,
    };

    await ProjectService().editProject(projectFinal, widget.project['_id']);
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
        actions: [
          TextButton(
            child: const Text("Confirm", style: TextStyle(color: Colors.white)),
            onPressed: () async => editProject(context),
          ),
        ],
        title: const Text('Edit Project'),
      ),
      body: Column(
        children: [
          TextField(
            controller: titleController,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            decoration: const InputDecoration(
                hintText: 'Project Name',
                hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
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
    );
  }
}
