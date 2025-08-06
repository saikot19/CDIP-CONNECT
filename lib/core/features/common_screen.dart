import 'package:flutter/material.dart';
import 'sign_up.dart';

class CommonScreen extends StatelessWidget {
  const CommonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_PageData> pages = [
      _PageData(
        image: "assets/logo/money and pie chart.png",
        title: "Smart Money",
        description:
            "Capital invested by experienced \nand well-informed investors.",
      ),
      _PageData(
        image: "assets/logo/wallet with money.png",
        title: "Smart Money",
        description:
            "Capital invested by experienced \nand well-informed investors.",
      ),
      _PageData(
        image: "assets/logo/International and safe money transfers.png",
        title: "Smart Money",
        description:
            "Capital invested by experienced \nand well-informed investors.",
      ),
      // Add more pages if needed
    ];

    return Scaffold(
      body: Container(
        width: 412,
        height: 917,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            // Buttons and other widgets...
            Positioned(
              left: 214,
              top: 788,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()),
                  );
                },
                child: Container(
                  width: 178,
                  height: 49,
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(-0.00, 0.07),
                      end: Alignment(1.00, 0.91),
                      colors: [Color(0xFF21409A), Color(0xFF0080C6)],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 15,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'SIGN UP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Proxima Nova',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              left: 20,
              top: 788,
              child: Container(
                width: 178,
                height: 49,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: const Color(0xFF21409A),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  /*shadows: [
                    BoxShadow(
                      color: Color.fromARGB(61, 255, 255, 255),
                      blurRadius: 15,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],*/
                ),
              ),
            ),
            Positioned(
              left: 36.72,
              top: 805,
              child: Text(
                'SEE OUR PRODUCT',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF21409A),
                  fontSize: 16,
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // PageView for images and texts
            Positioned(
              left: 0,
              top: 46,
              child: SizedBox(
                width: 412,
                height: 650,
                child: _ImageCarousel(pages: pages),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageData {
  final String image;
  final String title;
  final String description;

  _PageData({
    required this.image,
    required this.title,
    required this.description,
  });
}

class _ImageCarousel extends StatefulWidget {
  final List<_PageData> pages;

  const _ImageCarousel({required this.pages});

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  int _currentPage = 0;
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final page = widget.pages[index];
              return Column(
                children: [
                  SizedBox(
                    height: 400,
                    child: Image.asset(
                      page.image,
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    page.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: 'Proxima Nova',
                      fontWeight: FontWeight.w700,
                      height: 1.13,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    page.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF3A3A3A),
                      fontSize: 16,
                      fontFamily: 'Proxima Nova',
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.pages.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? const Color(0xFF0880C6)
                    : const Color(0xFFEBEBEB),
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    );
  }
}
