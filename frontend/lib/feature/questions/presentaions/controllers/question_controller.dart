import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:major_match2/core/services/dio_client.dart';
import 'package:major_match2/feature/questions/model/question_model.dart';

class QuestionController extends GetxController {
  var questions = <Question>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  Future<void> fetchQuestionById(int id, String type) async {
    try {
      isLoading(true);
      errorMessage('');
      successMessage('');

      final response = await ApiClient.instance.get('/question/$id?type=$type');

      if (response.statusCode == 200) {
        final questionResponse = QuestionResponse.fromJson(
          response.data as Map<String, dynamic>,
        );

        questions.assignAll(questionResponse.questions);
        debugPrint('Questions loaded: ${questions.length}');
        debugPrint('Questions: ${questions.map((q) => q.toString()).toList()}');
        successMessage('Question loaded successfully');
      } else {
        errorMessage('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      errorMessage(
        e.response?.data?['message']?.toString() ??
            e.message ??
            'Failed to load question',
      );
      debugPrint('DioError: ${e.message}');
    } catch (e) {
      errorMessage('Failed to load question: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }
}
