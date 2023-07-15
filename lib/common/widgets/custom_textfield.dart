import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hint;
  final int? maxLines;
  const CustomTextField(
      {super.key, required this.controller, this.hint, this.maxLines = 1});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = false;
  @override
  void initState() {
    super.initState();
    _isPasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      maxLines: widget.maxLines,
      obscureText: (widget.hint == 'Password') ? !_isPasswordVisible : false,
      decoration: InputDecoration(
          hintText: widget.hint,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38),
          ),
          suffixIcon: (widget.hint == 'Password')
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  icon: Icon(_isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility))
              : null),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your ${widget.hint}';
        }
        return null;
      },
    );
  }
}
