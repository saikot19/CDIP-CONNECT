import 'package:cdip_connect/core/services/localization_service.dart';
import 'package:cdip_connect/core/utils/app_feedback.dart';
import 'package:cdip_connect/core/utils/app_toast.dart';
import 'package:cdip_connect/core/utils/app_theme.dart';
import 'package:cdip_connect/core/utils/app_validators.dart';
import 'package:cdip_connect/features/auth/application/auth_flow.dart';
import 'package:cdip_connect/features/auth/application/auth_service.dart';
import 'package:cdip_connect/features/auth/data/services/api_service.dart';
import 'package:cdip_connect/features/auth/presentation/screens/otp_screen.dart';
import 'package:cdip_connect/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:cdip_connect/shared/widgets/pre_auth_branding.dart';
import 'package:cdip_connect/shared/widgets/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cdip_connect/core/utils/app_navigation.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  final String initialPhone;

  const SignUpScreen({super.key, this.initialPhone = ''});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.initialPhone;
  }

  Future<void> _handleSignUp() async {
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
        Navigator.push(
          context,
          AppNavigation.smoothRoute(
            builder: (context) => OTPScreen(
              phone: phone,
              flow: OtpFlow.firstTimeSetup,
            ),
          ),
        );
      } else {
        final message = ApiService.messageOf(response, fallback: 'Failed to send OTP.');
        setState(() => _errorText = message);
        AppToast.showError(message);
      }
    } catch (_) {
      const error = 'Network error occurred. Please check your connection.';
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

  void _goToSignIn() {
    Navigator.push(
      context,
      AppNavigation.smoothRoute(
        builder: (context) => const SignInScreen(phone: ''),
      ),
    );
  }

  Future<void> _handleBack() async {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      return;
    }

    final shouldExit = await AppFeedback.confirmExit(context);
    if (shouldExit) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations(ref.watch(localizationProvider));

    return WillPopScope(
      onWillPop: () async {
        await _handleBack();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppTheme.authScaffold(context),
        body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppBackButton(onTap: _handleBack),
                            const PreAuthBranding(
                              logoWidth: 58,
                              logoHeight: 46,
                              buttonWidth: 81,
                              buttonHeight: 39,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'New User Set Password',
                          style: TextStyle(
                            color: AppTheme.textPrimary(context),
                            fontSize: 30,
                                                        fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          t.phoneNumberLabel,
                          style: TextStyle(
                            color: AppTheme.textPrimary(context),
                            fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF0880C6)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: Icon(Icons.phone_android, color: Color(0xFF0880C6)),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 11,
                                  decoration: const InputDecoration(
                                    hintText: '01XXXXXXXXX',
                                    border: InputBorder.none,
                                    counterText: '',
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 8,
                                    ),
                                  ),
                                  style: TextStyle(
                                    color: AppTheme.textSecondary(context),
                                    fontSize: 16,
                                                                        fontWeight: FontWeight.w400,
                                  ),
                                  onChanged: (_) => _clearError(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_errorText != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              _errorText!,
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 49,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleSignUp,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              backgroundColor: const Color(0xFF21409A),
                              foregroundColor: Colors.white,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    'SEND OTP',
                                    style: const TextStyle(
                                      fontSize: 16,
                                                                            fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              Text(
                                'Already set password? ',
                                style: TextStyle(
                                  color: AppTheme.textSecondary(context),
                                  fontSize: 12,
                                                                    fontWeight: FontWeight.w400,
                                ),
                              ),
                              GestureDetector(
                                onTap: _goToSignIn,
                                child: Text(
                                  t.signIn,
                                  style: TextStyle(
                                    color: const Color(0xFF0080C6),
                                    fontSize: 12,
                                                                        fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: t.poweredBy,
                                  style: TextStyle(
                                    color: AppTheme.textSecondary(context),
                                    fontSize: 12,
                                                                        fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const TextSpan(
                                  text: 'CDIP IT SERVICES LIMITED',
                                  style: TextStyle(
                                    color: Color(0xFF0278C0),
                                    fontSize: 12,
                                                                        fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
