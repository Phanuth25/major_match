import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:major_match2/core/theme/app_color.dart';
import 'package:major_match2/feature/questions/presentaions/screen/quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.userName,
    required this.selectedMajors,
    required this.majorIds,
    this.recentMajor,
    this.recentScore,
    this.onStartQuiz,
  });

  final String userName;
  final List<String> selectedMajors;
  final List<int> majorIds;
  final String? recentMajor;
  final int? recentScore;
  final VoidCallback? onStartQuiz;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<int, int> _majorScores = {};

  Future<void> _startQuiz() async {
    final result = await Get.to<Map<int, int>>(
      () => QuizScreen(majorIds: widget.majorIds),
    );

    if (result != null && mounted) {
      setState(() => _majorScores = result);
    }
  }

  String _majorName(int majorId) {
    final index = widget.majorIds.indexOf(majorId);
    return index >= 0 && index < widget.selectedMajors.length
        ? widget.selectedMajors[index]
        : 'Major $majorId';
  }

  String _ordinalSuffix(int number) {
    if (number >= 11 && number <= 13) return 'th';
    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    final rankedEntries = _majorScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final hasTakenQuiz =
        _majorScores.isNotEmpty ||
        widget.recentScore != null ||
        widget.recentMajor != null;

    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.parchmentMuted(),
                        ),
                      ),
                      Text(
                        widget.userName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: AppColors.parchment,
                        ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 19,
                    backgroundColor: AppColors.fieldFill,
                    child: Icon(Icons.person, color: AppColors.parchment),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Start quiz card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.fieldFill,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.amber.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'READY WHEN YOU ARE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        color: AppColors.amber,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Take the quiz for your ${widget.selectedMajors.length} majors',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: AppColors.parchment,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: _startQuiz,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.amber,
                        foregroundColor: AppColors.ink,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(hasTakenQuiz ? 'Retake quiz' : 'Start quiz'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Selected majors
              Text(
                'YOUR MAJORS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: AppColors.parchmentMuted(),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.selectedMajors
                    .map(
                      (m) => Chip(
                        label: Text(
                          m,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.parchment,
                          ),
                        ),
                        backgroundColor: AppColors.fieldFill,
                        side: BorderSide(color: AppColors.hairline()),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 22),

              const Text(
                'MAJOR SCORES',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: AppColors.parchment,
                ),
              ),
              const SizedBox(height: 10),
              if (_majorScores.isEmpty)
                Text(
                  'Complete the quiz to see your scores.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.parchmentMuted(),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.fieldFill,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ...rankedEntries.asMap().entries.map((entry) {
                        final index = entry.key;
                        final majorEntry = entry.value;
                        final place = index + 1;

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.amber.withValues(
                                        alpha: 0.12,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '$place${_ordinalSuffix(place)}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.amber,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    _majorName(majorEntry.key),
                                    style: const TextStyle(
                                      color: AppColors.parchment,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${majorEntry.value} points',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.amber,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () {},

                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.amber,
                              foregroundColor: AppColors.ink,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            label: const Text(
                              'Save',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 22),
            ],
          ),
        ),
      ),
    );
  }
}
