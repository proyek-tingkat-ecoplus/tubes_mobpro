import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final Widget child; // Ensure child is a widget
  final ButtonStyle? style; // ButtonStyle type for the style
  final VoidCallback onPressed; // VoidCallback for onPressed

  const CustomTextButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.style, // Make style optional (nullable)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child,
      style: style ?? TextButton.styleFrom(), // Provide default style if none is provided
    );
  }
}
