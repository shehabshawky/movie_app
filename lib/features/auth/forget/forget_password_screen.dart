import 'package:flutter/material.dart';
import 'package:movie_app/core/app_Assets.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/widgets/custom_text_field.dart';
import 'package:movie_app/features/auth/presentation/controller/auth_provider.dart';
import 'package:movie_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onVerifyEmail(AuthProvider authProvider) async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await authProvider.resetPassword(_emailController.text.trim());
      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset instructions sent to your email.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.maybePop(context);
      } else if (authProvider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage!),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.yellowColor),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          locale.forgetPasswordTitle,
          style: const TextStyle(
            color: AppColors.yellowColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Illustration matching the screenshot
                Center(
                  child: Image.asset(
                    AppAssets.forgotPassword,
                    height: MediaQuery.of(context).size.height * 0.38,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 240,
                        color: AppColors.greyColor,
                        child: const Icon(
                          Icons.lock_reset,
                          color: AppColors.yellowColor,
                          size: 80,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Email TextField
                CustomTextFormField(
                  controller: _emailController,
                  hintText: locale.email,
                  prefixIconWidget: const Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value.trim())) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Verify Email Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading
                        ? null
                        : () => _onVerifyEmail(authProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellowColor,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: authProvider.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            locale.verifyEmail,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
