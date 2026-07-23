import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final bool obscure;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final InputBorder? border;
  final TextStyle? style;

  const AppTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.obscure = false,
    this.inputFormatters,
    this.onChanged,
    this.maxLines = 1,
    this.border,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: Colors.green,
      obscureText: obscure,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      style: style ?? const TextStyle(color: Colors.black, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint ?? label,
        labelText: label,
        errorText: errorText?.isNotEmpty == true ? errorText : null,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 24) : null,
        prefixIconColor: Colors.green,
        suffixIcon: suffixIcon,
        hintStyle: const TextStyle(color: Colors.black, fontSize: 14),
        labelStyle: const TextStyle(color: Colors.black, fontSize: 14),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
      ),
      onChanged: onChanged,
    );
  }
}
