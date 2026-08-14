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
  final LoginController controller = Get.put(LoginController());

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
      Get.offAllNamed('/select'); // Navigate to the select screen after successful login
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
              onPressed: () => Navigator.maybeOf(context)?.maybePop(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.arrow_back, color: AppColors.parchment, size: 22),
            ),
            const SizedBox(height: 24),
            const Text(
              'Welcome back',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: AppColors.parchment),
            ),
            const SizedBox(height: 8),
            Text(
              'Log in to see your saved recommendations.',
              style: TextStyle(fontSize: 14, height: 1.5, color: AppColors.parchmentMuted()),
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
              hintText: 'Enter your password',
              obscureText: true,
              textInputAction: TextInputAction.done,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Enter your password.' : null,
              onChanged: (_) => _passwordFieldKey.currentState?.validate(),
            ),

            Obx(() {
              final error = widget.controller.errormessage.value;
              if (error.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(error, style: const TextStyle(color: AppColors.error, fontSize: 13)),
              );
            }),

            const SizedBox(height: 28),
            Obx(() => AppPrimaryButton(
                  label: widget.controller.isLoading.value ? 'Logging in...' : 'Log in',
                  onPressed: widget.controller.isLoading.value ? null : _handleSubmit,
                )),
            const SizedBox(height: 20),

            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text("Don't have an account? ", style: TextStyle(fontSize: 13, color: AppColors.parchmentMuted())),
                  GestureDetector(
                    onTap: widget.onRegister,
                    child: const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.amber),
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