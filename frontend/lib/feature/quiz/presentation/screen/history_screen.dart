import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:major_match2/feature/quiz/presentation/controller/history_controller.dart';

const int kMaxScore = 25;

class QuizHistoryTestScreen extends StatelessWidget {
  final controller = Get.put(QuizHistoryController());

  QuizHistoryTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz History'),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text('Error: ${controller.errorMessage.value}'));
        }
        if (controller.results.isEmpty) {
          return const Center(child: Text('No quiz history yet.'));
        }

        final grouped = controller.groupedByAttempt;
        final attemptIds = grouped.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          itemCount: attemptIds.length,
          itemBuilder: (context, index) {
            final attemptId = attemptIds[index];
            final items = grouped[attemptId]!;

            return _AttemptCard(attemptId: attemptId, items: items);
          },
        );
      }),
    );
  }
}

class _AttemptCard extends StatelessWidget {
  final int attemptId;
  final List<dynamic> items; // List<QuizAttemptResult>

  const _AttemptCard({required this.attemptId, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        // ignore: deprecated_member_use
        border: Border.all(color: Colors.yellow.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attempt $attemptId',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 20,
            runSpacing: 12,
            children: items
                .map(
                  (r) => _ScoreRing(
                    label: r.majorName as String,
                    score: (r.score as num).toDouble(),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  final String label;
  final double score;

  const _ScoreRing({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    final progress = (score / kMaxScore).clamp(0.0, 1.0);

    return Column(
      children: [
        SizedBox(
          width: 56,
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 5,
                  backgroundColor: Colors.grey.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Text(
                score.toInt().toString(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 64,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
