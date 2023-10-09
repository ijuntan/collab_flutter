import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String labelText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        obscureText: obscureText,
        cursorColor: const Color.fromARGB(255, 107, 46, 0),
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 107, 46, 0),
            ),
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 107, 46, 0),
            ),
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Color.fromARGB(255, 107, 46, 0),
          ),
          fillColor: const Color.fromARGB(255, 255, 250, 230),
          filled: true,
        ),
      ),
    );
  }
}
