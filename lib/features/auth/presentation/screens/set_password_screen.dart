import 'package:cdip_connect/core/services/localization_service.dart';
import 'package:cdip_connect/core/utils/app_navigation.dart';
import 'package:cdip_connect/core/utils/app_toast.dart';
import 'package:cdip_connect/core/utils/app_validators.dart';
import 'package:cdip_connect/features/auth/application/auth_service.dart';
import 'package:cdip_connect/features/auth/data/services/api_service.dart';
import 'package:cdip_connect/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:cdip_connect/shared/widgets/password_guideline_checklist.dart';
import 'package:flutter/material.dart';
import 'package:cdip_connect/shared/widgets/pre_auth_branding.dart';
import 'package:cdip_connect/shared/widgets/app_back_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SetPasswordScreen extends ConsumerStatefulWidget {
  final String phone;
  final String verifiedToken;

  const SetPasswordScreen({
    super.key,
    required this.phone,
    required this.verifiedToken,
  });

  @override
  ConsumerState<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends ConsumerState<SetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorText;

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final validationMessage = AppValidators.newPassword(_passwordController.text);
    if (validationMessage != null) {
      setState(() => _errorText = validationMessage);
      AppToast.showError(validationMessage);
      return;
    }

    if (widget.verifiedToken.trim().isEmpty) {
      const error = 'Your verification token is missing. Please verify OTP again.';
      setState(() => _errorText = error);
      AppToast.showError(error);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final response = await ref.read(authProvider.notifier).setPassword(
            phone: widget.phone,
            password: _passwordController.text.trim(),
            verifiedToken: widget.verifiedToken,
          );

      if (ApiService.isSuccess(response)) {
        AppToast.showSuccess('Password set successfully. Please sign in.');

        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          AppNavigation.smoothRoute(
            builder: (context) => SignInScreen(phone: widget.phone),
          ),
          (route) => false,
        );
      } else {
        final error = ApiService.messageOf(response, fallback: 'Password setup failed.');
        if (!mounted) return;
        setState(() => _errorText = error);
        AppToast.showError(error);
      }
    } catch (_) {
      const error = 'Network error occurred. Please try again.';
      if (!mounted) return;
      setState(() => _errorText = error);
      AppToast.showError(error);
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations(ref.watch(localizationProvider));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppBackButton(onTap: () => Navigator.pop(context)),
                              const PreAuthBranding(
                                logoWidth: 52,
                                logoHeight: 42,
                                buttonWidth: 81,
                                buttonHeight: 39,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            t.setPassword,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                                                            fontWeight: FontWeight.w500,
                              height: 1.13,
                            ),
                          ),
                          const SizedBox(height: 34),
                          Text(
                            t.typePassword,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                                                            fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 48,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 1, color: Color(0xFF0080C6)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _passwordController,
                                    obscureText: !_isPasswordVisible,
                                    onChanged: (_) {
                                      if (_errorText != null) setState(() => _errorText = null);
                                      setState(() {});
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Enter your password',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(left: 20, right: 8, bottom: 2),
                                    ),
                                    style: const TextStyle(
                                      color: Color(0xFF3A3A3A),
                                      fontSize: 16,
                                                                            fontWeight: FontWeight.w600,
                                      height: 1.25,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: GestureDetector(
                                    onTap: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                                    child: Icon(
                                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                      color: const Color(0xFF0080C6),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          PasswordGuidelineChecklist(
                            password: _passwordController.text,
                          ),
                          if (_errorText != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              _errorText!,
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ],
                          const SizedBox(height: 24),
                          GestureDetector(
                            onTap: _isLoading ? null : _submit,
                            child: _GradientButton(
                              label: t.proceed,
                              isLoading: _isLoading,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final bool isLoading;

  const _GradientButton({
    required this.label,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 49,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: const Alignment(-0.00, 0.07),
          end: const Alignment(1.00, 0.91),
          colors: isLoading
              ? [Colors.grey, Colors.grey]
              : [const Color(0xFF21409A), const Color(0xFF0080C6)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 15,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                                    fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
