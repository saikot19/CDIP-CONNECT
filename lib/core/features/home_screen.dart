import 'package:cdip_connect/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'loan_portfolio_screen.dart' as loan;
import 'savings_portfolio_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import '../database/db_helper.dart';
import 'dart:convert';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  final String memberName;
  const HomeScreen({super.key, this.memberName = 'Shahrin Zaman'});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Replace the previous controllers with a single list to track card order
  final List<int> _cardOrder = [0, 1, 2]; // 0:Outstanding, 1:Overdue, 2:Savings

  String memberName = 'Shahrin Zaman';

  @override
  void initState() {
    super.initState();
    _loadMember();
  }

  Future<void> _loadMember() async {
    final member = await DBHelper.getMember('1'); // Use correct id
    if (member != null) {
      final data = jsonDecode(member['data']);
      setState(() {
        memberName = data['name'] ?? memberName;
      });
    }
  }

  void _onCardTap(int index) {
    setState(() {
      // Move the tapped card to the back by rotating the list
      final tappedCard = _cardOrder.removeAt(index);
      _cardOrder.insert(0, tappedCard);
    });
  }

  // Update the _buildCard method to modify positioning
  Widget _buildCard({
    required String title,
    required String amount,
    required Color color,
    required String imagePath,
    required int index,
  }) {
    final positions = [
      Offset(0, 10), // Center card (Outstanding)
      Offset(60, 15), // Right card (Overdue)
      Offset(100, 20), // Left card (Savings)
    ];

    final currentPosition = _cardOrder.indexOf(index);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      left: positions[currentPosition].dx,
      top: positions[currentPosition].dy,
      child: Container(
        width: 197.23,
        height: 259,
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 10,
              offset: Offset(0, 4),
              spreadRadius: -1,
            )
          ],
        ),
        child: GestureDetector(
          onTap: () => _onCardTap(_cardOrder.indexOf(index)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 21, top: 40),
                child: Image.asset(
                  imagePath,
                  width: 64,
                  height: 64,
                  fit: BoxFit.contain,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 10),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                child: Text(
                  amount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _syncMemberData,
        child: Stack(
          children: [
            // Header Container
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 412,
                height: 197,
                decoration: const ShapeDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0B1183),
                      Color(0xFF0045FF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            // Profile Image
            Positioned(
              left: 20,
              top: 39,
              child: Container(
                width: 54,
                height: 54,
                decoration: const ShapeDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/logo/profile.png'),
                    fit: BoxFit.cover,
                  ),
                  shape: OvalBorder(),
                ),
              ),
            ),
            // Greeting Text
            Positioned(
              left: 20,
              top: 105,
              child: const Text(
                'Good Morning,',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
            ),
            // User Name
            Positioned(
              left: 20,
              top: 128,
              child: Text(
                memberName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w700,
                  height: 0.77,
                ),
              ),
            ),
            Positioned(
              left: 412,
              top: 197,
              child: Container(
                transform: Matrix4.identity()
                  ..translate(0.0, 0.0)
                  ..rotateZ(-3.14),
                width: 412,
                height: 197,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 19,
              top: 209,
              child: Text(
                'Your Portfolio Summary',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w500,
                  height: 1.42,
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 529,
              child: Text(
                'Manage Portfolio',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w500,
                  height: 1.42,
                ),
              ),
            ),
            Positioned(
              left: 370,
              top: 55,
              child: Container(
                width: 22,
                height: 22,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Stack(
                  children: [
                    Positioned(
                      left: 12.69,
                      top: 0.85,
                      child: Container(
                        width: 6.77,
                        height: 6.77,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFFF0000),
                          shape: OvalBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 6, // Centered horizontally (adjust as needed)
              top: 670,
              bottom: 80, // Just above the container at 698
              child: Image.asset(
                'assets/logo/C-5 1@2x.png',
                width: 400, // Adjust size as needed
                height: 80,
              ),
            ),

            Positioned(
              left: 189.50,
              top: 824,
              child: Container(
                width: 6,
                height: 6,
                decoration: ShapeDecoration(
                  color: const Color(0xFF0880C6),
                  shape: OvalBorder(),
                ),
              ),
            ),
            Positioned(
              left: 198.50,
              top: 824,
              child: Container(
                width: 6,
                height: 6,
                decoration: ShapeDecoration(
                  color: const Color(0xFFEBEBEB),
                  shape: OvalBorder(),
                ),
              ),
            ),
            Positioned(
              left: 207.50,
              top: 824,
              child: Container(
                width: 6,
                height: 6,
                decoration: ShapeDecoration(
                  color: const Color(0xFFEBEBEB),
                  shape: OvalBorder(),
                ),
              ),
            ),
            Positioned(
              left: 216.50,
              top: 824,
              child: Container(
                width: 6,
                height: 6,
                decoration: ShapeDecoration(
                  color: const Color(0xFFEBEBEB),
                  shape: OvalBorder(),
                ),
              ),
            ),
            Positioned(
              left: 19,
              top: 683,
              child: Opacity(
                opacity: 0.30,
                child: Container(
                  width: 372,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.20,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 34,
              top: 253,
              child: SizedBox(
                width: 412,
                height: 300,
                child: Stack(
                  children: _cardOrder.map((cardIndex) {
                    // Card data
                    final cardData = [
                      {
                        'title': 'Outstanding',
                        'amount': '1,09,447 BDT',
                        'color': const Color(0xFF0080C6),
                        'imagePath':
                            'assets/logo/flowbite_chart-pie-outline.png',
                      },
                      {
                        'title': 'Overdue',
                        'amount': '69,897 BDT',
                        'color': const Color(0xFFF27024),
                        'imagePath': 'assets/logo/zondicons_minus-outline.png',
                      },
                      {
                        'title': 'Savings',
                        'amount': '15,400 BDT',
                        'color': const Color(0xFF05A300),
                        'imagePath': 'assets/logo/Group.png',
                      },
                    ][cardIndex];

                    // The z-order is determined by the position in _cardOrder: last is on top
                    return _buildCard(
                      title: cardData['title'] as String,
                      amount: cardData['amount'] as String,
                      color: cardData['color'] as Color,
                      imagePath: cardData['imagePath'] as String,
                      index: cardIndex,
                    );
                  }).toList(),
                ),
              ),
            ),
            Positioned(
              left: 45,
              top: 660,
              child: Text(
                'Loan',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w700,
                  height: 1.17,
                ),
              ),
            ),
            // Loan Card
            Positioned(
              left: 20,
              top: 575,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const loan.LoanPortfolioScreen(),
                      settings:
                          RouteSettings(arguments: true), // showLoan = true
                    ),
                  );
                },
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: ShapeDecoration(
                    color: const Color(0x260880C6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo/fluent_money-hand-24-regular.png',
                        width: 36,
                        height: 36,
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 186,
              top: 660,
              child: Text(
                'Savings',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w700,
                  height: 1.17,
                ),
              ),
            ),
            // Savings Card
            Positioned(
              left: 168,
              top: 575,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SavingsPortfolioScreen(),
                      settings:
                          RouteSettings(arguments: false), // showLoan = false
                    ),
                  );
                },
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: ShapeDecoration(
                    color: const Color(0x260880C6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo/fluent-mdl2_bank.png',
                        width: 32,
                        height: 32,
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 333,
              top: 660,
              child: Text(
                'Referral',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w700,
                  height: 1.17,
                ),
              ),
            ),
            // Referral Card
            Positioned(
              left: 316,
              top: 575,
              child: Container(
                width: 76,
                height: 76,
                decoration: ShapeDecoration(
                  color: const Color(0x260880C6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo/fluent_people-community-add-24-regular.png',
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 837,
              child: Container(
                width: 412,
                height: 80,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 412,
                        height: 80,
                        decoration: ShapeDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Home icon (center left)
                    Positioned(
                      left: 37,
                      top: 28,
                      child: Image.asset(
                        'assets/logo/tdesign_home.png',
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Profile icon (center right)
                    Positioned(
                      right: 37,
                      top: 28,
                      child: Image.asset(
                        'assets/logo/iconoir_profile-circle.png',
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _syncMemberData() async {
    // Call API to get latest member details
    final member = await DBHelper.getMember('1');
    if (member != null) {
      final data = jsonDecode(member['data']);
      final phone = data['mobile_no'];
      final result = await ApiService.verifyOtp(
          phone: phone, otp: '******'); // Use a valid OTP or a refresh API
      if (result['status'] == true &&
          result['memberDetails'] != null &&
          result['memberDetails'].isNotEmpty) {
        final newMember = result['memberDetails'][0];
        await DBHelper.insertMember(newMember['id'], jsonEncode(newMember));
        setState(() {
          memberName = newMember['name'] ?? memberName;
        });
      }
    }
  }
}
