import 'package:flutter/material.dart';
import 'package:major_match2/core/theme/app_color.dart';
import 'package:major_match2/feature/welcome/presentations/widgets/compass_widget.dart';

/// Responsive wrapper shared by every auth screen (register, login, ...).
///
/// - < 900px (phone / tablet / narrow web): a single scrollable column,
///   just the form content, full width up to a comfortable reading cap.
/// - >= 900px (desktop / wide web): a two-pane layout — a quiet brand
///   panel with the compass on the left, the form on the right — so the
///   screen doesn't look like a stretched phone form on a large display.
///
/// Also handles the back button and keyboard-safe scrolling so each auth
/// screen only has to provide its own [content].
class AuthShell extends StatefulWidget {
  const AuthShell({
    super.key,
    required this.content,
    this.brandHeadline = 'Find the major\nthat fits you.',
  });

  final Widget content;
  final String brandHeadline;

  static const double _wideBreakpoint = 900;

  @override
  State<AuthShell> createState() => _AuthShellState();
}

class _AuthShellState extends State<AuthShell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide =
                constraints.maxWidth >= AuthShell._wideBreakpoint;

            if (isWide) {
              return Row(
                children: [
                  Expanded(
                    child: Container(
                      color: AppColors.inkLight,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(48),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CompassWidget(size: 200),
                          const SizedBox(height: 32),
                          Text(
                            widget.brandHeadline,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                              color: AppColors.parchment,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 32,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: widget.content,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: widget.content,
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
