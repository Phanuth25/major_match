import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:major_match2/core/theme/app_color.dart';
import 'package:major_match2/feature/authentications/presentations/screens/controller/register_controller.dart';

import '../../../../shared/layout/auth_shell.dart';
import '../../../../shared/utils/validators.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../../../../shared/widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key, this.onSubmit, this.onLogin});

  final void Function(String fullName, String email, String password)? onSubmit;
  final VoidCallback? onLogin;
  final ApiController controller = Get.put(ApiController());

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameFieldKey = GlobalKey<FormFieldState>();
  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _passwordFieldKey = GlobalKey<FormFieldState>();
  final _confirmPasswordFieldKey = GlobalKey<FormFieldState>();

  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;
  Uint8List? _profileImageBytes;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------

  /// Shows the "take a photo / choose from gallery" sheet and returns
  /// whichever source the user picked (or null if they dismissed it).
  Future<ImageSource?> _askForImageSource() {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _ImageSourceSheet(showCameraOption: !kIsWeb),
    );
  }

  Future<void> _pickProfileImage() async {
    final source = await _askForImageSource();
    if (source == null) return;

    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 800,
      imageQuality: 85,
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    if (!mounted) return;

    setState(() {
      _profileImage = picked;
      _profileImageBytes = bytes;
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await widget.controller.Register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      profileImageBytes: _profileImageBytes,
      profileImageFilename: _profileImage?.name,
    );

    if (!mounted) return;

    success ? _handleSuccess() : _handleFailure();
  }

  void _handleSuccess() {
    widget.onSubmit?.call(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );
    _showSnackBar(widget.controller.responseData.value);
    Get.offAllNamed('/login');
  }

  void _handleFailure() {
    final message = widget.controller.errorMessage.value.isNotEmpty
        ? widget.controller.errorMessage.value
        : 'Registration failed. Please try again.';
    _showSnackBar(message, backgroundColor: Colors.green);
  }

  void _showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: backgroundColor, content: Text(message)),
    );
  }

  // ---------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBackButton(),
            const SizedBox(height: 24),
            _buildTitle(),
            const SizedBox(height: 8),
            _buildProfileImagePicker(),
            const SizedBox(height: 24),
            _buildNameField(),
            const SizedBox(height: 16),
            _buildEmailField(),
            const SizedBox(height: 16),
            _buildPasswordField(),
            const SizedBox(height: 16),
            _buildConfirmPasswordField(),
            const SizedBox(height: 28),
            _buildSubmitButton(),
            const SizedBox(height: 20),
            _buildLoginPrompt(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      onPressed: () => Get.toNamed('/welcome'),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: const Icon(Icons.arrow_back, color: AppColors.parchment, size: 22),
    );
  }

  Widget _buildTitle() {
    return Text(
      'rw1'.tr,
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w500,
        color: AppColors.parchment,
      ),
    );
  }

  Widget _buildProfileImagePicker() {
    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap: _pickProfileImage,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: AppColors.parchment.withOpacity(0.08),
                  backgroundImage: _profileImageBytes != null
                      ? MemoryImage(_profileImageBytes!)
                      : null,
                  child: _profileImageBytes == null
                      ? Icon(
                          Icons.person,
                          size: 40,
                          color: AppColors.parchmentMuted(),
                        )
                      : null,
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'rw2'.tr,
            style: TextStyle(fontSize: 12, color: AppColors.parchmentMuted()),
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return AppTextField(
      key: _nameFieldKey,
      label: 'rw3'.tr,
      controller: _nameController,
      hintText: 'Alex Rivera',
      textInputAction: TextInputAction.next,
      validator: Validators.fullName,
      onChanged: (_) => _nameFieldKey.currentState?.validate(),
    );
  }

  Widget _buildEmailField() {
    return AppTextField(
      key: _emailFieldKey,
      label: 'Email',
      controller: _emailController,
      hintText: 'you@example.com',
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: Validators.email,
      onChanged: (_) => _emailFieldKey.currentState?.validate(),
    );
  }

  Widget _buildPasswordField() {
    return AppTextField(
      key: _passwordFieldKey,
      label: 'rw5'.tr,
      controller: _passwordController,
      hintText: 'rw52'.tr,
      obscureText: true,
      textInputAction: TextInputAction.next,
      validator: Validators.password,
      onChanged: (_) {
        _passwordFieldKey.currentState?.validate();
        // Confirm-password depends on this value, so re-check it too
        // once the user has already interacted with that field.
        if (_confirmPasswordController.text.isNotEmpty) {
          _confirmPasswordFieldKey.currentState?.validate();
        }
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return AppTextField(
      key: _confirmPasswordFieldKey,
      label: 'rw6'.tr,
      controller: _confirmPasswordController,
      hintText: 'rw62'.tr.camelCase,
      obscureText: true,
      textInputAction: TextInputAction.done,
      validator: (value) =>
          Validators.confirmPassword(value, _passwordController.text),
      onChanged: (_) => _confirmPasswordFieldKey.currentState?.validate(),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => AppPrimaryButton(
        label: widget.controller.isLoading.value
            ? 'Creating account...'
            : 'rw7'.tr,
        onPressed: widget.controller.isLoading.value ? null : _handleSubmit,
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(
            'rw8'.tr,
            style: TextStyle(fontSize: 13, color: AppColors.parchmentMuted()),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: widget.onLogin ?? () => Get.toNamed('/login'),
            child:  Text(
              'rw9'.tr,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.amber,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The "take a photo / choose from gallery" bottom sheet shown when the
/// user taps the profile picture. Kept as its own widget so it doesn't
/// clutter up the screen's build method.
class _ImageSourceSheet extends StatelessWidget {
  const _ImageSourceSheet({required this.showCameraOption});

  final bool showCameraOption;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.parchment.withOpacity(0.05),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Wrap(
          children: [
            // Live camera capture isn't meaningful on most desktop/web
            // browsers, so we only offer it on native mobile platforms.
            if (showCameraOption)
              ListTile(
                leading: const Icon(
                  Icons.photo_camera,
                  color: AppColors.parchment,
                ),
                title: const Text(
                  'Take a photo',
                  style: TextStyle(color: AppColors.parchment),
                ),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppColors.parchment,
              ),
              title: Text(
                showCameraOption ? 'Choose from gallery' : 'Choose a file',
                style: const TextStyle(color: AppColors.parchment),
              ),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }
}
