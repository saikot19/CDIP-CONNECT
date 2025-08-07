import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                width: 342,
                height: 259,
                child: Stack(
                  children: [
                    Positioned(
                      left: 197.23,
                      top: 72.68,
                      child: Container(
                        width: 144.77,
                        height: 186.32,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF05A300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                              spreadRadius: -1,
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 210.86,
                      top: 196,
                      child: SizedBox(
                        width: 110.15,
                        height: 25.59,
                        child: Text(
                          '15,400 BDT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 210.86,
                      top: 199.62,
                      child: SizedBox(
                        width: 57.70,
                        height: 14.33,
                        child: Text(
                          'Savings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                            height: 0.88,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 211.26,
                      top: 92.77,
                      child: Container(
                        width: 64.25,
                        height: 64.25,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(),
                        child: Stack(
                          children: [
                            Positioned(
                              left: 32.13,
                              top: 13.29,
                              child: SizedBox(
                                width: 12.19,
                                height: 15.51,
                                child: Text(
                                  '৳',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Tiro Devanagari Hindi',
                                    fontWeight: FontWeight.w400,
                                    height: 0.88,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 98.61,
                      top: 36.85,
                      child: Container(
                        width: 185.69,
                        height: 222.15,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF27024),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                              spreadRadius: -1,
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 115.40,
                      top: 194,
                      child: SizedBox(
                        width: 139.53,
                        height: 25.59,
                        child: Text(
                          '69,897 BDT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 115.40,
                      top: 187.34,
                      child: SizedBox(
                        width: 31.47,
                        height: 14.33,
                        child: Text(
                          'Due',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                            height: 0.88,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 115.79,
                      top: 67.17,
                      child: Container(
                        width: 64.25,
                        height: 64.25,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(),
                        child: Stack(),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 197.23,
                        height: 259,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF0080C6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                              spreadRadius: -1,
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 19.93,
                      top: 189.39,
                      child: Text(
                        '1,09,447 BDT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w600,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 19.93,
                      top: 169,
                      child: Text(
                        'Outstanding',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w400,
                          height: 0.88,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 21.38,
                      top: 39.53,
                      child: Container(
                        width: 64.25,
                        height: 64.25,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(),
                        child: Stack(),
                      ),
                    ),
                  ],
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
