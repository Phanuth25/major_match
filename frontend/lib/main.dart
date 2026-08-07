import 'package:flutter/material.dart';
import 'package:major_match2/core/theme/app_color.dart';
import 'package:major_match2/feature/welcome/presentation/screens/welcome_screen.dart';



void main() {
  runApp(const MajorMatchApp());
}

class MajorMatchApp extends StatelessWidget {
  const MajorMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: WelcomeScreen(
        // TODO(sprint-2): replace with Navigator.pushNamed once the
        // major-selection and login routes exist.
        onGetStarted: () => debugPrint('Get started tapped'),
        onLogin: () => debugPrint('Login tapped'),
      ),
    );
  }
}