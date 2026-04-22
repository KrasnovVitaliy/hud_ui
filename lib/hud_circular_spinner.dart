import 'package:flutter/material.dart';
import 'dart:math' as math;

// -------------------- Круговой прогресс с полукругами и иконкой --------------------
class HudCircularSpinner extends StatefulWidget {
  final int linesCount;
  final double size;
  final Color color;

  const HudCircularSpinner({this.linesCount = 4, this.size = 100.0, this.color = Colors.cyanAccent, super.key});

  @override
  _HudCircularSpinnerState createState() => _HudCircularSpinnerState();
}

class _HudCircularSpinnerState extends State<HudCircularSpinner> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.linesCount, (index) {
      return AnimationController(
        vsync: this,
        duration: Duration(seconds: 5 + index * 3),
      )..repeat();
    });
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  // -------------------- Полукруги --------------------
  Widget buildShiftedHalfCircle(double radius, double opacity, double offsetAngle, AnimationController controller) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: controller.value * 2 * math.pi + offsetAngle,
          child: CustomPaint(
            size: Size(radius * 2, radius * 2),
            painter: SolidHalfCirclePainter(radius: radius, opacity: opacity, lineColor: widget.color),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 2,
      height: widget.size * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Вращающиеся полукруги
          for (int i = 0; i < widget.linesCount; i++)
            buildShiftedHalfCircle(
              widget.size / 6 + i * (widget.size * 0.15),
              0.3 - i * 0.05,
              math.pi / 4 - i * math.pi / 6,
              _controllers[i],
            ),
        ],
      ),
    );
  }
}

// -------------------- CustomPainter для полукругов --------------------
class SolidHalfCirclePainter extends CustomPainter {
  final double radius;
  final double opacity;
  final Color lineColor;

  SolidHalfCirclePainter({required this.radius, required this.opacity, this.lineColor = Colors.cyanAccent});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final paint = Paint()
      ..color = lineColor.withAlpha((opacity * 255).toInt())
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2, math.pi, false, paint);
  }

  @override
  bool shouldRepaint(covariant SolidHalfCirclePainter oldDelegate) {
    return oldDelegate.radius != radius || oldDelegate.opacity != opacity || oldDelegate.lineColor != lineColor;
  }
}
