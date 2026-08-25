import 'package:dio/dio.dart';
import 'package:get_x/get.dart';
import 'package:major_match2/core/services/dio_client.dart';
import 'package:major_match2/core/services/local_storage.dart';

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
            response.data?['message']?.toString() ?? 'Failed to create quiz attempt';
        return null;
      }

      final id = response.data['attempt_id'];
      attemptId.value = id is int ? id : int.tryParse(id.toString());
      successMessage.value =
          response.data['message']?.toString() ?? 'Quiz attempt created successfully';
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
