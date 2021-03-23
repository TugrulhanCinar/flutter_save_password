import 'package:flutter/material.dart';

class MyCustomDialog extends StatelessWidget {
  final Widget? title;
  final Widget content;
  final List<Widget>? actions;
  final double paddingAll;
  final double radius;

  const MyCustomDialog({
    Key? key,
    required this.content,
    this.paddingAll: 16,
    this.radius: 32,
    this.actions,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      scrollable: true,
      actions: actions,
      contentPadding: const EdgeInsets.all(16.0),
      content: content,
    );
  }

  Future<bool?> goster(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => this,
    );
  }
}
