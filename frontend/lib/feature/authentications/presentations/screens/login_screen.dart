import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:major_match2/core/theme/app_color.dart';
import 'package:major_match2/feature/authentications/presentations/screens/controller/login_controller.dart';

import '../../../../shared/layout/auth_shell.dart';
import '../../../../shared/utils/validators.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../../../../shared/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key, this.onRegister});

  final VoidCallback? onRegister;
  final LoginController controller = Get.find<LoginController>();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _passwordFieldKey = GlobalKey<FormFieldState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await widget.controller.Login(
      name: '',
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      Get.snackbar(
        'Success',
        widget.controller.successmessage.value,
        snackPosition: SnackPosition.values.last,
        backgroundColor: AppColors.amber,
        colorText: Colors.white,
      );
      // Navigate to the select screen after successful login
      Get.toNamed('/select');
    } else {
      Get.snackbar(
        'Error',
        widget.controller.errormessage.value,
        snackPosition: SnackPosition.values.last,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => Get.toNamed('/welcome'),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.parchment,
                size: 22,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'lw1'.tr,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
                color: AppColors.parchment,
              ),
            ),
            const SizedBox(height: 28),

            AppTextField(
              key: _emailFieldKey,
              label: 'Email',
              controller: _emailController,
              hintText: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: Validators.email,
              onChanged: (_) => _emailFieldKey.currentState?.validate(),
            ),
            const SizedBox(height: 16),

            AppTextField(
              key: _passwordFieldKey,
              label: 'Password',
              controller: _passwordController,
              hintText: 'lw6'.tr,
              obscureText: true,
              textInputAction: TextInputAction.done,
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Enter your password.'
                  : null,
              onChanged: (_) => _passwordFieldKey.currentState?.validate(),
            ),

            Obx(() {
              final error = widget.controller.errormessage.value;
              if (error.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  error,
                  style: const TextStyle(color: AppColors.error, fontSize: 13),
                ),
              );
            }),

            const SizedBox(height: 28),
            Obx(
              () => AppPrimaryButton(
                label: widget.controller.isLoading.value ? 'lw3'.tr : 'lw2'.tr,
                onPressed: widget.controller.isLoading.value
                    ? null
                    : _handleSubmit,
              ),
            ),
            const SizedBox(height: 20),

            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    "lw4".tr,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.parchmentMuted(),
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => Get.offAndToNamed('/register'),
                    child: Text(
                      'lw5'.tr,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
