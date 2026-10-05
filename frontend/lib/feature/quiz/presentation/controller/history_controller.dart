import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:major_match2/core/services/dio_client.dart';
import 'package:major_match2/core/services/local_storage.dart';
import 'package:major_match2/feature/quiz/model/history_model.dart';

class QuizHistoryController extends GetxController {
  // Reactive state variables
  var results = <QuizAttemptResult>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;
  final StorageService _storageService = Get.find<StorageService>();

  Map<int, List<QuizAttemptResult>> get groupedByAttempt {
    final Map<int, List<QuizAttemptResult>> grouped = {};
    for (var item in results) {
      grouped.putIfAbsent(item.quizAttemptId, () => []).add(item);
    }
    return grouped;
  }

  @override
  void onInit() {
    super.onInit();
    // Fetch data automatically when the controller is initialized
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
      isLoading(true);
      errorMessage(''); // Reset previous errors
      successMessage(''); // Reset previous success messages
      final userId = _storageService
          .getUserId(); // Replace with actual user ID if needed
      debugPrint('Fetching quiz history for userId: $userId');
      final response = await ApiClient.instance.get('/history/$userId');

      if (response.statusCode == 201) {
        // 1. Parse into Model object
        QuizResultModel quizResultModel = QuizResultModel.fromJson(
          response.data as Map<String, dynamic>,
        );

        // 2. Update reactive list
        results.assignAll(quizResultModel.results);
        successMessage('Quiz history loaded successfully');
      } else {
        errorMessage('Server error: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage('Failed to load quiz history: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deletehistory() async {
    isLoading(true);
    errorMessage(''); // Reset previous errors
    successMessage(''); // Reset previous success messages
    try{
      final userId = _storageService.getUserId();
      debugPrint('Deleting quiz history for userId: $userId');
      final response = await ApiClient.instance.delete('/history/$userId/$id');

      if (response.statusCode == 201) {
        results.clear(); // Clear the local list after successful deletion
        successMessage('Quiz history deleted successfully');
      } else {
        errorMessage('Server error: ${response.statusCode}');
      }
    }catch(e){
      errorMessage('Failed to delete quiz history: ${e.toString()}');
    }
    finally{
      isLoading(false);
    }
  }
}
