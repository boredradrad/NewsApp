import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.title,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
  });

  final String title;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,

          keyboardType: TextInputType.emailAddress,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
