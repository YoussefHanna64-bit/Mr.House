import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mr_house/core/constants/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final dynamic icon;
  final String label;
  final VoidCallback onTap;

  const CategoryChip(
      {super.key,
      required this.icon,
      required this.label,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(right: 20),
        color: AppColors.primary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              icon is IconData
                  ? FaIcon(icon as IconData, color: Colors.white, size: 16)
                  : Icon(icon as IconData, color: Colors.white, size: 16),
              const SizedBox(width: 20),
              Text(label,
                  style: const TextStyle(fontSize: 14, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
