import 'package:cdip_connect/core/services/localization_service.dart';
import 'package:cdip_connect/core/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreAuthBranding extends ConsumerWidget {
  final double logoWidth;
  final double logoHeight;
  final double buttonWidth;
  final double buttonHeight;

  const PreAuthBranding({
    super.key,
    this.logoWidth = 72,
    this.logoHeight = 58,
    this.buttonWidth = 81,
    this.buttonHeight = 39,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(localizationProvider);
    final isBangla = language == 'bn';
    final label = isBangla ? 'English' : 'বাংলা';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Image.asset(
          'assets/logo/App Splash Screen-8.png',
          width: logoWidth,
          height: logoHeight,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final nextLanguage = isBangla ? 'en' : 'bn';
            await ref.read(localizationProvider.notifier).changeLanguage(nextLanguage);
            AppToast.showSuccess(
              nextLanguage == 'bn'
                  ? 'বাংলা ভাষা নির্বাচন করা হয়েছে।'
                  : 'English language selected.',
            );
          },
          child: Container(
            width: buttonWidth,
            height: buttonHeight,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1,
                  color: Color(0xFF0880C6),
                ),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Center(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF0880C6),
                  fontSize: isBangla ? 16 : 14,
                  fontFamily: isBangla ? 'Hind Siliguri' : 'Proxima Nova',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
