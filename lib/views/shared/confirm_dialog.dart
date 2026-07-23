import 'package:flutter/material.dart';
import 'package:mr_house/core/constants/app_colors.dart';

Future<bool?> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String content,
  String yes = "Yes",
  String no = "No",
  Color yesColor = AppColors.primary,
  Color noColor = AppColors.error,
}) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(yes,
                    style: TextStyle(
                        color: yesColor, fontWeight: FontWeight.bold))),
            const SizedBox(width: 20),
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(no,
                    style: TextStyle(
                        color: noColor, fontWeight: FontWeight.bold))),
          ],
        );
      });
}
