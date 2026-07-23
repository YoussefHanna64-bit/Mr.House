import 'package:flutter/material.dart';
import 'package:mr_house/core/constants/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? height;
  final Color? color;
  final Color? textColor;

  const PrimaryButton(
      {super.key,
      required this.label,
      this.onPressed,
      this.height,
      this.color,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onPressed,
        child: Text(label,
            style: TextStyle(fontSize: 20, color: textColor ?? Colors.white)),
      ),
    );
  }
}
