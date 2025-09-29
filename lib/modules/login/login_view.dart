import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';
import '../../helpers/image_paths.dart';
import '../../helpers/widgets/app_text_field.dart';
import '../../helpers/widgets/primary_button.dart';
import '../../helpers/colors/app_colors.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with logo
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 390 / 240,
                  child: Image.asset(ImagePaths.frame, fit: BoxFit.cover),
                ),
                Positioned.fill(
                  child: Center(
                    child: Image.asset(
                      ImagePaths.logo,
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),

            // Form section with proper keyboard handling
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Login Or Register To Book Your Appointments',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),

                      AppTextField(
                        controller: controller.usernameController,
                        label: 'Username',
                        hint: 'Enter your username',
                        keyboardType: TextInputType.text,
                        validator: controller.validateUsername,
                      ),
                      const SizedBox(height: 12),
                      Obx(
                        () => AppTextField(
                          controller: controller.passwordController,
                          label: 'Password',
                          hint: 'Enter password',
                          obscureText: controller.isPasswordHidden.value,
                          validator: controller.validatePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordHidden.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => PrimaryButton(
                          label: controller.isLoading.value
                              ? 'Logging in...'
                              : 'Login',
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.submit,
                        ),
                      ),
                      const SizedBox(height: 180),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20,
                          left: 16,
                          right: 16,
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              'By creating or logging into an account you are agreeing with our ',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.black54),
                              textAlign: TextAlign.center,
                            ),
                            GestureDetector(
                              onTap: () {
                                //
                              },
                              child: Text(
                                'Terms and Conditions',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppColors.link,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            Text(
                              ' and ',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.black54),
                            ),
                            GestureDetector(
                              onTap: () {
                                //
                              },
                              child: Text(
                                'Privacy Policy',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppColors.link,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            Text(
                              '.',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer with terms and conditions
          ],
        ),
      ),
    );
  }
}
