import 'package:cdip_connect/core/services/localization_service.dart';
import 'package:cdip_connect/core/utils/app_toast.dart';
import 'package:cdip_connect/core/utils/app_theme.dart';
import 'package:cdip_connect/core/utils/app_validators.dart';
import 'package:cdip_connect/features/auth/application/auth_flow.dart';
import 'package:cdip_connect/features/auth/application/auth_service.dart';
import 'package:cdip_connect/features/auth/data/services/api_service.dart';
import 'package:cdip_connect/features/auth/presentation/screens/otp_screen.dart';
import 'package:cdip_connect/features/auth/presentation/screens/password_reset_popup.dart';
import 'package:cdip_connect/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:cdip_connect/shared/widgets/pre_auth_branding.dart';
import 'package:cdip_connect/shared/widgets/app_back_button.dart';
import 'package:cdip_connect/shared/widgets/password_guideline_checklist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cdip_connect/core/utils/app_navigation.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final ResetPasswordMode mode;
  final String initialPhone;
  final String verifiedToken;

  const ResetPasswordScreen({
    super.key,
    this.mode = ResetPasswordMode.requestOtp,
    this.initialPhone = '',
    this.verifiedToken = '',
  });

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.initialPhone;
  }

  Future<void> _sendOtp() async {
    FocusScope.of(context).unfocus();

    final phone = _phoneController.text.trim();
    final validationMessage = AppValidators.bangladeshPhone(phone);
    if (validationMessage != null) {
      setState(() => _errorText = validationMessage);
      AppToast.showError(validationMessage);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final response = await ref.read(authProvider.notifier).sendOtp(phone);

      if (ApiService.isSuccess(response)) {
        AppToast.showSuccess('OTP sent successfully. Please check your phone.');

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          AppNavigation.smoothRoute(
            builder: (context) => OTPScreen(
              phone: phone,
              flow: OtpFlow.forgotPassword,
            ),
          ),
        );
      } else {
        final error =
            ApiService.messageOf(response, fallback: 'Failed to send OTP.');
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

  Future<void> _updatePassword() async {
    FocusScope.of(context).unfocus();

    final phoneValidation = AppValidators.bangladeshPhone(widget.initialPhone);
    if (phoneValidation != null) {
      setState(() => _errorText = phoneValidation);
      AppToast.showError(phoneValidation);
      return;
    }

    final validationMessage = AppValidators.confirmPassword(
      _newPasswordController.text,
      _confirmPasswordController.text,
    );

    if (validationMessage != null) {
      setState(() => _errorText = validationMessage);
      AppToast.showError(validationMessage);
      return;
    }

    if (widget.verifiedToken.trim().isEmpty) {
      const error =
          'Your verification token is missing. Please verify OTP again.';
      setState(() => _errorText = error);
      AppToast.showError(error);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final password = _newPasswordController.text;
      final response = await ref.read(authProvider.notifier).setPassword(
            phone: widget.initialPhone,
            password: password,
            verifiedToken: widget.verifiedToken,
          );

      if (!ApiService.isSuccess(response)) {
        final error =
            ApiService.messageOf(response, fallback: 'Password reset failed.');
        if (!mounted) return;
        setState(() => _errorText = error);
        AppToast.showError(error);
        return;
      }

      final loginResponse = await ref.read(authProvider.notifier).login(
            phone: widget.initialPhone,
            password: password,
          );

      if (loginResponse.status == 200) {
        await AuthService.saveUserSession(loginResponse);
        AppToast.showSuccess('Password reset successfully.');

        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          AppNavigation.smoothRoute(builder: (context) => const PasswordResetPopup()),
          (route) => false,
        );
      } else {
        AppToast.showSuccess('Password reset successfully. Please sign in.');

        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          AppNavigation.smoothRoute(
            builder: (context) => SignInScreen(phone: widget.initialPhone),
          ),
          (route) => false,
        );
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

  void _clearError() {
    if (_errorText != null) setState(() => _errorText = null);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mode == ResetPasswordMode.requestOtp) {
      return _buildRequestOtpScreen();
    }

    return _buildUpdatePasswordScreen();
  }

  Widget _buildRequestOtpScreen() {
    final t = AppLocalizations(ref.watch(localizationProvider));

    return Scaffold(
      backgroundColor: AppTheme.authScaffold(context),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                            t.resetPassword,
                            style: TextStyle(
                              color: AppTheme.textPrimary(context),
                              fontSize: 30,
                                                            fontWeight: FontWeight.w500,
                              height: 1.13,
                            ),
                          ),
                          const SizedBox(height: 34),
                          Text(
                            t.phoneNumberLabel,
                            style: TextStyle(
                              color: AppTheme.textPrimary(context),
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
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              maxLength: 11,
                              onChanged: (_) => _clearError(),
                              decoration: InputDecoration(
                                hintText: '01XXXXXXXXX',
                                counterText: '',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: AppTheme.mutedText(context)),
                                contentPadding: EdgeInsets.only(left: 20, right: 12, bottom: 2),
                              ),
                              style: TextStyle(
                                color: AppTheme.textPrimary(context),
                                fontSize: 16,
                                                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (_errorText != null) ...[
                            const SizedBox(height: 10),
                            Text(_errorText!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                          ],
                          const SizedBox(height: 34),
                          GestureDetector(
                            onTap: _isLoading ? null : _sendOtp,
                            child: _GradientButton(label: t.sendOtp, isLoading: _isLoading),
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

  Widget _buildUpdatePasswordScreen() {
    final t = AppLocalizations(ref.watch(localizationProvider));

    return Scaffold(
      backgroundColor: AppTheme.authScaffold(context),
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
                            t.resetPassword,
                            style: TextStyle(
                              color: AppTheme.textPrimary(context),
                              fontSize: 30,
                                                            fontWeight: FontWeight.w500,
                              height: 1.13,
                            ),
                          ),
                          const SizedBox(height: 34),
                          _InlinePasswordField(
                            label: t.newPassword,
                            controller: _newPasswordController,
                            obscureText: !_isNewPasswordVisible,
                            onChanged: (_) {
                              _clearError();
                              setState(() {});
                            },
                            onVisibilityTap: () => setState(
                              () => _isNewPasswordVisible = !_isNewPasswordVisible,
                            ),
                          ),
                          const SizedBox(height: 18),
                          _InlinePasswordField(
                            label: t.confirmPassword,
                            controller: _confirmPasswordController,
                            obscureText: !_isConfirmPasswordVisible,
                            onChanged: (_) {
                              _clearError();
                              setState(() {});
                            },
                            onVisibilityTap: () => setState(
                              () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
                            ),
                          ),
                          const SizedBox(height: 14),
                          PasswordGuidelineChecklist(
                            password: _newPasswordController.text,
                            confirmPassword: _confirmPasswordController.text,
                            showMatchRule: true,
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
                            onTap: _isLoading ? null : _updatePassword,
                            child: _GradientButton(
                              label: t.updatePassword,
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
    _phoneController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}


class _InlinePasswordField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onVisibilityTap;
  final ValueChanged<String> onChanged;

  const _InlinePasswordField({
    required this.label,
    required this.controller,
    required this.obscureText,
    required this.onVisibilityTap,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppTheme.textPrimary(context),
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
                  controller: controller,
                  obscureText: obscureText,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: '**************',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: AppTheme.mutedText(context)),
                    contentPadding: EdgeInsets.only(left: 20, right: 8, bottom: 2),
                  ),
                  style: TextStyle(
                    color: AppTheme.textPrimary(context),
                    fontSize: 16,
                                        fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: onVisibilityTap,
                  child: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF0080C6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  final double left;
  final double top;
  final double labelTop;
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onVisibilityTap;
  final ValueChanged<String> onChanged;

  const _PasswordField({
    required this.left,
    required this.top,
    required this.labelTop,
    required this.label,
    required this.controller,
    required this.obscureText,
    required this.onVisibilityTap,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            left: left,
            top: top,
            child: Container(
              width: 372,
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
                      controller: controller,
                      obscureText: obscureText,
                      onChanged: onChanged,
                      decoration: InputDecoration(
                        hintText: '**************',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: AppTheme.mutedText(context)),
                        contentPadding: EdgeInsets.only(
                          left: 20,
                          right: 8,
                          bottom: 2,
                        ),
                      ),
                      style: TextStyle(
                        color: AppTheme.textPrimary(context),
                        fontSize: 16,
                                                fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      onTap: onVisibilityTap,
                      child: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF0080C6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: left,
            top: labelTop,
            child: Text(
              label,
              style: TextStyle(
                color: AppTheme.textPrimary(context),
                fontSize: 10,
                                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
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
            spreadRadius: 0,
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
                textAlign: TextAlign.center,
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
