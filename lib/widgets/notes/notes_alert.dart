import 'package:flutter/material.dart';

class NoteAlert extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSave;
  final String hint;
  final String title;

  const NoteAlert({
    Key? key,
    required this.controller,
    required this.onSave,
    required this.hint,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: hint),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onSave();
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
