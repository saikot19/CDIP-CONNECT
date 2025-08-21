import 'package:flutter/material.dart';
import 'loan_portfolio_screen.dart';

class SavingsPortfolioScreen extends StatelessWidget {
  const SavingsPortfolioScreen({super.key});

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
          Positioned(
            left: 73,
            top: 61,
            child: GestureDetector(
              onTap: () {
                // Do nothing or pop if already on this screen
              },
              child: Text(
                'Savings Portfolio',
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
            left: 200,
            top: 61,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoanPortfolioScreen()),
                );
              },
              child: Text(
                'Loan Portfolio',
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
              decoration: BoxDecoration(),
              child: Stack(),
            ),
          ),
          Positioned(
            left: 20,
            top: 141,
            child: Container(
              width: 372,
              height: 776,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 42,
                    child: Container(
                      width: 372,
                      height: 126,
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
                        height: 46,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF05A300),
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
                    top: 119,
                    child: Text(
                      '13,100 BDT',
                      style: TextStyle(
                        color: const Color(0xFF21409A),
                        fontSize: 14,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 13,
                    top: 105,
                    child: Opacity(
                      opacity: 0.50,
                      child: Text(
                        'Total Savings Amount',
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
                    left: 281,
                    top: 67,
                    child: Text(
                      '2023-09-18',
                      style: TextStyle(
                        color: const Color(0xFF3A3A3A),
                        fontSize: 14,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 290,
                    top: 51,
                    child: Opacity(
                      opacity: 0.50,
                      child: Text(
                        'Opening Date',
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
                    top: 51,
                    child: Text(
                      'Savings Product',
                      style: TextStyle(
                        color: const Color(0xFF21409A),
                        fontSize: 14,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 13,
                    top: 67,
                    child: Text(
                      'COM0035002300891',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 176,
                    child: Container(
                      width: 372,
                      height: 126,
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
                    top: 176,
                    child: Opacity(
                      opacity: 0.10,
                      child: Container(
                        width: 372,
                        height: 46,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF05A300),
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
                    top: 249,
                    child: Text(
                      '1,500 BDT',
                      style: TextStyle(
                        color: const Color(0xFF21409A),
                        fontSize: 14,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 13,
                    top: 235,
                    child: Opacity(
                      opacity: 0.50,
                      child: Text(
                        'Total Savings Amount',
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
                    left: 281,
                    top: 198,
                    child: Text(
                      '2023-09-18',
                      style: TextStyle(
                        color: const Color(0xFF3A3A3A),
                        fontSize: 14,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 290,
                    top: 185,
                    child: Opacity(
                      opacity: 0.50,
                      child: Text(
                        'Opening Date',
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
                    top: 185,
                    child: Text(
                      'Savings Product',
                      style: TextStyle(
                        color: const Color(0xFF21409A),
                        fontSize: 14,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 13,
                    top: 201,
                    child: Text(
                      'VOL0035002300891',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 310,
                    child: Container(
                      width: 372,
                      height: 126,
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
                    top: 310,
                    child: Opacity(
                      opacity: 0.10,
                      child: Container(
                        width: 372,
                        height: 46,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF05A300),
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
                    top: 383,
                    child: Text(
                      '0 BDT',
                      style: TextStyle(
                        color: const Color(0xFF21409A),
                        fontSize: 14,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 13,
                    top: 369,
                    child: Opacity(
                      opacity: 0.50,
                      child: Text(
                        'Total Savings Amount',
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
                    left: 281,
                    top: 332,
                    child: Text(
                      '2023-09-18',
                      style: TextStyle(
                        color: const Color(0xFF3A3A3A),
                        fontSize: 14,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 290,
                    top: 319,
                    child: Opacity(
                      opacity: 0.50,
                      child: Text(
                        'Opening Date',
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
                    top: 319,
                    child: Text(
                      'Savings Product',
                      style: TextStyle(
                        color: const Color(0xFF21409A),
                        fontSize: 14,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 13,
                    top: 333,
                    child: Text(
                      'MTS0035002300891',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 442,
                    child: Container(
                      width: 372,
                      height: 126,
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
                    top: 442,
                    child: Opacity(
                      opacity: 0.10,
                      child: Container(
                        width: 372,
                        height: 46,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF05A300),
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
                    top: 515,
                    child: Text(
                      '800 BDT',
                      style: TextStyle(
                        color: const Color(0xFF21409A),
                        fontSize: 14,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 13,
                    top: 501,
                    child: Opacity(
                      opacity: 0.50,
                      child: Text(
                        'Total Savings Amount',
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
                    left: 284,
                    top: 465,
                    child: Text(
                      '2024-11-06',
                      style: TextStyle(
                        color: const Color(0xFF3A3A3A),
                        fontSize: 14,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 290,
                    top: 451,
                    child: Opacity(
                      opacity: 0.50,
                      child: Text(
                        'Opening Date',
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
                    top: 451,
                    child: Text(
                      'Savings Product',
                      style: TextStyle(
                        color: const Color(0xFF21409A),
                        fontSize: 14,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 13,
                    top: 465,
                    child: Text(
                      'MTS0035002300892',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 3,
                    top: 0,
                    child: Opacity(
                      opacity: 0.50,
                      child: Text(
                        'Loan Portfolio',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w400,
                          height: 1.67,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 114,
                    top: 0,
                    child: Text(
                      'Savings Portfolio',
                      style: TextStyle(
                        color: const Color(0xFF0880C6),
                        fontSize: 12,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w600,
                        height: 1.67,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 114,
                    top: 26,
                    child: Container(
                      width: 91,
                      height: 2,
                      decoration: BoxDecoration(color: const Color(0xFF0880C6)),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 28,
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
    ));
  }
}
