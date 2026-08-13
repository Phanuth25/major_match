import 'package:dio/dio.dart';
import 'package:get_x/get.dart' hide FormData, MultipartFile;
import 'package:major_match2/core/services/dio_client.dart';

class ApiController extends GetxController {
  var isLoading = false.obs;
  var responseData = ''.obs;
  var errorMessage = ''.obs;

  Future<bool> Register({
    required String name,
    required String email,
    required String password,
    List<int>? profileImageBytes,
    String? profileImageFilename,
  }) async {
    try {
      isLoading(true);
      errorMessage('');

      final formData = FormData.fromMap({
        'name': name,
        'email': email,
        'password': password,
        if (profileImageBytes != null)
          'profile_image': MultipartFile.fromBytes(
            profileImageBytes,
            filename: profileImageFilename ?? 'profile.jpg',
          ),
      });

      final response = await ApiClient.instance.post('/register', data: formData);
      if (response.statusCode == 201) {
        responseData('Registration successful');
        return true;
      } else {
        errorMessage('Failed to register: ${response.statusCode}');
        responseData(response.data.toString());
        return false;
      }
    } on DioException catch (e) {
      errorMessage(e.response?.data?.toString() ?? e.message ?? 'Something went wrong');
      responseData('DioError: ${e.message}');
      return false;
    } catch (e) {
      errorMessage('$e');
      responseData('Exception: $e');
      return false;
    } finally {
      isLoading(false);
    }
  }
}