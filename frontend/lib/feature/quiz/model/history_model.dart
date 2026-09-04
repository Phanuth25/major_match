class QuizResultModel {
  final String message;
  final List<QuizAttemptResult> results;

  QuizResultModel({required this.message, required this.results});

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      message: json['message'] as String? ?? '',
      results: (json['results'] as List<dynamic>?)
              ?.map((item) =>
                  QuizAttemptResult.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'results': results.map((e) => e.toJson()).toList(),
    };
  }
}

class QuizAttemptResult {
  final int quizAttemptId;
  final int userId;
  final int majorId;
  final DateTime? startedAt;
  final String majorName;
  final double score;

  QuizAttemptResult({
    required this.quizAttemptId,
    required this.userId,
    required this.majorId,
    required this.startedAt,
    required this.majorName,
    required this.score,
  });

  factory QuizAttemptResult.fromJson(Map<String, dynamic> json) {
    return QuizAttemptResult(
      quizAttemptId: json['quiz_attempt_id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      majorId: json['major_id'] as int? ?? 0,
      startedAt: json['started_at'] != null
          ? DateTime.tryParse(json['started_at'] as String)
          : null,
      majorName: json['major_name'] as String? ?? '',
      score: double.tryParse(json['score']?.toString() ?? '') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quiz_attempt_id': quizAttemptId,
      'user_id': userId,
      'major_id': majorId,
      'started_at': startedAt?.toIso8601String(),
      'major_name': majorName,
      'score': score,
    };
  }
}