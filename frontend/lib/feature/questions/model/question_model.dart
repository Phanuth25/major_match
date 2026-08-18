class QuestionResponse {
  final String message;
  final List<Question> questions;

  QuestionResponse({required this.message, required this.questions});

  factory QuestionResponse.fromJson(Map<String, dynamic> json) {
    final rawQuestionList = json['question'];

    return QuestionResponse(
      message: json['message'] as String? ?? '',
      questions: rawQuestionList is List
          ? rawQuestionList
                .map((item) => Question.fromJson(item as Map<String, dynamic>))
                .toList()
          : const [],
    );
  }
}

class Question {
  final int id;
  final String question;
  final int majorId;

  Question({required this.id, required this.question, required this.majorId});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int? ?? 0,
      question: json['question'] as String? ?? '',
      majorId: json['major_id'] as int? ?? 0,
    );
  }
}
