import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mr_house/viewmodels/theme/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'repositories/auth_repository.dart';
import 'repositories/course_repository.dart';
import 'repositories/user_repository.dart';
import 'firebase_options.dart';
import 'viewmodels/auth/auth_cubit.dart';
import 'viewmodels/course/course_cubit.dart';
import 'viewmodels/profile/profile_cubit.dart';
import 'viewmodels/theme/theme_cubit.dart';
import 'views/welcome/welcome_view.dart';
import 'views/student/main_layout.dart';
import 'views/professor/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
  final userRole = prefs.getString("userRole") ?? "";

  final initialRoute = isLoggedIn
      ? (userRole == "student" ? "/studentHome" : "/professorHome")
      : "/";

  final authRepo = AuthRepository();
  final courseRepo = CourseRepository();
  final userRepo = UserRepository();

  runApp(MrHouseApp(
    initialRoute: initialRoute,
    authRepo: authRepo,
    courseRepo: courseRepo,
    userRepo: userRepo,
  ));
}

class MrHouseApp extends StatelessWidget {
  final String initialRoute;
  final AuthRepository authRepo;
  final CourseRepository courseRepo;
  final UserRepository userRepo;

  const MrHouseApp({
    super.key,
    required this.initialRoute,
    required this.authRepo,
    required this.courseRepo,
    required this.userRepo,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider.value(value: userRepo),
        BlocProvider(create: (context) => AuthCubit(authRepo)),
        BlocProvider(create: (context) => CourseCubit(courseRepo)),
        BlocProvider(create: (context) => ProfileCubit(userRepo, authRepo)),
        BlocProvider(create: (context) => ThemeCubit()..loadPreference()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Mr House",
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeState.themeMode,
            initialRoute: initialRoute,
            routes: {
              "/": (context) => const WelcomeView(),
              "/studentHome": (context) => const StudentMainLayout(),
              "/professorHome": (context) => const ProfessorMainLayout(),
            },
          );
        },
      ),
    );
  }
}
