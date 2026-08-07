import 'package:flutter/material.dart';
import 'package:major_match2/core/theme/app_color.dart';

import '../widgets/compass_widget.dart';

/// The first screen a student sees.
///
/// Responsive strategy:
/// - < 600px  (phone):            single column, content fills width.
/// - 600–899px (tablet / small web): single column, but capped to a
///   comfortable reading width and centered, so it doesn't stretch edge
///   to edge on a tablet or a resized browser window.
/// - >= 900px (desktop / wide web): two-column layout — compass on the
///   left, copy and actions on the right — so the screen doesn't look
///   like a stretched phone screen on a large display.
///
/// The whole thing sits inside a SafeArea + SingleChildScrollView so it
/// never overflows on short screens (e.g. a phone in landscape) and
/// respects notches/status bars on iOS and Android.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    this.onGetStarted,
    this.onLogin,
  });

  /// Called when the student taps "Get started". Wire this to the
  /// major-selection route once that screen exists.
  final VoidCallback? onGetStarted;

  /// Called when the student taps "I already have an account". Wire this
  /// to the login route once that screen exists.
  final VoidCallback? onLogin;

  static const double _wideBreakpoint = 900;
  static const double _tabletBreakpoint = 600;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth >= _wideBreakpoint;
            final bool isTablet = constraints.maxWidth >= _tabletBreakpoint;

            final double horizontalPadding = isTablet ? 40 : 24;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWide ? 960 : 440,
                    ),
                    child: isWide
                        ? _WideLayout(
                            onGetStarted: onGetStarted,
                            onLogin: onLogin,
                          )
                        : _NarrowLayout(
                            onGetStarted: onGetStarted,
                            onLogin: onLogin,
                          ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Phone and tablet layout: everything stacked in one column.
class _NarrowLayout extends StatelessWidget {
  const _NarrowLayout({this.onGetStarted, this.onLogin});

  final VoidCallback? onGetStarted;
  final VoidCallback? onLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _Eyebrow(),
        const SizedBox(height: 24),
        const CompassWidget(size: 176),
        const SizedBox(height: 24),
        const _Headline(fontSize: 26),
        const SizedBox(height: 32),
        _Actions(onGetStarted: onGetStarted, onLogin: onLogin),
      ],
    );
  }
}

/// Desktop and wide-web layout: compass and copy sit side by side so the
/// screen uses the extra horizontal space instead of just centering a
/// narrow phone-shaped column in the middle of the page.
class _WideLayout extends StatelessWidget {
  const _WideLayout({this.onGetStarted, this.onLogin});

  final VoidCallback? onGetStarted;
  final VoidCallback? onLogin;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _Eyebrow(),
              SizedBox(height: 32),
              CompassWidget(size: 240),
            ],
          ),
        ),
        const SizedBox(width: 64),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const _Headline(fontSize: 34, alignStart: true),
              const SizedBox(height: 32),
              _Actions(
                onGetStarted: onGetStarted,
                onLogin: onLogin,
                alignStart: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow();

  @override
  Widget build(BuildContext context) {
    return Text(
      'MAJORMATCH',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 12,
        letterSpacing: 2,
        color: AppColors.sage,
      ),
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline({required this.fontSize, this.alignStart = false});

  final double fontSize;
  final bool alignStart;

  @override
  Widget build(BuildContext context) {
    final TextAlign align = alignStart ? TextAlign.left : TextAlign.center;
    return Column(
      crossAxisAlignment:
          alignStart ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          'Find the major\nthat fits you.',
          textAlign: align,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            height: 1.3,
            color: AppColors.parchment,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Pick a few majors you're curious about. Answer a short quiz. "
          'See which one actually fits.',
          textAlign: align,
          style: TextStyle(
            fontSize: 14,
            height: 1.6,
            color: AppColors.parchmentMuted(),
          ),
        ),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({
    this.onGetStarted,
    this.onLogin,
    this.alignStart = false,
  });

  final VoidCallback? onGetStarted;
  final VoidCallback? onLogin;
  final bool alignStart;

  @override
  Widget build(BuildContext context) {
    final Widget buttons = Column(
      crossAxisAlignment:
          alignStart ? CrossAxisAlignment.start : CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: onGetStarted,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.amber,
              foregroundColor: AppColors.ink,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Get started',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 48,
          child: OutlinedButton(
            onPressed: onLogin,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.parchment,
              side: BorderSide(color: AppColors.hairline()),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'I already have an account',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );

    // Cap button width so they don't stretch edge-to-edge on wide/desktop
    // screens while still filling the column on phone.
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: buttons,
    );
  }
}