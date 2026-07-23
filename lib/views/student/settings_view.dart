import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mr_house/core/constants/app_colors.dart';
import 'package:mr_house/core/constants/app_dimensions.dart';
import 'package:mr_house/core/constants/app_strings.dart';
import 'package:mr_house/models/user_model.dart';
import 'package:mr_house/viewmodels/auth/auth_cubit.dart';
import 'package:mr_house/viewmodels/auth/auth_state.dart';
import 'package:mr_house/viewmodels/theme/theme_cubit.dart';
import 'package:mr_house/views/shared/confirm_dialog.dart';
import 'package:mr_house/views/shared/settings_tile.dart';
import 'package:mr_house/views/student/personal_info_view.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsView extends StatelessWidget {
  final UserRole role;

  const SettingsView({super.key, this.role = UserRole.student});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;
    final themeState = context.watch<ThemeCubit>().state;
    final isDark = themeState.themeMode == ThemeMode.dark;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                SizedBox(
                  height: h * 2 / 7,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/background11.jpg"),
                            fit: BoxFit.cover)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(AppStrings.settings,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Inter")),
                          Row(
                            children: [
                              const CircleAvatar(
                                  radius: 50,
                                  child:
                                      FaIcon(FontAwesomeIcons.user, size: 50)),
                              AppDimensions.wSBLg,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(AppStrings.hello,
                                      style: TextStyle(fontSize: 14)),
                                  Text(user?.name.split(" ").first ?? "",
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            SettingsTile(
                                icon: Icons.person,
                                title: AppStrings.profileTile,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PersonalInfoView(role: role)));
                                }),
                            const SettingsTile(
                                icon: Icons.info,
                                title: AppStrings.policy,
                                subtitle: AppStrings.terms),
                            const SettingsTile(
                                icon: Icons.restart_alt_sharp,
                                title: AppStrings.version,
                                subtitle: AppStrings.versionNum),
                            SettingsTile(
                                icon: FontAwesomeIcons.solidMoon,
                                title: AppStrings.darkMode,
                                trailing: Switch(
                                    value: isDark,
                                    onChanged: (v) => context
                                        .read<ThemeCubit>()
                                        .toggleTheme(v))),
                            SettingsTile(
                                icon: Icons.delete,
                                title: AppStrings.deleteAccount,
                                titleColor: Colors.redAccent.shade700,
                                onTap: () => _deleteAccount(context)),
                            SettingsTile(
                                icon: Icons.logout_outlined,
                                title: AppStrings.logout,
                                onTap: () => _logout(context)),
                            const Divider(thickness: 1),
                            _contactSection(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }

  Widget _contactSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(AppStrings.contactUs, style: TextStyle(fontSize: 20)),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone, size: 35),
            AppDimensions.wSBMd,
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(AppStrings.hotLine,
                  style: TextStyle(
                      decoration: TextDecoration.underline, fontSize: 16)),
              Text("19991", style: TextStyle(fontSize: 12)),
            ]),
          ],
        ),
        const Text(AppStrings.or, style: TextStyle(fontSize: 12)),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _socialIcon(FontAwesomeIcons.facebook, AppColors.facebook,
                  "https://www.facebook.com/"),
              _socialIcon(FontAwesomeIcons.instagram, AppColors.instagram,
                  "https://www.instagram.com/"),
              _socialIcon(FontAwesomeIcons.twitter, AppColors.twitter,
                  "https://twitter.com/?lang=ar"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _socialIcon(IconData icon, Color color, String url) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunchUrlString(url)) await launchUrlString(url);
      },
      child: FaIcon(icon, color: color, size: 40),
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final confirmed = await showConfirmDialog(context,
        title: AppStrings.deleteTitle,
        content: AppStrings.deleteConfirm,
        yes: AppStrings.delete,
        no: AppStrings.cancel,
        yesColor: AppColors.error);

    if (confirmed == true && context.mounted) {
      await context.read<AuthCubit>().deleteAccount();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showConfirmDialog(context,
        title: AppStrings.logoutTitle, content: AppStrings.logoutConfirm);

    if (confirmed == true && context.mounted) {
      await context.read<AuthCubit>().logout();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
      }
    }
  }
}
