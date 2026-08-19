import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:major_match2/core/theme/app_color.dart';
import 'package:major_match2/feature/questions/presentaions/screen/quiz_screen.dart';

class HomeScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                        userName,
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
                  border: Border.all(color: AppColors.amber.withOpacity(0.3)),
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
                      'Take the quiz for your ${selectedMajors.length} majors',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: AppColors.parchment,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: () =>
                          Get.to(() => QuizScreen(majorIds: majorIds)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.amber,
                        foregroundColor: AppColors.ink,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Start quiz'),
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
                children: selectedMajors
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

              // Recent result
              Text(
                'RECENT RESULT',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: AppColors.parchmentMuted(),
                ),
              ),
              const SizedBox(height: 10),
              if (recentMajor == null)
                Text(
                  'No quiz results yet.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.parchmentMuted(),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.fieldFill,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        recentMajor!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.parchment,
                        ),
                      ),
                      Text(
                        '$recentScore%',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
