import 'package:flutter/material.dart';
import 'package:major_match2/core/theme/app_color.dart';


/// The one amber, filled action button used across the app (per
/// docs/DECISIONS.md-style convention: one accent action per screen).
/// Shows a spinner in place of the label while [isLoading] is true, and
/// disables itself so a slow network call can't be triggered twice.
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.amber,
          disabledBackgroundColor: AppColors.amber.withOpacity(0.6),
          foregroundColor: AppColors.ink,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: AppColors.ink,
                ),
              )
            : Text(
                label,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
      ),
    );
  }
}