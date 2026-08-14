import 'package:flutter/material.dart';
import 'package:major_match2/core/theme/app_color.dart';
import 'package:major_match2/feature/authentications/presentations/screens/login_screen.dart';
import 'package:major_match2/feature/major/presentation/screen/select_screen.dart';
import 'package:major_match2/feature/welcome/presentations/screens/welcome_screen.dart';
import 'package:major_match2/feature/authentications/presentations/screens/register_screen.dart';
import 'package:get_x/get.dart';

void main() {
  runApp(const MajorMatchApp());
}

class MajorMatchApp extends StatelessWidget {
  const MajorMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MajorMatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.ink,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.amber,
          brightness: Brightness.dark,
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => WelcomeScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/select', page: () => Select()),
        // Add every other screen you navigate to here, e.g.:
        // GetPage(name: '/login', page: () => LoginScreen()),
      ],
    );
  }
}