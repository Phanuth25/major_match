import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get_x/get.dart';
import 'package:major_match2/core/services/dio_client.dart';
import 'package:major_match2/core/services/local_storage.dart';
import 'package:major_match2/feature/quiz/presentation/controller/attempt_final_controller.dart';

class AttemptController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final successMessage = ''.obs;
  final attemptId = RxnInt();

  /// Creates a quiz-attempt record through POST /api/attempt.
  Future<int?> createAttempt({
    required DateTime startedAt,
    required int durationSeconds,
  }) async {
    final AttemptFinalController attemptFinalController =
        Get.find<AttemptFinalController>();
    final userId = Get.find<StorageService>().getUserId();

    if (userId == null || userId.isEmpty) {
      errorMessage.value = 'Please log in before starting a quiz';
      return null;
    }

    if (durationSeconds < 0) {
      errorMessage.value = 'Duration cannot be negative';
      return null;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await ApiClient.instance.post(
        '/attempt',
        data: {
          'user_id': int.tryParse(userId) ?? userId,
          'started_at': startedAt.toIso8601String(),
          'duration_second': durationSeconds,
        },
      );

      if (response.statusCode != 201) {
        errorMessage.value =
            response.data?['message']?.toString() ??
            'Failed to create quiz attempt';
        return null;
      }

      final id = response.data['attempt_id'];
      attemptId.value = id is int ? id : int.tryParse(id.toString());
      // Save it so AttemptFinalController can read it
      if (attemptId.value != null) {
        await Get.find<StorageService>().saveAttemptId(attemptId.value!);
      }
      successMessage.value =
          response.data['message']?.toString() ??
          'Quiz attempt created successfully';

      final finalResultsSaved = await attemptFinalController
          .createAttemptFinalResults();
      if (!finalResultsSaved) {
        errorMessage.value = attemptFinalController.errorMessage.value;
        debugPrint('Failed to save final results: ${errorMessage.value}');
        return null; // propagate failure — don't report success
      }

      return attemptId.value;
    } on DioException catch (error) {
      errorMessage.value =
          error.response?.data?['message']?.toString() ??
          error.message ??
          'Failed to create quiz attempt';
      return null;
    } catch (error) {
      errorMessage.value = 'Failed to create quiz attempt: $error';
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
