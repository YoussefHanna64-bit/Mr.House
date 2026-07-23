import 'package:flutter/material.dart';
import 'package:mr_house/core/constants/app_colors.dart';
import 'package:mr_house/core/constants/app_dimensions.dart';
import 'package:mr_house/core/constants/app_strings.dart';
import 'package:mr_house/views/shared/gradient_background.dart';
import 'role_selection_view.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.welcome,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w600)),
            AppDimensions.hSBSm,
            AppDimensions.hSBSm,
            AppDimensions.hSBSm,
            Center(
              child: CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primaryLight,
                child: IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RoleSelectionView())),
                  icon:
                      const Icon(Icons.arrow_forward_ios, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
