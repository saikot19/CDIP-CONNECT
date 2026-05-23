import 'package:cdip_connect/core/services/localization_service.dart';
import 'package:cdip_connect/core/utils/app_navigation.dart';
import 'package:cdip_connect/core/utils/app_toast.dart';
import 'package:cdip_connect/core/utils/app_theme.dart';
import 'package:cdip_connect/core/utils/app_validators.dart';
import 'package:cdip_connect/features/auth/application/auth_flow.dart';
import 'package:cdip_connect/features/auth/application/auth_service.dart';
import 'package:cdip_connect/features/auth/data/services/api_service.dart';
import 'package:cdip_connect/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:cdip_connect/features/auth/presentation/screens/set_password_screen.dart';
import 'package:cdip_connect/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:cdip_connect/shared/widgets/pre_auth_branding.dart';
import 'package:cdip_connect/shared/widgets/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OTPScreen extends ConsumerStatefulWidget {
  final String phone;
  final String testOtp;
  final OtpFlow flow;

  const OTPScreen({
    super.key,
    required this.phone,
    this.testOtp = '',
    this.flow = OtpFlow.firstTimeSetup,
  });

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  String? _errorText;
  bool _isVerifying = false;

  String get _formattedTime {
    final timeLeft = ref.watch(otpTimerProvider);
    final minutes = (timeLeft / 60).floor();
    final seconds = timeLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(otpTimerProvider.notifier).startTimer();
      if (widget.testOtp.isNotEmpty) {
        final digits = widget.testOtp.replaceAll(RegExp(r'\D'), '').split('');
        for (var i = 0; i < digits.length && i < _otpControllers.length; i++) {
          _otpControllers[i].text = digits[i];
        }
        _updateOTP();
      }
    });
  }

  Future<void> _resendOTP() async {
    if (ref.read(otpTimerProvider) > 0) {
      AppToast.showInfo(
          'Please wait until the timer ends before resending OTP.');
      return;
    }

    try {
      final response =
          await ref.read(authProvider.notifier).sendOtp(widget.phone);
      if (ApiService.isSuccess(response)) {
        ref.read(otpTimerProvider.notifier).startTimer();
        AppToast.showSuccess('OTP resent successfully.');
      } else {
        AppToast.showError(
            ApiService.messageOf(response, fallback: 'Failed to resend OTP.'));
      }
    } catch (_) {
      AppToast.showError('Failed to resend OTP. Please try again.');
    }
  }

  Future<void> _verifyOTP() async {
    FocusScope.of(context).unfocus();
    _updateOTP();

    final validationMessage = AppValidators.otp(_otpController.text);
    if (validationMessage != null) {
      setState(() => _errorText = validationMessage);
      AppToast.showError(validationMessage);
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorText = null;
    });

    try {
      final response = await ref.read(authProvider.notifier).verifyOtp(
            phone: widget.phone,
            otp: _otpController.text,
          );

      if (!ApiService.isSuccess(response)) {
        final error = ApiService.messageOf(response,
            fallback: 'Invalid OTP. Please try again.');
        if (!mounted) return;
        setState(() => _errorText = error);
        AppToast.showError(error);
        return;
      }

      final verifiedToken = ApiService.verifiedTokenOf(response);
      if (verifiedToken.isEmpty) {
        const error =
            'OTP verified but verification token was missing. Please try again.';
        if (!mounted) return;
        setState(() => _errorText = error);
        AppToast.showError(error);
        return;
      }

      AppToast.showSuccess('OTP verified successfully.');

      if (!mounted) return;
      if (widget.flow == OtpFlow.firstTimeSetup) {
        if (!ApiService.memberExists(response)) {
          const error =
              'No registered member was found for this phone number. Please contact your branch.';
          setState(() => _errorText = error);
          AppToast.showError(error);
          return;
        }

        // During first-time authentication, decide the next screen only
        // from the fresh OTP verification response. A null/empty password
        // means the member must create a password; any usable password value
        // means setup is already complete and the member should sign in.
        final passwordIsNullOrEmpty =
            ApiService.memberPasswordIsNullOrEmpty(response);
        final hasStoredPassword = ApiService.memberAlreadyHasPassword(response);

        if (passwordIsNullOrEmpty || !hasStoredPassword) {
          AppToast.showInfo('Please set a password before signing in.');
          Navigator.pushReplacement(
            context,
            AppNavigation.smoothRoute(
              builder: (context) => SetPasswordScreen(
                phone: widget.phone,
                verifiedToken: verifiedToken,
              ),
            ),
          );
          return;
        }

        AppToast.showInfo(
            'This account already has a password. Please sign in.');
        Navigator.pushReplacement(
          context,
          AppNavigation.smoothRoute(
            builder: (context) => SignInScreen(phone: widget.phone),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          AppNavigation.smoothRoute(
            builder: (context) => ResetPasswordScreen(
              mode: ResetPasswordMode.updatePassword,
              initialPhone: widget.phone,
              verifiedToken: verifiedToken,
            ),
          ),
        );
      }
    } catch (_) {
      const error = 'OTP verification failed. Please try again.';
      if (!mounted) return;
      setState(() => _errorText = error);
      AppToast.showError(error);
    } finally {
      if (!mounted) return;
      setState(() => _isVerifying = false);
    }
  }

  void _updateOTP() {
    _otpController.text = _otpControllers.map((c) => c.text).join();
  }

  void _handleOtpChange(String value, int index) {
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'\D'), '').split('');
      for (var i = 0; i < digits.length && index + i < 6; i++) {
        _otpControllers[index + i].text = digits[i];
      }
      final nextIndex = (index + digits.length).clamp(0, 5).toInt();
      _focusNodes[nextIndex].requestFocus();
    } else if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    _updateOTP();
    if (_errorText != null) setState(() => _errorText = null);
  }

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeLeft = ref.watch(otpTimerProvider);
    final t = AppLocalizations(ref.watch(localizationProvider));

    return Scaffold(
      backgroundColor: AppTheme.authScaffold(context),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 360 ? 16.0 : 20.0;
            final maxWidth = constraints.maxWidth.clamp(0.0, 430.0);
            final otpGap = constraints.maxWidth < 360 ? 6.0 : 8.0;
            final otpBoxWidth =
                ((maxWidth - (horizontalPadding * 2) - (otpGap * 5)) / 6)
                    .clamp(38.0, 50.0);

            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          horizontalPadding, 20, horizontalPadding, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppBackButton(
                                  onTap: () => Navigator.pop(context)),
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
                            t.otpVerification,
                            style: TextStyle(
                              color: AppTheme.textPrimary(context),
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              height: 1.13,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      'Check your phone. We have sent you the code at ',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary(context),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    height: 1.35,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.phone.length >= 3
                                      ? '***${widget.phone.substring(widget.phone.length - 3)}'
                                      : widget.phone,
                                  style: TextStyle(
                                    color: AppTheme.textSecondary(context),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              6,
                              (index) => SizedBox(
                                width: otpBoxWidth,
                                height: 48,
                                child: DecoratedBox(
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1, color: Color(0xFF0080C6)),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _otpControllers[index],
                                    focusNode: _focusNodes[index],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    onChanged: (value) =>
                                        _handleOtpChange(value, index),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      counterText: '',
                                    ),
                                    style: TextStyle(
                                      color: AppTheme.textSecondary(context),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                timeLeft > 0 ? _formattedTime : '00:00',
                                style: TextStyle(
                                  color: AppTheme.textSecondary(context),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              GestureDetector(
                                onTap: _resendOTP,
                                child: Text(
                                  t.resendCode,
                                  style: TextStyle(
                                    color: timeLeft > 0
                                        ? Colors.grey
                                        : const Color(0xFF0080C6),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            height: 49,
                            child: GestureDetector(
                              onTap: _isVerifying ? null : _verifyOTP,
                              child: DecoratedBox(
                                decoration: ShapeDecoration(
                                  gradient: LinearGradient(
                                    begin: const Alignment(-0.00, 0.07),
                                    end: const Alignment(1.00, 0.91),
                                    colors: _isVerifying
                                        ? [Colors.grey, Colors.grey]
                                        : [
                                            const Color(0xFF21409A),
                                            const Color(0xFF0080C6)
                                          ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 15,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: _isVerifying
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          t.verifyNow,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          if (_errorText != null) ...[
                            const SizedBox(height: 14),
                            Text(
                              _errorText!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
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
}
