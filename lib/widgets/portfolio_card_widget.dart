// lib/widgets/portfolio_card_widget.dart
import 'package:flutter/material.dart';

class PortfolioCard extends StatelessWidget {
  final String productName;
  final String productCode;
  final String? date;
  final String? dateLabel;
  final String? amount;
  final String? amountLabel;
  final String? secondAmount;
  final String? secondAmountLabel;
  final String? outstanding;
  final Color headerColor;
  final Map<String, dynamic>? additionalData;

  const PortfolioCard({
    super.key,
    required this.productName,
    required this.productCode,
    this.date,
    this.dateLabel,
    this.amount,
    this.amountLabel,
    this.secondAmount,
    this.secondAmountLabel,
    this.outstanding,
    this.headerColor = const Color(0xFF0080C6),
    this.additionalData,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate dynamic height based on content
    double baseHeight = 126;
    int additionalFields = 0;

    if (amount != null) additionalFields++;
    if (secondAmount != null) additionalFields++;

    double cardHeight = baseHeight + (additionalFields * 47);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: cardHeight,
        maxHeight: cardHeight + 50,
      ),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with opacity
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 60,
            decoration: ShapeDecoration(
              color: headerColor.withOpacity(0.1),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        productName,
                        style: const TextStyle(
                          color: Color(0xFF21409A),
                          fontSize: 14,
                          fontFamily: 'Proxima Nova',
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          productCode,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (date != null && dateLabel != null)
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: 0.50,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              dateLabel!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontFamily: 'Proxima Nova',
                                fontWeight: FontWeight.w400,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            date!,
                            style: const TextStyle(
                              color: Color(0xFF3A3A3A),
                              fontSize: 14,
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (outstanding != null && (date == null || dateLabel == null))
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
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
                        const SizedBox(height: 4),
                        Opacity(
                          opacity: 0.50,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              outstanding!,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Proxima Nova',
                                fontWeight: FontWeight.w700,
                                height: 1.17,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          // Content area
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(13),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // First amount field
                  if (amount != null && amountLabel != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Opacity(
                                  opacity: 0.50,
                                  child: Text(
                                    amountLabel!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontFamily: 'Proxima Nova',
                                      fontWeight: FontWeight.w400,
                                      height: 1,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    amount!,
                                    style: TextStyle(
                                      color: _getAmountColor(amountLabel!),
                                      fontSize: 14,
                                      fontFamily: 'Proxima Nova',
                                      fontWeight: FontWeight.w600,
                                      height: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Second amount field with overdue
                  if (secondAmount != null && secondAmountLabel != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Opacity(
                                opacity: 0.50,
                                child: Text(
                                  secondAmountLabel!,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontFamily: 'Proxima Nova',
                                    fontWeight: FontWeight.w400,
                                    height: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  secondAmount!,
                                  style: TextStyle(
                                    color: _getAmountColor(secondAmountLabel!),
                                    fontSize: 14,
                                    fontFamily: 'Proxima Nova',
                                    fontWeight: FontWeight.w400,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (additionalData?['overdue'] != null)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Opacity(
                                  opacity: 0.50,
                                  child: const Text(
                                    'Overdue',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontFamily: 'Proxima Nova',
                                      fontWeight: FontWeight.w400,
                                      height: 1,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    additionalData!['overdue'],
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Color(0xFFFF0000),
                                      fontSize: 14,
                                      fontFamily: 'Proxima Nova',
                                      fontWeight: FontWeight.w400,
                                      height: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getAmountColor(String label) {
    if (label.contains('Disbursement') || label.contains('Savings')) {
      return const Color(0xFF05A300);
    } else if (label.contains('Overdue')) {
      return const Color(0xFFFF0000);
    } else {
      return const Color(0xFF21409A);
    }
  }
}
