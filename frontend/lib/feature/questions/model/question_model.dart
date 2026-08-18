class QuestionResponse {
  final String message;
  final List<Question> questions;

  QuestionResponse({
    required this.message,
    required this.questions,
  });

  factory QuestionResponse.fromJson(Map<String, dynamic> json) {
    return QuestionResponse(
      message: json['message'],
      questions: (json['question'] as List)
          .map((item) => Question.fromJson(item))
          .toList(),
    );
  }
}

class Question {
  final int id;
  final String question;
  final int majorId;

  Question({
    required this.id,
    required this.question,
    required this.majorId,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      majorId: json['major_id'],
    );
  }
}