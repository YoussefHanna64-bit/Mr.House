import 'package:flutter/material.dart';
import 'package:mr_house/core/constants/app_colors.dart';

class InfoCardWidget extends StatelessWidget {
  final String label;
  final String value;

  const InfoCardWidget({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: AppColors.primary),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
