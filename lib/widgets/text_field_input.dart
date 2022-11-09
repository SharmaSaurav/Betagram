import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final bool isPass;
  final TextEditingController textEditingController;
  final String hintText;
  final TextInputType textInputType;
  const TextFieldInput(
      {super.key,
      required this.textEditingController,
      required this.hintText,
      this.isPass = false,
      required this.textInputType});

  @override
  Widget build(BuildContext context) {
    final InputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return Container(
        width: 400,
        child: TextField(
          controller: textEditingController,
          decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder,
              focusedBorder: InputBorder,
              enabledBorder: InputBorder,
              filled: true,
              contentPadding: const EdgeInsets.all(8)),
          keyboardType: textInputType,
          obscureText: isPass,
        ));
  }
}
