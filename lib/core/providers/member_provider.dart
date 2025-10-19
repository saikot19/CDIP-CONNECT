import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../database/db_helper.dart';

class MemberState {
  final String memberName;
  final bool isLoading;
  MemberState({this.memberName = '', this.isLoading = false});
}

class MemberNotifier extends StateNotifier<MemberState> {
  MemberNotifier() : super(MemberState());

  // Verify OTP via API, save to local DB and SharedPreferences on success
  Future<bool> verifyOtpAndSave(String phone, String otp) async {
    state = MemberState(isLoading: true);
    final result = await ApiService.verifyOtp(phone: phone, otp: otp);

    if (result['status'] == true &&
        result['memberDetails'] != null &&
        (result['memberDetails'] as List).isNotEmpty) {
      final member = Map<String, dynamic>.from(result['memberDetails'][0]);

      // Save to sqlite
      try {
        await DBHelper.insertOrUpdateMemberMap(member);
      } catch (_) {}

      // Save to SharedPreferences
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('member', jsonEncode(member));
        await prefs.setString('member_id', member['id'].toString());
      } catch (_) {}

      state = MemberState(memberName: member['name'] ?? '', isLoading: false);
      return true;
    } else {
      state = MemberState(isLoading: false);
      return false;
    }
  }

  // Load member from SharedPreferences or sqlite
  Future<void> loadMemberFromLocal() async {
    // 1) try SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      final memberStr = prefs.getString('member');
      final loggedIn = prefs.getBool('isLoggedIn') ?? false;
      if (loggedIn && memberStr != null && memberStr.isNotEmpty) {
        final data = jsonDecode(memberStr) as Map<String, dynamic>;
        state = MemberState(memberName: data['name'] ?? '');
        return;
      }
    } catch (_) {}

    // 2) fallback to sqlite latest member
    try {
      final row = await DBHelper.getLatestMember();
      if (row != null) {
        final data = jsonDecode(row['data']) as Map<String, dynamic>;
        state = MemberState(memberName: data['name'] ?? '');
        return;
      }
    } catch (_) {}

    // default empty
    state = MemberState(memberName: '', isLoading: false);
  }

  // Trigger send OTP (fire-and-forget)
  Future<void> sendOtp(String phone) async {
    await ApiService.sendOtp(phone);
  }

  void signOut() async {
    // clear prefs and sqlite on logout
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('member');
      await prefs.remove('member_id');
    } catch (_) {}
    try {
      await DBHelper.clearMembers();
    } catch (_) {}
    state = MemberState(memberName: '', isLoading: false);
  }

  void autoSyncMember() {}
}

final memberProvider =
    StateNotifierProvider<MemberNotifier, MemberState>((ref) {
  return MemberNotifier();
});
