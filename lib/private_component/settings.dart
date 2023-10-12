import 'package:collab/custom_widget/my_button.dart';
import 'package:collab/custom_widget/my_profile_pic.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';
import 'package:provider/provider.dart';
import '../services/storage.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String? _pic;

  @override
  void initState() {
    super.initState();
    storage.readStorage("profilePic").then((value) {
      setState(() {
        _pic = value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
            leading: Container(),
            foregroundColor: Colors.white,
            backgroundColor: Color.fromARGB(255, 99, 58, 1)),
        backgroundColor: const Color.fromARGB(255, 235, 224, 209),
        body: SafeArea(
            child: Center(
          child: Column(children: [
            const SizedBox(height: 50),
            SizedBox(
                height: 150,
                width: 150,
                child: ProfilePic(pic: _pic != null ? _pic : null, size: 150)),
            const SizedBox(height: 50),
            const Text(
              "Ready to be Productive!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 107, 46, 0),
              ),
            ),
            const SizedBox(height: 50),
            MyButton(
                onPressed: () {
                  auth.logout();
                  Navigator.pop(context);
                },
                name: "Logout")
          ]),
        )));
  }
}
