import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final splashProvider = StateNotifierProvider<SplashNotifier, bool>((ref) {
  return SplashNotifier();
});

class SplashNotifier extends StateNotifier<bool> {
  SplashNotifier() : super(true);

  Future<void> initializeApp() async {
    // Add your initialization logic here
    await Future.delayed(
        const Duration(seconds: 3)); // Simulating some loading time
    state = false;
  }
}
