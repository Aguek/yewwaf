import 'package:flutter/material.dart';
class TextFieldModel extends StatelessWidget {
  const TextFieldModel({
    Key? key,
    required this.controller,
    required this.hint,
  }) : super(key: key);

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true,
      controller: controller,
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
      ),
    );
  }
}