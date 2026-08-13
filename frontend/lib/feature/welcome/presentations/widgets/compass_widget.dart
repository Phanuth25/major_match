import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:major_match2/core/theme/app_color.dart';


/// The compass that "settles" on a matched major.
///
/// This is MajorMatch's signature visual: a needle finds its direction
/// while three orbiting tags (representing the majors a student picked)
/// sit around the dial. It's reused conceptually on the results screen
/// later, so keep the visual language (dial + needle + tag) consistent.
class CompassWidget extends StatefulWidget {
  const CompassWidget({
    super.key,
    required this.size,
    this.tags = const ['CS', 'IT', 'SE'],
  });

  /// Outer diameter of the compass. Callers scale this for responsiveness.
  final double size;

  /// Short labels shown orbiting the dial (2-5 majors per MVP scope).
  final List<String> tags;

  @override
  State<CompassWidget> createState() => _CompassWidgetState();
}

class _CompassWidgetState extends State<CompassWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _needleAngle;

  static const double _restingAngleDegrees = 28;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _needleAngle = Tween<double>(
      begin: -70 * math.pi / 180,
      end: _restingAngleDegrees * math.pi / 180,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double outer = widget.size;
    final double inner = outer * 0.66;

    return SizedBox(
      width: outer,
      height: outer,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          Container(
            width: outer,
            height: outer,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.hairline(opacity: 0.18)),
            ),
          ),
          // Inner ring + needle
          Container(
            width: inner,
            height: inner,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.hairline(opacity: 0.28)),
            ),
            child: AnimatedBuilder(
              animation: _needleAngle,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(inner, inner),
                  painter: _NeedlePainter(angle: _needleAngle.value),
                );
              },
            ),
          ),
          // Orbiting major tags
          for (final entry in widget.tags.asMap().entries)
            _OrbitTag(
              label: entry.value,
              index: entry.key,
              count: widget.tags.length,
              compassSize: outer,
            ),
        ],
      ),
    );
  }
}

class _NeedlePainter extends CustomPainter {
  _NeedlePainter({required this.angle});

  final double angle;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double length = size.height * 0.38;

    final Offset tip = Offset(
      center.dx + length * math.sin(angle),
      center.dy - length * math.cos(angle),
    );

    final Paint linePaint = Paint()
      ..color = AppColors.amber
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, tip, linePaint);

    final Paint dotPaint = Paint()..color = AppColors.amber;
    canvas.drawCircle(center, 3, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _NeedlePainter oldDelegate) =>
      oldDelegate.angle != angle;
}

/// Places up to a handful of tags evenly around the compass rim.
class _OrbitTag extends StatelessWidget {
  const _OrbitTag({
    required this.label,
    required this.index,
    required this.count,
    required this.compassSize,
  });

  final String label;
  final int index;
  final int count;
  final double compassSize;

  @override
  Widget build(BuildContext context) {
    // Spread tags evenly starting from the top, going clockwise.
    final double angle = (-math.pi / 2) + (2 * math.pi * index / count);
    final double radius = compassSize / 2;
    final Offset offset = Offset(
      radius * math.cos(angle),
      radius * math.sin(angle),
    );

    return Transform.translate(
      offset: offset,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.hairline(opacity: 0.28)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 10,
            letterSpacing: 0.5,
            color: AppColors.parchment,
          ),
        ),
      ),
    );
  }
}