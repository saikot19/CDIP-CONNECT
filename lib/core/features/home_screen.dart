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

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  Widget build(BuildContext context) {
    // We use a LayoutBuilder or MediaQuery to ensure it fits,
    // but the Figma code used fixed dimensions (412x917).
    // A Scaffold + SingleChildScrollView is best to prevent overflow on smaller devices.
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      body: SingleChildScrollView(
        child: SizedBox(
          width: 412,
          height: 917, // Matches your Figma height, but scrollable
          child: Stack(
            children: [
              // --- Background White Header ---
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 412,
                  height: 292,
                  decoration: const ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),

              // --- Background Image (Bottom half of header) ---
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 412,
                  height: 292,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color.fromARGB(255, 2, 34, 212),
                        const Color.fromARGB(255, 0, 26, 71),
                        const Color.fromARGB(255, 20, 36, 103).withOpacity(0.8),
                      ],
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

              // --- Member Name (Dynamic) ---
              Positioned(
                left: 20,
                top: 129,
                child: FutureBuilder<String>(
                  future: AuthService.getMemberName(),
                  builder: (context, snapshot) {
                    final memberName = snapshot.data ?? widget.memberName;
                    return Text(
                      memberName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w700,
                        height: 0.83,
                      ),
                    );
                  },
                ),
              ),

              // --- Greeting (Dynamic) ---
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

              // --- Profile Image ---
              Positioned(
                left: 20,
                top: 37,
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: const ShapeDecoration(
                    shape: OvalBorder(),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      size: 32,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              // --- Notification Icon ---
              Positioned(
                right: 20,
                top: 50,
                child: Stack(
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      size: 28,
                      color: Colors.white,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const ShapeDecoration(
                          color: Color(0xFFFF0000),
                          shape: OvalBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // --- Portfolio Summary Background Container ---
              Positioned(
                left: 20,
                top: 161,
                child: Container(
                  width: 372,
                  height: 383,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 100,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),

              // --- "Your Portfolio Summary" Title ---
              Positioned(
                left: 34,
                top: 175,
                child: const Text(
                  'Your Portfolio Summary',
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 16,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w700,
                    height: 2.13,
                  ),
                ),
              ),

              // --- DYNAMIC DATA SECTION START ---
              // Everything inside here depends on the database future
              Positioned.fill(
                child: FutureBuilder<Map<String, dynamic>?>(
                  future: _loginSummaryFuture,
                  builder: (context, snapshot) {
                    // Default values if loading or null
                    String outstanding = '0';
                    String overdue = '0';
                    String savings = '0';
                    String loanCount =
                        '0'; // Assuming you might have these fields in future
                    String savingsCount = '0';
                    String dueLoanCount = '0';

                    if (snapshot.hasData && snapshot.data != null) {
                      final summary = snapshot.data!;
                      outstanding =
                          summary['total_outstanding_after_transaction']
                                  ?.toString() ??
                              '0';
                      overdue =
                          summary['total_transaction_amount']?.toString() ??
                              '0';
                      savings = summary['final_balance']?.toString() ?? '0';
                      // Note: If your API returns counts (like "5" loans), map them here.
                      // For now I'll leave placeholders or mapped logic if available.
                    }

                    return Stack(
                      children: [
                        // --- 1. Total Outstanding Card (Blue) ---
                        Positioned(
                          left: 29,
                          top: 215,
                          child: Container(
                            width: 351,
                            height: 101,
                            decoration: ShapeDecoration(
                              color: const Color(0xFF2370A1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        // Outstanding Amount
                        Positioned(
                          left: 100,
                          top: 268,
                          child: Text(
                            '$outstanding BDT',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w600,
                              height: 1.09,
                            ),
                          ),
                        ),
                        // Loan Count (Example)
                        Positioned(
                          left: 350,
                          top: 268,
                          child: const Text(
                            '5', // Replace with dynamic count if available
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w600,
                              height: 1.09,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 273,
                          top: 246,
                          child: const Text(
                            'Number of Loans',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w600,
                              height: 1.17,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 100,
                          top: 246,
                          child: const Text(
                            'Total Outstanding',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w600,
                              height: 1,
                            ),
                          ),
                        ),
                        // Icon (Outstanding)
                        Positioned(
                          left: 43,
                          top: 247,
                          child: Image.asset(
                            'assets/logo/flowbite_chart-pie-outline.png', // Restored local asset
                            width: 42,
                            height: 42,
                            color: Colors.white, // Tinting white as per blue bg
                          ),
                        ),

                        // --- 2. Total Savings Card (Teal) ---
                        Positioned(
                          left: 29,
                          top: 323,
                          child: Container(
                            width: 351,
                            height: 101,
                            decoration: ShapeDecoration(
                              color: const Color(0xFF075F63),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        // Savings Count
                        Positioned(
                          left: 350,
                          top: 372,
                          child: const Text(
                            '3', // Replace with dynamic count
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w600,
                              height: 1.09,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 264,
                          top: 350,
                          child: const Text(
                            'Number of Savings',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w600,
                              height: 1.17,
                            ),
                          ),
                        ),
                        // Icon (Savings)
                        Positioned(
                          left: 43,
                          top: 353,
                          child: Image.asset(
                            'assets/logo/Group.png', // Restored local asset
                            width: 42,
                            height: 42,
                            color: Colors.white,
                          ),
                        ),
                        // Savings Amount
                        Positioned(
                          left: 100,
                          top: 372,
                          child: Text(
                            '$savings BDT',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w600,
                              height: 1.09,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 100,
                          top: 350,
                          child: const Text(
                            'Total Savings',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w600,
                              height: 1,
                            ),
                          ),
                        ),

                        // --- 3. Due Amount Card (Red) ---
                        Positioned(
                          left: 29,
                          top: 431,
                          child: Container(
                            width: 351,
                            height: 101,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFF5959),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        // Due Count
                        Positioned(
                          left: 350,
                          top: 480,
                          child: const Text(
                            '4', // Replace with dynamic count
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w600,
                              height: 1.09,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 249,
                          top: 458,
                          child: const Text(
                            'Number of Due Loans',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w600,
                              height: 1.17,
                            ),
                          ),
                        ),
                        // Overdue Amount
                        Positioned(
                          left: 100,
                          top: 480,
                          child: Text(
                            '$overdue BDT',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w600,
                              height: 1,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 100,
                          top: 458,
                          child: const Text(
                            'Total Due Amount',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w600,
                              height: 1,
                            ),
                          ),
                        ),
                        // Icon (Due)
                        Positioned(
                          left: 43,
                          top: 459,
                          child: Image.asset(
                            'assets/logo/zondicons_minus-outline.png', // Restored local asset
                            width: 42,
                            height: 42,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // --- "Manage Portfolio" Title ---
              Positioned(
                left: 20,
                top: 544,
                child: const Text(
                  'Manage Portfolio',
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 16,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w700,
                    height: 2.13,
                  ),
                ),
              ),

              // --- 1. LOAN BUTTON ---
              Positioned(
                left: 20,
                top: 578,
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
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x5E000000),
                          blurRadius: 20,
                          offset: Offset(0, 4),
                          spreadRadius: -9,
                        )
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/logo/Cash in Hand.png', // Updated asset
                        width: 46,
                        height: 46,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 42,
                top: 665,
                child: const Text(
                  'Loan',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ),

              // --- 2. SAVINGS BUTTON ---
              Positioned(
                left: 168,
                top: 578,
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
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x5E000000),
                          blurRadius: 20,
                          offset: Offset(0, 4),
                          spreadRadius: -9,
                        )
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/logo/Request Money.png', // Updated asset
                        width: 46,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 182,
                top: 665,
                child: const Text(
                  'Savings',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ),

              // --- 3. REFERRAL BUTTON ---
              Positioned(
                left: 316,
                top: 578,
                child: GestureDetector(
                  // Add Referral logic here if needed
                  onTap: () {
                    // logic
                  },
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x5E000000),
                          blurRadius: 20,
                          offset: Offset(0, 4),
                          spreadRadius: -9,
                        )
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/logo/Pocket Money.png', // Updated asset
                        width: 44,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 332,
                top: 665,
                child: const Text(
                  'Referral',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ),

              // --- Bottom Banner Image ---
              Positioned(
                left: 20,
                top: 692,
                child: Container(
                  width: 372,
                  height: 108,
                  decoration: ShapeDecoration(
                    image: const DecorationImage(
                      image: AssetImage(
                          'assets/logo/Shadhin Add for  CDIP Connect@4x-100 1.png'), // Restored local asset
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),

              // --- Dot Indicators (Static Visuals) ---
              Positioned(
                left: 190,
                top: 813,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const ShapeDecoration(
                    color: Color(0xFF0880C6),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 199,
                top: 813,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFEBEBEB),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 208,
                top: 813,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFEBEBEB),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 217,
                top: 813,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFEBEBEB),
                    shape: OvalBorder(),
                  ),
                ),
              ),

              // --- Bottom Navigation Bar ---
              // Replaced placeholder with actual widget
              BottomNavBar(
                isHome: true,
                memberName: widget.memberName,
                allSummary: widget.allSummary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
