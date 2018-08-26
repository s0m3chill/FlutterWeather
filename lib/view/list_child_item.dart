
import 'package:flutter/material.dart';

class ListChildItem extends StatelessWidget {
  final String name;

  ListChildItem(this.name);

  @override
  Widget build(BuildContext context) {
    return new ListTile(title: new Text(this.name));
  }

}