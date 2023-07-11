import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  const CustomTextField({super.key, required this.controller, this.hint});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: (hint == 'Password') ? true : false,
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black38),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black38),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your $hint';
        }
        return null;
      },
    );
  }
}
