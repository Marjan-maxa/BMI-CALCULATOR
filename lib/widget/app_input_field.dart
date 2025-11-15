import 'package:flutter/material.dart';

class AppInputField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType textinputtype;
  const AppInputField({
    super.key, required this.controller,required this.labelText,required this.textinputtype
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: textinputtype,
      decoration: InputDecoration(
          hintText: labelText,
          label: Text(labelText),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),

          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.blue)
          )
      ),
    );
  }
}