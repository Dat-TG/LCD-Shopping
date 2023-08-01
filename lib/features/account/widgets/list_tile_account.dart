import 'package:flutter/material.dart';

class ListTileAccount extends StatelessWidget {
  final String leading;
  final String title;
  const ListTileAccount(
      {super.key, required this.leading, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(leading),
        ),
        title: Text(title),
        minLeadingWidth: 70,
      ),
    );
  }
}
