import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_x/get.dart';
import 'package:major_match2/core/services/dio_client.dart';

class SelectController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final successMessage = ''.obs;

  Future<Map<int, int>?> submitScores({
    required List<int> questionIds,
    required Map<int, int> scores,
    required int elapsedSeconds,
  }) async {
    if (questionIds.isEmpty) {
      errorMessage('Question IDs are required');
      return null;
    }

    try {
      isLoading(true);
      errorMessage('');
      successMessage('');
      final response = await ApiClient.instance.post(
        '/selectq',
        data: {
          'ids': questionIds,
          'scores': scores.map(
            (questionId, score) => MapEntry(questionId.toString(), score),
          ),
          'elapsed_seconds': elapsedSeconds,
          'time_taken_seconds': elapsedSeconds,
        },
      );

      final rawMajorScores = response.data['major_scores'];
      if (response.statusCode != 200 || rawMajorScores is! Map) {
        errorMessage('Failed to calculate major scores');
        return null;
      }
      debugPrint('Major scores calculated: $rawMajorScores');
      successMessage('Major scores calculated successfully');
      return rawMajorScores.map(
        (majorId, score) =>
            MapEntry(int.parse(majorId.toString()), (score as num).toInt()),
      );
    } on DioException catch (error) {
      errorMessage(
        error.response?.data?['message']?.toString() ??
            error.message ??
            'Failed to submit scores',
      );
      return null;
    } catch (error) {
      errorMessage('Failed to submit scores: $error');
      return null;
    } finally {
      isLoading(false);
    }
  }
}
