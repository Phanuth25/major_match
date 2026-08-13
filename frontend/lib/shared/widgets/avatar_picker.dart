import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:major_match2/core/theme/app_color.dart';

/// Circular "tap to add a photo" control used on the register screen.
///
/// Uses `file_picker` rather than `image_picker` because `file_picker` has
/// one API that works the same on Android, iOS, web, and desktop
/// (Windows/macOS/Linux) — `image_picker` alone doesn't cover desktop.
/// `withData: true` makes it return raw bytes even on web, where there's
/// no filesystem path to read from.
class AvatarPicker extends StatelessWidget {
  const AvatarPicker({
    super.key,
    required this.imageBytes,
    required this.onChanged,
    this.size = 96,
  });

  /// Currently selected image bytes, or null if none picked yet.
  final Uint8List? imageBytes;

  /// Called with the picked image's bytes and file name, or (null, null)
  /// if the user cancels the picker.
  final void Function(Uint8List? bytes, String? fileName) onChanged;

  final double size;

  Future<void> _pickImage() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.single;
    onChanged(file.bytes, file.name);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.fieldFill,
                border: Border.all(color: AppColors.hairline(opacity: 0.24)),
                image: imageBytes != null
                    ? DecorationImage(
                        image: MemoryImage(imageBytes!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageBytes == null
                  ? Icon(
                      Icons.person_outline,
                      size: size * 0.42,
                      color: AppColors.parchmentMuted(opacity: 0.4),
                    )
                  : null,
            ),
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.amber,
                  border: Border.all(color: AppColors.ink, width: 2),
                ),
                child: const Icon(Icons.edit, size: 14, color: AppColors.ink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
