import 'dart:async';
import 'package:flutter/material.dart';
import 'package:major_match2/core/theme/app_color.dart';

/// A simple auto-sliding + swipeable carousel of majors.
/// Pass in the major names; images can be wired in later.
class MajorSlider extends StatefulWidget {
  const MajorSlider({
    super.key,
    required this.majors,
    this.height = 150,
    this.autoSlideDuration = const Duration(seconds: 4),
  });

  final List<String> majors;
  final double height;
  final Duration autoSlideDuration;

  @override
  State<MajorSlider> createState() => _MajorSliderState();
}

class _MajorSliderState extends State<MajorSlider> {
  final PageController _controller = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(widget.autoSlideDuration, (_) {
      if (!_controller.hasClients || widget.majors.isEmpty) return;

      final nextPage = (_currentPage + 1) % widget.majors.length;
      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void _resetAutoSlide() {
    _timer?.cancel();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.majors.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.majors.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              _resetAutoSlide(); // restart timer after a manual swipe
            },
            itemBuilder: (context, index) {
              return _MajorCard(
                name: widget.majors[index],
                page: index + 1,
                total: widget.majors.length,
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.majors.length, (index) {
            final isActive = index == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 18 : 5,
              height: 5,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.amber
                    : AppColors.parchment.withOpacity(0.25),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _MajorCard extends StatelessWidget {
  const _MajorCard({
    required this.name,
    required this.page,
    required this.total,
  });

  final String name;
  final int page;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.fieldFill, AppColors.ink],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 14,
            bottom: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MAJOR',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    color: AppColors.amber,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.parchment,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$page/$total',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.parchment,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
