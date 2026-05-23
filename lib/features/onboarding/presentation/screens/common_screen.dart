import 'package:cdip_connect/core/utils/app_feedback.dart';
import 'package:cdip_connect/core/utils/app_navigation.dart';
import 'package:cdip_connect/core/utils/app_toast.dart';
import 'package:cdip_connect/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';

class CommonScreen extends StatelessWidget {
  const CommonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      _PageData(
        image: 'assets/logo/money and pie chart.png',
        title: 'Smart Money',
        description: 'Capital invested by experienced\nand well-informed investors.',
      ),
      _PageData(
        image: 'assets/logo/wallet with money.png',
        title: 'Smart Money',
        description: 'Capital invested by experienced\nand well-informed investors.',
      ),
      _PageData(
        image: 'assets/logo/International and safe money transfers.png',
        title: 'Smart Money',
        description: 'Capital invested by experienced\nand well-informed investors.',
      ),
    ];

    return WillPopScope(
      onWillPop: () => AppFeedback.confirmExit(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxContentWidth = constraints.maxWidth.clamp(0.0, 430.0);
              final compact = constraints.maxWidth < 360;

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      compact ? 14 : 20,
                      16,
                      compact ? 14 : 20,
                      24,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: _ImageCarousel(pages: pages),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 49,
                                child: OutlinedButton(
                                  onPressed: () => AppToast.showComingSoon('Product information'),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(width: 1, color: Color(0xFF21409A)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 10),
                                  ),
                                  child: const FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'SEE OUR PRODUCT',
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF21409A),
                                        fontSize: 16,
                                                                                fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: compact ? 10 : 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => AppNavigation.push(context, const SignInScreen(phone: '')),
                                child: Container(
                                  height: 49,
                                  decoration: ShapeDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment(-0.00, 0.07),
                                      end: Alignment(1.00, 0.91),
                                      colors: [Color(0xFF21409A), Color(0xFF0080C6)],
                                    ),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        blurRadius: 15,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'SIGN IN',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                                                                fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final imageHeight = (size.height * 0.42).clamp(240.0, 400.0);

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final page = widget.pages[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: SizedBox(
                      height: imageHeight,
                      child: Image.asset(
                        page.image,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const SizedBox(height: 34),
                  Text(
                    page.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 30,
                                            fontWeight: FontWeight.w700,
                      height: 1.13,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    page.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.78),
                      fontSize: 16,
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
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 18 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index ? const Color(0xFF0880C6) : const Color(0xFFEBEBEB),
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }),
        ),
      ],
    );
  }
}
