import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../models/user_model.dart';
import '../shared/gradient_background.dart';
import '../shared/primary_button.dart';
import '../auth/login_view.dart';

class RoleSelectionView extends StatelessWidget {
  const RoleSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(AppStrings.youAre,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w600)),
            AppDimensions.hSBSm,
            _roleButton(
                context,
                AppStrings.student,
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const LoginView(role: UserRole.student)))),
            AppDimensions.hSBSm,
            const Text(AppStrings.or,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w600)),
            AppDimensions.hSBSm,
            _roleButton(
                context,
                AppStrings.professor,
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const LoginView(role: UserRole.professor)))),
          ],
        ),
      ),
    );
  }

  Widget _roleButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return SizedBox(
      width: 250,
      height: 70,
      child: PrimaryButton(label: text, onPressed: onPressed, height: 70),
    );
  }
}
