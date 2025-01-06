import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final Widget child; // Ensure child is a widget
  final ButtonStyle? style; // ButtonStyle type for the style
  final VoidCallback onPressed; // VoidCallback for onPressed

  const CustomTextButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.style, // Make style optional (nullable)
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: style ?? TextButton.styleFrom(),
      child: child, // Provide default style if none is provided
    );
  }
}
