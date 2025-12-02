import 'package:cdip_connect/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/login_response_model.dart';
import '../services/auth_service.dart';
import 'loan_portfolio_screen.dart' as loan;
import 'savings_portfolio_screen.dart';

class HomeScreen extends StatefulWidget {
  final String memberName;
  final AllSummary allSummary;

  const HomeScreen({
    super.key,
    required this.memberName,
    required this.allSummary,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final List<int> _cardOrder = [0, 1, 2];
  late Future<Map<String, dynamic>?> _loginSummaryFuture;

  @override
  void initState() {
    super.initState();
    _loginSummaryFuture = DatabaseHelper().getLoginSummary();
  }

  // Get dynamic greeting based on time of day
  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else if (hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  void _onCardTap(int index) {
    setState(() {
      final tappedCard = _cardOrder.removeAt(index);
      _cardOrder.insert(0, tappedCard);
    });
  }

  Widget _buildCard({
    required String title,
    required String amount,
    required Color color,
    required String imagePath,
    required int index,
  }) {
    final positions = [
      Offset(0, 10),
      Offset(60, 15),
      Offset(100, 20),
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
      body: Stack(
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
          // Greeting Text (Dynamic)
          Positioned(
            left: 20,
            top: 105,
            child: Text(
              '${_getGreeting()},',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Proxima Nova',
                fontWeight: FontWeight.w400,
                height: 1,
              ),
            ),
          ),
          // User Name from SharedPreferences
          Positioned(
            left: 20,
            top: 128,
            child: FutureBuilder<String>(
              future: AuthService.getMemberName(),
              builder: (context, snapshot) {
                final memberName =
                    snapshot.data ?? widget.memberName.toUpperCase();
                return Text(
                  memberName.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w700,
                    height: 0.77,
                  ),
                );
              },
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
                image: DecorationImage(
                  image: NetworkImage("https://placehold.co/412x197"),
                  fit: BoxFit.cover,
                ),
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
            child: const Text(
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
            left: 19,
            top: 529,
            child: const Text(
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
            left: 6,
            top: 670,
            bottom: 80,
            child: Image.asset(
              'assets/logo/C-5 1@2x.png',
              width: 400,
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
          // Portfolio Cards with Data
          Positioned(
            left: 34,
            top: 253,
            child: FutureBuilder<Map<String, dynamic>?>(
              future: _loginSummaryFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    width: 412,
                    height: 300,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final summary = snapshot.data;
                String outstanding =
                    summary?['total_outstanding_after_transaction']
                            ?.toString() ??
                        '0';
                String overdue =
                    summary?['total_transaction_amount']?.toString() ?? '0';
                String savings = summary?['final_balance']?.toString() ?? '0';

                return Container(
                  width: 412,
                  height: 300,
                  child: Stack(
                    children: [
                      _buildCard(
                        title: 'Outstanding',
                        amount: '$outstanding BDT',
                        color: const Color(0xFF0080C6),
                        imagePath: 'assets/logo/flowbite_chart-pie-outline.png',
                        index: 0,
                      ),
                      _buildCard(
                        title: 'Overdue',
                        amount: '$overdue BDT',
                        color: const Color(0xFFF27024),
                        imagePath: 'assets/logo/zondicons_minus-outline.png',
                        index: 1,
                      ),
                      _buildCard(
                        title: 'Savings',
                        amount: '$savings BDT',
                        color: const Color(0xFF05A300),
                        imagePath: 'assets/logo/Group.png',
                        index: 2,
                      ),
                    ].reversed.toList(),
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 45,
            top: 660,
            child: const Text(
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
                    builder: (context) => loan.LoanPortfolioScreen(
                      allSummary: widget.allSummary,
                    ),
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
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 186,
            top: 660,
            child: const Text(
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
                    builder: (context) => SavingsPortfolioScreen(
                      allSummary: widget.allSummary,
                    ),
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
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 333,
            top: 660,
            child: const Text(
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
          BottomNavBar(
            isHome: true,
            memberName: widget.memberName,
            allSummary: widget.allSummary,
          ),
        ],
      ),
    );
  }
}
