import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  const CustomButton(
      {super.key,
      required this.text,
      this.onTap,
      this.backgroundColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: backgroundColor),
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ));
  }
}
