
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:get_x/get_state_manager/src/simple/get_controllers.dart';
import 'package:major_match2/core/services/dio_client.dart';
import 'package:major_match2/feature/major/model/select_model.dart';

class MajorController extends GetxController {
  // Reactive state variables
  var majors = <Major>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch data automatically when the controller is initialized
    fetchMajors();
  }

  Future<void> fetchMajors() async {
    try {
      isLoading(true);
      errorMessage(''); // Reset previous errors
      successMessage(''); // Reset previous success messages

      final response = await  ApiClient.instance.get('/select');

      if (response.statusCode == 200) {

        // 1. Parse into Model object
        SelectModel selectModel = SelectModel.fromJson(response.data as Map<String, dynamic>);

        // 2. Update reactive list
        majors.assignAll(selectModel.majors);
        debugPrint('Majors loaded: ${majors.length}');
        successMessage('Majors loaded successfully');
      } else {
        errorMessage('Server error: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage('Failed to load majors: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }
}