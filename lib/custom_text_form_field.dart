import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.keyboardType,
    this.hintText,
    this.onFieldSubmitted,
    this.validator,
  });

  final TextEditingController controller;

  final TextInputType? keyboardType;

  final String? hintText;

  final void Function(String)? onFieldSubmitted;

  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      cursorColor: Colors.black,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.transparent,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        hintText: hintText,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
      ),
    );
  }
}
