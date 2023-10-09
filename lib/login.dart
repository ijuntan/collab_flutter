import 'package:collab/custom_widget/my_button.dart';
import 'package:collab/custom_widget/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/index.dart';
import 'services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String errorMsg = "";
  final userController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void handleLogin() async {
      setState(() {
        errorMsg = "";
      });

      final data = {
        'username': userController.text,
        'password': passController.text,
      };

      final auth = Provider.of<Auth>(context, listen: false);

      try {
        final token = await Service().login(data);
        auth.login(token);
      } catch (e) {
        setState(() {
          errorMsg = "Login Failed";
        });
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 235, 224, 209),
        body: SafeArea(
            child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),

              //logo
              Image.asset('assets/images/collab.png', height: 100),

              const SizedBox(height: 50),

              //text
              const Text(
                "Ready to be Productive!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 107, 46, 0),
                ),
              ),

              const SizedBox(height: 25),

              //username
              MyTextField(
                  controller: userController,
                  labelText: "Username",
                  obscureText: false),

              const SizedBox(height: 10),

              //password
              MyTextField(
                  controller: passController,
                  labelText: "Password",
                  obscureText: true),

              //forgot password
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Forgot Password?", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),

              //sign in
              const SizedBox(height: 20),
              MyButton(onPressed: handleLogin, name: "Login"),
              const SizedBox(height: 20),

              //error message
              Text(errorMsg, style: const TextStyle(color: Colors.red)),

              //register
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member yet?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 107, 46, 0),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Register now!",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 107, 46, 0)),
                  ),
                ],
              ),
            ],
          ),
        )));
  }
}
