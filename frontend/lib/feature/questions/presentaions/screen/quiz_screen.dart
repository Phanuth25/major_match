import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:major_match2/core/theme/app_color.dart';
import 'package:major_match2/feature/questions/model/question_model.dart';
import 'package:major_match2/feature/questions/presentaions/controllers/question_controller.dart';
import 'package:major_match2/feature/questions/presentaions/controllers/select_controller.dart';
import '../../../../shared/widgets/app_primary_button.dart';

// Fixed answer scale (docs/MEMORY.md): Strongly Agree=5, Agree=4,
// Neutral=1, Disagree=0, Strongly Disagree=0.
const Map<String, int> kAnswerScale = {
  'Strongly Disagree': 0,
  'Disagree': 0,
  'Neutral': 1,
  'Agree': 4,
  'Strongly Agree': 5,
};

class QuizScreen extends StatefulWidget {
  QuizScreen({super.key, required this.majorIds});

  final List<int> majorIds;
final QuestionController controller = Get.find<QuestionController>();
final SelectController scoreController = Get.find<SelectController>();

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  /* BEGIN: sequential major quiz changes */
  final List<Question> _currentQuestions = [];
  final Map<int, String> _answers = {}; // questionId -> chosen label
  int _currentMajorIndex = 0;
  bool _isLoading = true;
  int _elapsedSeconds = 0;
  Timer? _quizTimer;
  late final DateTime _startedAt;

  @override
  void initState() {
    super.initState();
    _startedAt = DateTime.now();
    _startQuizTimer();
    _loadCurrentMajor();
  }

  @override
  void dispose() {
    _quizTimer?.cancel();
    super.dispose();
  }

  void _startQuizTimer() {
    _quizTimer?.cancel();
    _quizTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _elapsedSeconds++);
    });
  }

  String get _formattedElapsedTime {
    final minutes = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _loadCurrentMajor() async {
    if (widget.majorIds.isEmpty) {
      if (mounted) {
        Navigator.pop(context, (<int, int>{}, 0));
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _currentQuestions.clear();
    });

    final majorId = widget.majorIds[_currentMajorIndex];
    await widget.controller.fetchQuestionById(majorId);

    if (!mounted) return;

    setState(() {
      _currentQuestions.addAll(widget.controller.questions);
      _isLoading = false;
    });
  }

  bool get _currentMajorAnswered =>
      _currentQuestions.every((question) => _answers.containsKey(question.id));

  Future<void> _submitCurrentMajor() async {
    if (_currentMajorIndex < widget.majorIds.length - 1) {
      setState(() {
        _currentMajorIndex++;
      });
      await _loadCurrentMajor();
      return;
    }
    //here we are at the last major, so we submit the scores
    final scores = _answers.map(
      (questionId, label) => MapEntry(questionId, kAnswerScale[label]!),
    );
    debugPrint('Final scores: $scores');

    setState(() => _isLoading = true);
    _quizTimer?.cancel();

    final majorScores = await widget.scoreController.submitScores(
      questionIds: scores.keys.toList(),
      scores: scores,
      elapsedSeconds: _elapsedSeconds,
    );

    if (!mounted) return;

    if (majorScores == null) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.scoreController.errorMessage.value)),
      );
      return;
    }

    Navigator.pop(context, (majorScores, _elapsedSeconds));
  }
  /* END: sequential major quiz changes */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.amber),
              )
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Answer honestly',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: AppColors.parchment,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'There are no right or wrong answers.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.parchmentMuted(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    /* BEGIN: sequential major quiz changes */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Major ${_currentMajorIndex + 1} of ${widget.majorIds.length}',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.parchmentMuted(),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.fieldFill,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.amber.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            'Time: $_formattedElapsedTime',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.amber,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    /* END: sequential major quiz changes */
                    Expanded(
                      child: ListView.separated(
                        /* BEGIN: sequential major quiz changes */
                        itemCount: _currentQuestions.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          final question = _currentQuestions[index];
                          return _QuestionCard(
                            question: question.question,
                            selectedLabel: _answers[question.id],
                            onSelect: (label) =>
                                setState(() => _answers[question.id] = label),
                          );
                        },
                        /* END: sequential major quiz changes */
                      ),
                    ),

                    const SizedBox(height: 12),
                    /* BEGIN: sequential major quiz changes */
                    AppPrimaryButton(
                      label: _currentMajorIndex == widget.majorIds.length - 1
                          ? 'Submit'
                          : 'Next major',
                      onPressed: _currentMajorAnswered
                          ? _submitCurrentMajor
                          : null,
                    ),
                    /* END: sequential major quiz changes */
                  ],
                ),
              ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.selectedLabel,
    required this.onSelect,
  });

  final String question;
  final String? selectedLabel;
  final void Function(String label) onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.parchment,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: kAnswerScale.keys.map((label) {
              final isSelected = selectedLabel == label;
              return ChoiceChip(
                label: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? AppColors.ink : AppColors.parchment,
                  ),
                ),
                selected: isSelected,
                onSelected: (_) => onSelect(label),
                backgroundColor: AppColors.ink,
                selectedColor: AppColors.amber,
                side: BorderSide(color: AppColors.hairline()),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
