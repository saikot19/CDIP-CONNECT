import 'package:cdip_connect/core/services/localization_service.dart';
import 'package:cdip_connect/features/dashboard/presentation/screens/home_screen.dart';
import 'package:cdip_connect/shared/widgets/pre_auth_branding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cdip_connect/core/utils/app_navigation.dart';

class PasswordResetPopup extends ConsumerWidget {
  const PasswordResetPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations(ref.watch(localizationProvider));

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            const Positioned(
              right: 20,
              top: 32,
              child: PreAuthBranding(
                logoWidth: 52,
                logoHeight: 42,
                buttonWidth: 81,
                buttonHeight: 39,
              ),
            ),
            Positioned(
              left: 117,
              top: 189,
              child: SizedBox(
                width: 178,
                height: 156,
                child: Image.asset(
                  'assets/logo/success.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 365,
              child: Text(
                t.translate('password_reset'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                                    fontWeight: FontWeight.w700,
                  height: 1.70,
                ),
              ),
            ),
            Positioned(
              left: 40,
              right: 40,
              top: 405,
              child: Text(
                t.translate('password_reset_success'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF3A3A3A),
                  fontSize: 14,
                                    fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: 485,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    AppNavigation.smoothRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: Container(
                  height: 49,
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(-0.00, 0.07),
                      end: Alignment(1.00, 0.91),
                      colors: [Color(0xFF21409A), Color(0xFF0080C6)],
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
                    child: Text(
                      t.translate('continue_to_home'),
                      textAlign: TextAlign.center,
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
          ],
        ),
      ),
    );
  }
}
