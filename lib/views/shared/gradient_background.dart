import 'package:flutter/material.dart';
import 'package:mr_house/core/constants/app_colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.background,
            AppColors.primaryLight,
            AppColors.background
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
          child: Padding(padding: const EdgeInsets.all(16), child: child)),
    );
  }
}
