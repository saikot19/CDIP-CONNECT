import 'package:flutter/material.dart';
import 'savings_portfolio_screen.dart';

class LoanPortfolioScreen extends StatelessWidget {
  const LoanPortfolioScreen({super.key});

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
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 412,
                height: 116,
                decoration: const BoxDecoration(color: Colors.white),
              ),
            ),
            Positioned(
              left: 422.12,
              top: 138.13,
              child: Container(
                transform: Matrix4.identity()
                  ..translate(0.0, 0.0)
                  ..rotateZ(-3.14),
                width: 431.66,
                height: 288.13,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("https://placehold.co/432x288"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Top Bar: Loan Portfolio & Savings Portfolio (Switch)
            Positioned(
              left: 73,
              top: 61,
              child: GestureDetector(
                onTap: () {
                  // Do nothing or pop if already on this screen
                },
                child: Text(
                  'Loan Portfolio',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w500,
                    height: 1.42,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 200, // adjust as needed
              top: 61,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SavingsPortfolioScreen()),
                  );
                },
                child: Text(
                  'Savings Portfolio',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 24,
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w500,
                    height: 1.42,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 58,
              child: Container(
                width: 40,
                height: 40,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(),
              ),
            ),
            // Portfolio Content
            Positioned(
              left: 20,
              top: 141,
              child: Container(
                width: 372,
                height: 776,
                child: Stack(
                  children: [
                    // Card 1
                    Positioned(
                      left: 0,
                      top: 42,
                      child: Container(
                        width: 372,
                        height: 173,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 42,
                      child: Opacity(
                        opacity: 0.10,
                        child: Container(
                          width: 372,
                          height: 60,
                          decoration: const ShapeDecoration(
                            color: Color(0xFF0080C6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 13,
                      top: 131,
                      child: const Text(
                        '2023-09-19',
                        style: TextStyle(
                          color: Color(0xFF21409A),
                          fontSize: 14,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 13,
                      top: 117,
                      child: Opacity(
                        opacity: 0.50,
                        child: const Text(
                          'Disbursement Date',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 279,
                      top: 131,
                      child: const Text(
                        '70,000 BDT',
                        style: TextStyle(
                          color: Color(0xFF05A300),
                          fontSize: 14,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 255,
                      top: 117,
                      child: Opacity(
                        opacity: 0.50,
                        child: const Text(
                          'Disbursement Amount',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 13,
                      top: 178,
                      child: const Text(
                        '79,450 BDT',
                        style: TextStyle(
                          color: Color(0xFF21409A),
                          fontSize: 14,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 13,
                      top: 164,
                      child: Opacity(
                        opacity: 0.50,
                        child: const Text(
                          'Recovered',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 314,
                      top: 178,
                      child: const Text(
                        '0 BDT',
                        style: TextStyle(
                          color: Color(0xFFFF0000),
                          fontSize: 14,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 316,
                      top: 164,
                      child: Opacity(
                        opacity: 0.50,
                        child: const Text(
                          'Overdue',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 13,
                      top: 57,
                      child: const Text(
                        'Loan Product',
                        style: TextStyle(
                          color: Color(0xFF21409A),
                          fontSize: 14,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 13,
                      top: 71,
                      child: SizedBox(
                        width: 126,
                        height: 17,
                        child: const Text(
                          'JAGM0035002300891',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w700,
                            height: 1.67,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 275,
                      top: 57,
                      child: const Text(
                        'Outstanding',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF0080C6),
                          fontSize: 14,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 320,
                      top: 73,
                      child: Opacity(
                        opacity: 0.50,
                        child: const Text(
                          '0 BDT',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w700,
                            height: 1.17,
                          ),
                        ),
                      ),
                    ),
                    // Card 2
                    Positioned(
                      left: 0,
                      top: 229,
                      child: Container(
                        width: 372,
                        height: 173,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 229,
                      child: Opacity(
                        opacity: 0.10,
                        child: Container(
                          width: 372,
                          height: 60,
                          decoration: const ShapeDecoration(
                            color: Color(0xFF0080C6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 13,
                      top: 318,
                      child: const Text(
                        '2024-11-06',
                        style: TextStyle(
                          color: Color(0xFF21409A),
                          fontSize: 14,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 13,
                      top: 304,
                      child: Opacity(
                        opacity: 0.50,
                        child: const Text(
                          'Disbursement Date',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 278,
                      top: 318,
                      child: const Text(
                        '70,000 BDT',
                        style: TextStyle(
                          color: Color(0xFF05A300),
                          fontSize: 14,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 255,
                      top: 304,
                      child: Opacity(
                        opacity: 0.50,
                        child: const Text(
                          'Disbursement Amount',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 13,
                      top: 365,
                      child: const Text(
                        '39,900 BDT',
                        style: TextStyle(
                          color: Color(0xFF21409A),
                          fontSize: 14,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 13,
                      top: 351,
                      child: Opacity(
                        opacity: 0.50,
                        child: const Text(
                          'Recovered',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 313,
                      top: 365,
                      child: const Text(
                        '0 BDT',
                        style: TextStyle(
                          color: Color(0xFFFF0000),
                          fontSize: 14,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 313,
                      top: 351,
                      child: Opacity(
                        opacity: 0.50,
                        child: const Text(
                          'Overdue',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 13,
                      top: 244,
                      child: const Text(
                        'Loan Product',
                        style: TextStyle(
                          color: Color(0xFF21409A),
                          fontSize: 14,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 13,
                      top: 258,
                      child: const Text(
                        'JAGM0035002300892',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w700,
                          height: 1.67,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 275,
                      top: 244,
                      child: const Text(
                        'Outstanding',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF0080C6),
                          fontSize: 14,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 287,
                      top: 258,
                      child: SizedBox(
                        width: 67,
                        height: 17,
                        child: Opacity(
                          opacity: 0.50,
                          child: const Text(
                            '39,550 BDT',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w700,
                              height: 1.67,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Card 3
                    Positioned(
                      left: 0,
                      top: 416,
                      child: Container(
                        width: 372,
                        height: 173,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 416,
                      child: Opacity(
                        opacity: 0.10,
                        child: Container(
                          width: 372,
                          height: 60,
                          decoration: const ShapeDecoration(
                            color: Color(0xFFFF0000),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 13,
                      top: 505,
                      child: const Text(
                        '2023-09-17',
                        style: TextStyle(
                          color: Color(0xFF21409A),
                          fontSize: 14,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 13,
                      top: 491,
                      child: Opacity(
                        opacity: 0.50,
                        child: const Text(
                          'Disbursement Date',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 278,
                      top: 505,
                      child: const Text(
                        '70,000 BDT',
                        style: TextStyle(
                          color: Color(0xFF05A300),
                          fontSize: 14,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 255,
                      top: 491,
                      child: Opacity(
                        opacity: 0.50,
                        child: const Text(
                          'Disbursement Amount',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 13,
                      top: 552,
                      child: const Text(
                        '9,553 BDT',
                        style: TextStyle(
                          color: Color(0xFF21409A),
                          fontSize: 14,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 13,
                      top: 538,
                      child: Opacity(
                        opacity: 0.50,
                        child: const Text(
                          'Recovered',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 279,
                      top: 552,
                      child: const Text(
                        '69,897 BDT',
                        style: TextStyle(
                          color: Color(0xFFFF0000),
                          fontSize: 14,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 313,
                      top: 538,
                      child: Opacity(
                        opacity: 0.50,
                        child: const Text(
                          'Overdue',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 13,
                      top: 431,
                      child: const Text(
                        'Loan Product',
                        style: TextStyle(
                          color: Color(0xFF21409A),
                          fontSize: 14,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 13,
                      top: 445,
                      child: const Text(
                        'JAGM0035015500632',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w700,
                          height: 1.67,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 274,
                      top: 431,
                      child: const Text(
                        'Outstanding',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF0080C6),
                          fontSize: 14,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 285,
                      top: 445,
                      child: SizedBox(
                        width: 67,
                        height: 17,
                        child: Opacity(
                          opacity: 0.50,
                          child: const Text(
                            '69,897 BDT',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w700,
                              height: 1.67,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Navigation Bar
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
                        decoration: const BoxDecoration(),
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
                          decoration: const BoxDecoration(),
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
