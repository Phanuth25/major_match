import 'package:flutter/material.dart';

/// Central color tokens for MajorMatch.
///
/// Palette concept: a "study at night" feel instead of the generic
/// bright-blue education-app look. Ink navy background, warm parchment
/// text, amber for the one primary action, sage for quiet accents.
class AppColors {
  AppColors._();

  static const Color ink = Color(0xFF14213D); // primary background
  static const Color inkLight = Color(0xFF1C2C50); // secondary surfaces on ink
  static const Color parchment = Color(0xFFF5EFE0); // primary text on ink
  static const Color amber = Color(0xFFE8A33D); // primary action / accent
  static const Color sage = Color(0xFF7C9885); // quiet secondary accent
  static const Color error = Color(0xFFE0776B); // validation / error states
  static const Color fieldFill = inkLight; // input/card fill on ink

  /// Parchment at reduced opacity, used for supporting/body text on ink.
  static Color parchmentMuted({double opacity = 0.6}) =>
      parchment.withValues(alpha: opacity);

  /// Hairline borders on the dark ink background.
  static Color hairline({double opacity = 0.24}) =>
      parchment.withValues(alpha: opacity);
}
