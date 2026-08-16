import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:major_match2/core/theme/app_color.dart';
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
              const Text(
                'Select your majors',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: AppColors.parchment),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose 2 to 5 majors you\'re curious about. We\'ll only ask questions about these.',
                style: TextStyle(fontSize: 14, height: 1.5, color: AppColors.parchmentMuted()),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: Obx(() {
                  if (widget.controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.amber));
                  }
                  if (widget.controller.errorMessage.isNotEmpty) {
                    return Center(
                      child: Text(widget.controller.errorMessage.value,
                          style: const TextStyle(color: AppColors.error)),
                    );
                  }
                  if (widget.controller.majors.isEmpty) {
                    return Center(
                      child: Text('No majors available.', style: TextStyle(color: AppColors.parchmentMuted())),
                    );
                  }

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                            color: isSelected ? AppColors.amber.withOpacity(0.12) : AppColors.fieldFill,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppColors.amber : AppColors.hairline(opacity: 0.2),
                              width: isSelected ? 1.4 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              major.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: isSelected ? AppColors.amber : AppColors.parchment,
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
              Text('${_selected.length} / 5 selected',
                  style: TextStyle(fontSize: 13, color: AppColors.parchmentMuted())),
              const SizedBox(height: 12),
              AppPrimaryButton(
                label: 'Continue',
                onPressed: canContinue ? () => Get.toNamed('/quiz', arguments: _selected.toList()) : null,
              ),
            ],
          ),
        ),
      ), 
    );
  }
}