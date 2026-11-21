import 'package:flutter/material.dart';

abstract final class BiteSanoColors {
  static const forest = Color(0xFF006B4F);
  static const deepForest = Color(0xFF075C48);
  static const pageBackground = Color(0xFFF6F8FD);
  static const fieldBackground = Color(0xFFF0F4FF);
  static const mutedText = Color(0xFF75817F);
}

class BiteSanoLogo extends StatelessWidget {
  const BiteSanoLogo({super.key, this.width = 280});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/bitesano_logo.png',
      width: width,
      fit: BoxFit.contain,
    );
  }
}

class AiBadge extends StatelessWidget {
  const AiBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F0EE),
        borderRadius: BorderRadius.circular(40),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome, size: 17, color: BiteSanoColors.deepForest),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              'IA DE DETECCIÓN DE ALÉRGENOS',
              style: TextStyle(
                color: BiteSanoColors.deepForest,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size * 0.28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF263B49).withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.health_and_safety_outlined,
                color: BiteSanoColors.forest,
                size: size * 0.55,
              ),
            ),
          ),
          Positioned(
            right: -5,
            bottom: -5,
            child: Container(
              width: size * 0.32,
              height: size * 0.32,
              decoration: BoxDecoration(
                color: BiteSanoColors.forest,
                shape: BoxShape.circle,
                border: Border.all(
                  color: BiteSanoColors.pageBackground,
                  width: 3,
                ),
              ),
              child: Icon(
                Icons.verified_outlined,
                color: Colors.white,
                size: size * 0.19,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BiteSanoWordmark extends StatelessWidget {
  const BiteSanoWordmark({super.key, required this.fontSize});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.7,
          color: const Color(0xFF202C2A),
        ),
        children: const [
          TextSpan(text: 'Bite'),
          TextSpan(
            text: 'Sano',
            style: TextStyle(
              color: BiteSanoColors.forest,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class GoogleMark extends StatelessWidget {
  const GoogleMark({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'G',
      style: TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.w800,
        color: Color(0xFF4285F4),
      ),
    );
  }
}

class AppleMark extends StatelessWidget {
  const AppleMark({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 21,
      height: 23,
      child: CustomPaint(painter: _AppleMarkPainter()),
    );
  }
}

class _AppleMarkPainter extends CustomPainter {
  const _AppleMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF111827);
    final body = Path()
      ..moveTo(11.9, 6.6)
      ..cubicTo(9.4, 4.9, 5.7, 6.1, 4.4, 9.3)
      ..cubicTo(2.8, 13.2, 5.5, 20.3, 8.7, 21.1)
      ..cubicTo(10.1, 21.5, 10.8, 20.5, 12.1, 20.5)
      ..cubicTo(13.4, 20.5, 14.1, 21.5, 15.5, 21.1)
      ..cubicTo(18.6, 20.2, 21.2, 13.8, 19.3, 9.8)
      ..cubicTo(17.8, 6.7, 14.3, 5, 11.9, 6.6)
      ..close();
    final leaf = Path()
      ..moveTo(12.1, 5.6)
      ..cubicTo(12, 2.8, 14.3, 1.1, 17.2, 1)
      ..cubicTo(17.1, 3.8, 15.3, 5.4, 12.1, 5.6)
      ..close();

    canvas.drawPath(body, paint);
    canvas.drawPath(leaf, paint);
  }

  @override
  bool shouldRepaint(covariant _AppleMarkPainter oldDelegate) => false;
}
