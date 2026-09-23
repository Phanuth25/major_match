import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:major_match2/core/theme/app_color.dart';
import 'package:major_match2/core/services/local_storage.dart';
import 'package:major_match2/feature/major/presentation/controller/select_controller.dart';

import '../../../../shared/widgets/app_primary_button.dart';

class Select extends StatefulWidget {
  Select({super.key});

  final MajorController controller = Get.put(MajorController());

  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> {
  final Set<String> _selected = {};

  @override
  void initState() {
    super.initState();
    _loadSavedSelection();
  }

  void _loadSavedSelection() {
    final savedMajors = Get.find<StorageService>().getSelectedMajors();
    if (savedMajors.isNotEmpty) {
      setState(() {
        _selected
          ..clear()
          ..addAll(savedMajors);
      });
    }
  }

  void _toggle(String name) {
    setState(() {
      if (_selected.contains(name)) {
        _selected.remove(name);
      } else if (_selected.length < 5) {
        _selected.add(name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = _selected.length >= 2 && _selected.length <= 5;

    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'sw1'.tr,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: AppColors.parchment,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'sw2'.tr,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.parchmentMuted(),
                ),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: Obx(() {
                  if (widget.controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.amber),
                    );
                  }
                  if (widget.controller.errorMessage.isNotEmpty) {
                    return Center(
                      child: Text(
                        widget.controller.errorMessage.value,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    );
                  }
                  if (widget.controller.majors.isEmpty) {
                    return Center(
                      child: Text(
                        'No majors available.',
                        style: TextStyle(color: AppColors.parchmentMuted()),
                      ),
                    );
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: widget.controller.majors.length,
                    itemBuilder: (context, index) {
                      final major = widget.controller.majors[index];
                      final bool isSelected = _selected.contains(major.name);
                      return GestureDetector(
                        onTap: () => _toggle(major.name),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.amber.withOpacity(0.12)
                                : AppColors.fieldFill,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.amber
                                  : AppColors.hairline(opacity: 0.2),
                              width: isSelected ? 1.4 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              major.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? AppColors.amber
                                    : AppColors.parchment,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),

              const SizedBox(height: 16),
              Text(
                '${_selected.length} / ${widget.controller.majors.length}',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.parchmentMuted(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppPrimaryButton(
                    label: 'sw3'.tr,
                    onPressed: canContinue
                        ? () async {
                            final selectedMajorIds = widget.controller.majors
                                .where(
                                  (major) => _selected.contains(major.name),
                                )
                                .map((major) => major.id)
                                .toList();
                            await Get.find<StorageService>().saveSelectedMajors(
                              _selected,
                            );
                            await Get.find<StorageService>()
                                .saveSelectedMajorIds(selectedMajorIds);
                            Get.offNamed(
                              '/home',
                              arguments: {
                                'names': _selected.toList(),
                                'ids': selectedMajorIds,
                              },
                            );
                          }
                        : null,
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      await Get.find<StorageService>().saveSelectedMajors({});
                      await Get.find<StorageService>().saveSelectedMajorIds([]);
                      Get.offNamed(
                        '/home',
                        arguments: {'names': <String>[], 'ids': <int>[]},
                      );
                    },
                    label: Text(
                      'sw4'.tr,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.amber,
                      ),
                    ),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
