import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:major_match2/core/services/local_storage.dart';
import 'package:major_match2/core/theme/app_color.dart';
import 'package:major_match2/feature/authentications/presentations/screens/controller/login_controller.dart';
import 'package:major_match2/feature/authentications/presentations/screens/login_screen.dart';
import 'package:major_match2/feature/authentications/presentations/screens/register_screen.dart';
import 'package:major_match2/feature/home/presentations/screen/home_screen.dart';
import 'package:major_match2/feature/major/presentation/screen/select_screen.dart';
import 'package:major_match2/feature/questions/presentaions/controllers/question_controller.dart';
import 'package:major_match2/feature/welcome/presentations/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  Get.put(StorageService(prefs));
  Get.put(LoginController());
  Get.put(QuestionController());

  // Load saved userId
  await Get.find<LoginController>().loadSavedUserId();


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
      home: _getInitialScreen(),
      getPages: [
        GetPage(name: '/', page: () => WelcomeScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/select', page: () => Select()),
        GetPage(name: '/home', page: () => HomeScreen(userName: Get.find<LoginController>().Username.value, selectedMajors: Get.find<StorageService>().getSelectedMajors())),
        
      ],
    );
  }

  Widget _getInitialScreen() {
    final userId = Get.find<StorageService>().getUserId();
    if (userId != null && userId.isNotEmpty) {
      return Select();
    } else {
      return WelcomeScreen();
    }
  }
}
