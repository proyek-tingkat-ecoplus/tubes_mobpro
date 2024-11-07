import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType inputType;
  final IconData icon;

  const CustomInput({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.inputType = TextInputType.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: inputType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
