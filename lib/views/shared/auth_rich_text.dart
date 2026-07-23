import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../core/constants/app_colors.dart';

class AuthRichText extends StatelessWidget {
  final String prefix;
  final String linkText;
  final VoidCallback onTap;

  const AuthRichText(
      {super.key,
      required this.prefix,
      required this.linkText,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: prefix,
                style: const TextStyle(
                    fontFamily: "Inter", fontSize: 14, color: Colors.black)),
            TextSpan(
              text: linkText,
              style: const TextStyle(
                  fontFamily: "Inter",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
          ],
        ),
      ),
    );
  }
}
