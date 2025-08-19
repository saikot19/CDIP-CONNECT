import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Replace the previous controllers with a single list to track card order
  final List<int> _cardOrder = [0, 1, 2]; // 0:Outstanding, 1:Overdue, 2:Savings

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
      body: Container(
        width: 412,
        height: 917,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Colors.white),
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
                  color: Color(0xFF0080C6),
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
              child: const Text(
                'Shahrin Zaman',
                style: TextStyle(
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
              left: 20,
              top: 698,
              child: Container(
                width: 373,
                height: 117,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("https://placehold.co/373x117"),
                    fit: BoxFit.cover,
                  ),
                ),
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
              child: Container(
                width: 412,
                height:
                    300, // Increased height to accommodate the pyramid layout
                child: Stack(
                  children: [
                    _buildCard(
                      title: 'Outstanding',
                      amount: '1,09,447 BDT',
                      color: const Color(0xFF0080C6),
                      imagePath: 'assets/logo/flowbite_chart-pie-outline.png',
                      index: 0,
                    ),
                    _buildCard(
                      title: 'Overdue',
                      amount: '69,897 BDT',
                      color: const Color(0xFFF27024),
                      imagePath: 'assets/logo/zondicons_minus-outline.png',
                      index: 1,
                    ),
                    _buildCard(
                      title: 'Savings',
                      amount: '15,400 BDT',
                      color: const Color(0xFF05A300),
                      imagePath: 'assets/logo/Group.png',
                      index: 2,
                    ),
                  ].reversed.toList(),
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
            Positioned(
              left: 20,
              top: 575,
              child: Container(
                width: 76,
                height: 76,
                decoration: ShapeDecoration(
                  color: const Color(0x260880C6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x5E000000),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                      spreadRadius: -9,
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              left: 43,
              top: 598,
              child: Container(
                width: 30,
                height: 30,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Stack(),
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
            Positioned(
              left: 168,
              top: 575,
              child: Container(
                width: 76,
                height: 76,
                decoration: ShapeDecoration(
                  color: const Color(0x260880C6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x5E000000),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                      spreadRadius: -9,
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              left: 194,
              top: 600,
              child: Container(
                width: 26,
                height: 26,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Stack(),
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
                  shadows: [
                    BoxShadow(
                      color: Color(0x5E000000),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                      spreadRadius: -9,
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              left: 341,
              top: 600,
              child: Container(
                width: 26,
                height: 26,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Stack(),
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
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18),
                            ),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 15,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 37,
                      top: 24.98,
                      child: Container(
                        width: 24,
                        height: 25.04,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(),
                        child: Stack(),
                      ),
                    ),
                    Positioned(
                      left: 361,
                      top: 23,
                      child: Opacity(
                        opacity: 0.60,
                        child: Container(
                          width: 24,
                          height: 24,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Stack(),
                        ),
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
}
