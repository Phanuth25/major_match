import 'package:dio/dio.dart';
import 'package:get_x/get.dart';
import 'package:major_match2/core/services/dio_client.dart';
import 'package:major_match2/core/services/local_storage.dart';
import 'package:major_match2/feature/questions/presentaions/controllers/select_controller.dart';

class AttemptFinalController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final successMessage = ''.obs;
  final finalResultId = RxnInt();
  final selectController = Get.find<SelectController>();

  /// Creates a quiz-final-result record through POST /api/attempt-final.
  Future<bool> createAttemptFinalResults() async {
    try {
      final attemptId = Get.find<StorageService>().getAttemptId();
      if (attemptId == null) {
        errorMessage.value = 'No attempt ID found';
        return false;
      }
      isLoading.value = true;
      for (final entry in selectController.rawMajorScores.entries) {
        final response = await ApiClient.instance.post(
          '/attempt-final',
          data: {
            'quiz_attempt_id': attemptId,
            'major_id': entry.key,
            'score': entry.value.toDouble(),
          },
        );

        if (response.statusCode != 201) {
          errorMessage.value =
              response.data?['message']?.toString() ??
              'Failed to save quiz final result';
          return false;
        }
      }

      successMessage.value = 'Quiz final results saved successfully';
      return true;
    } on DioException catch (error) {
      errorMessage.value =
          error.response?.data?['message']?.toString() ??
          error.message ??
          'Failed to save quiz final results';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
