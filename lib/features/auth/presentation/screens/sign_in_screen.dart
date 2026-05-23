import 'package:cdip_connect/core/services/localization_service.dart';
import 'package:cdip_connect/core/utils/app_feedback.dart';
import 'package:cdip_connect/core/utils/app_toast.dart';
import 'package:cdip_connect/core/utils/app_validators.dart';
import 'package:cdip_connect/features/auth/application/auth_service.dart';
import 'package:cdip_connect/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:cdip_connect/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:cdip_connect/features/dashboard/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cdip_connect/shared/widgets/pre_auth_branding.dart';
import 'package:cdip_connect/shared/widgets/app_back_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cdip_connect/core/utils/app_navigation.dart';

class SignInScreen extends ConsumerStatefulWidget {
  final String phone;
  const SignInScreen({super.key, required this.phone});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorText;
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String _memberName = '';

  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.phone;
    _hydrateRememberedUser();
  }

  Future<void> _hydrateRememberedUser() async {
    var phone = widget.phone.trim();
    if (phone.isEmpty) {
      phone = await AuthService.getRememberedPhone();
    }

    if (!mounted || phone.isEmpty) return;

    if (_phoneController.text.trim().isEmpty) {
      _phoneController.text = phone;
    }

    final name = await AuthService.getKnownMemberNameByPhone(phone);
    if (!mounted || name.isEmpty) return;
    setState(() => _memberName = name);
  }

  String _friendlyLoginError(String rawMessage) {
    final normalized = rawMessage.toLowerCase();
    if (normalized.contains('password') ||
        normalized.contains('credential') ||
        normalized.contains('invalid') ||
        normalized.contains('unauthorized')) {
      return 'Password does not match this account. Please try again or reset your password.';
    }
    if (normalized.contains('not set') ||
        normalized.contains('set password') ||
        normalized.contains('verify') ||
        normalized.contains('otp')) {
      return 'Please verify your phone number and set a password before signing in.';
    }
    if (normalized.contains('member') ||
        normalized.contains('not found') ||
        normalized.contains('not registered')) {
      return 'This phone number is not registered for CDIP Connect. Please contact your branch.';
    }
    if (_phoneController.text.trim().isNotEmpty && _memberName.isNotEmpty) {
      return 'Password does not match this account. Please try again or reset your password.';
    }
    return rawMessage.isNotEmpty ? rawMessage : 'Login failed. Please try again.';
  }

  String? _validateInputs(String phone, String password) {
    return AppValidators.bangladeshPhone(phone) ?? AppValidators.password(password);
  }

  Future<void> _handleSignIn() async {
    FocusScope.of(context).unfocus();

    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    final validationMessage = _validateInputs(phone, password);
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
      final response = await ref.read(authProvider.notifier).login(
            phone: phone,
            password: password,
          );

      if (response.status == 200) {
        try {
          await AuthService.saveUserSession(response);
        } catch (e, st) {
          print('Session save error after successful login: $e');
          print(st);
          const error = 'Signed in successfully, but the app could not save your session data. Please try again.';
          if (!mounted) return;
          setState(() => _errorText = error);
          AppToast.showError(error);
          return;
        }

        AppToast.showSuccess('Signed in successfully.');

        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          AppNavigation.smoothRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      } else {
        var error = _friendlyLoginError(response.message);
        final cachedPasswordState = await AuthService.getCachedPasswordSetupState(phone);
        if (cachedPasswordState == PasswordSetupState.required) {
          error = 'This registered member has not set a password on this device yet. Please use New User Set Password to verify your phone and create a password.';
        }
        if (!mounted) return;
        setState(() => _errorText = error);
        AppToast.showError(error);
      }
    } catch (e, st) {
      print('Unexpected sign-in error: $e');
      print(st);
      const error = 'Something went wrong during sign in. Please try again.';
      if (!mounted) return;
      setState(() => _errorText = error);
      AppToast.showError(error);
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _clearError() {
    if (_errorText != null) {
      setState(() => _errorText = null);
    }
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

  void _openResetPassword() {
    final phone = _phoneController.text.trim();
    final validationMessage = phone.isEmpty ? null : AppValidators.bangladeshPhone(phone);

    if (validationMessage != null) {
      setState(() => _errorText = validationMessage);
      AppToast.showError(validationMessage);
      return;
    }

    Navigator.push(
      context,
      AppNavigation.smoothRoute(
        builder: (context) => ResetPasswordScreen(initialPhone: phone),
      ),
    );
  }

  void _openFirstTimeSetup() {
    final phone = _phoneController.text.trim();
    final validationMessage = phone.isEmpty ? null : AppValidators.bangladeshPhone(phone);

    if (validationMessage != null) {
      setState(() => _errorText = validationMessage);
      AppToast.showError(validationMessage);
      return;
    }

    Navigator.push(
      context,
      AppNavigation.smoothRoute(
        builder: (context) => SignUpScreen(initialPhone: phone),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations(ref.watch(localizationProvider));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenBg = isDark ? const Color(0xFF101418) : Colors.white;
    final fieldBg = isDark ? const Color(0xFF171C22) : Colors.white;
    final primaryText = isDark ? const Color(0xFFF2F4F7) : Colors.black;
    final secondaryText = isDark ? const Color(0xFFD0D5DD) : const Color(0xFF3A3A3A);

    return WillPopScope(
      onWillPop: () async {
        await _handleBack();
        return false;
      },
      child: Scaffold(
        backgroundColor: screenBg,
        body: SafeArea(
        child: SingleChildScrollView(
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
                  t.signIn,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 30,
                                        fontWeight: FontWeight.w500,
                  ),
                ),
                if (_memberName.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    _memberName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF21409A),
                      fontSize: 18,
                                            fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                Text(
                  t.phoneNumberLabel,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 14,
                                        fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: fieldBg,
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
                          onChanged: (value) async {
                            if (_memberName.isNotEmpty) {
                              setState(() => _memberName = '');
                            }
                            _clearError();
                            if (value.trim().length == 11) {
                              final name = await AuthService.getKnownMemberNameByPhone(value.trim());
                              if (mounted && name.isNotEmpty) {
                                setState(() => _memberName = name);
                              }
                            }
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 8,
                            ),
                          ),
                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 16,
                                                        fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  t.password,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 14,
                                        fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: fieldBg,
                    border: Border.all(color: const Color(0xFF0880C6)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Icon(Icons.lock, color: Color(0xFF0880C6)),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          onChanged: (_) => _clearError(),
                          onSubmitted: (_) {
                            if (!_isLoading) _handleSignIn();
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your password',
                            hintStyle: TextStyle(
                              color: isDark ? const Color(0xFF98A2B3) : const Color(0xFFB0B0B0),
                              fontSize: 16,
                                                            fontWeight: FontWeight.w400,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 8,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              child: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: const Color(0xFF0880C6),
                              ),
                            ),
                          ),
                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 16,
                                                        fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: _openResetPassword,
                        child: Text(
                          t.forgotPassword,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF0080C6),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: GestureDetector(
                        onTap: _openFirstTimeSetup,
                        child: const Text(
                          'New User Set Password',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0xFF0080C6),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                    onPressed: _isLoading ? null : _handleSignIn,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor: const Color(0xFF21409A),
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            t.signIn.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
