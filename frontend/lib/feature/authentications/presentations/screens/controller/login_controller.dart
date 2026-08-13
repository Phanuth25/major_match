import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_x/get.dart' hide FormData, MultipartFile;
import 'package:major_match2/core/services/dio_client.dart';

class LoginController extends GetxController {
  final isLoading = false.obs;
  final errormessage = ''.obs;
  final successmessage = ''.obs;
  Future<bool> Login({required String name,
    required String email,
    required String password,}) async {
    try {
      isLoading.value = true;
       final data = {
      'email': email,
      'password': password,
    };
      final response = await ApiClient.instance.post('/login', data: data);

      if (response.statusCode == 200) {
        successmessage.value = 'Login successfully';
        return true;
      } else {
        errormessage.value = 'Login failed: ${response.statusCode}';
        return false;
      }
    } 
     on DioException catch (e) {
      errormessage.value = e.response?.data?.toString() ?? e.message ?? 'Something went wrong';
      debugPrint('DioError: ${e.message}');
      return false;
    }catch (e) {
      debugPrint('Error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}