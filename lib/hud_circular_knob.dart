import 'package:flutter/material.dart';
import 'dart:math' as math;

// -------------------- Круговой регулятор 0-100 с декоративными полукругами --------------------
class HudCircularKnob extends StatefulWidget {
  final int linesCount;
  final double initialValue;
  final double size;
  final Color? color;
  final double min;
  final double max;
  final String? label;
  const HudCircularKnob({
    this.linesCount = 3,
    this.initialValue = 50.0,
    this.color = Colors.cyanAccent,
    this.min = 0.0,
    this.max = 100.0,
    this.label,
    this.size = 120.0,
    super.key,
  });

  @override
  _HudCircularKnobState createState() => _HudCircularKnobState();
}

class _HudCircularKnobState extends State<HudCircularKnob> with TickerProviderStateMixin {
  double value = 50.0;
  bool _isDragging = false;

  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
    _controllers = List.generate(widget.linesCount, (index) {
      return AnimationController(
        vsync: this,
        duration: Duration(seconds: 5 + index * 3),
      )..repeat();
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Offset _indicatorPosition(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = widget.size / 2 - 8;
    final sweepAngle = 2 * math.pi * (value / 100);
    final angle = -math.pi / 2 + sweepAngle;
    return Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
  }

  void _updateValue(Offset localPosition, Size size) {
    if (!_isDragging) return;
    final center = Offset(size.width / 2, size.height / 2);
    final angle = math.atan2(
      localPosition.dy - center.dy,
      localPosition.dx - center.dx,
    );
    double newValue = ((angle + math.pi) / (2 * math.pi)) * 100;
    if (newValue < 0) newValue = 0;
    if (newValue > 100) newValue = 100;
    if ((value == 0 && newValue < value) || (value == 100 && newValue > value)) return;
    setState(() {
      value = newValue;
    });
  }

  Widget buildShiftedHalfCircle(
    double radius,
    double opacity,
    double offsetAngle,
    AnimationController controller,
  ) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: controller.value * 2 * math.pi + offsetAngle,
          child: CustomPaint(
            size: Size(radius * 2, radius * 2),
            painter: SolidHalfCirclePainter(
              radius: radius,
              opacity: opacity,
              color: widget.color!,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        final box = context.findRenderObject() as RenderBox;
        final localPos = box.globalToLocal(details.globalPosition);
        final indicator = _indicatorPosition(box.size);
        const hitRadius = 24.0;
        if ((localPos - indicator).distance <= hitRadius) {
          _isDragging = true;
        }
      },
      onPanUpdate: (details) {
        final box = context.findRenderObject() as RenderBox;
        final localPos = box.globalToLocal(details.globalPosition);
        _updateValue(localPos, box.size);
      },
      onPanEnd: (_) {
        _isDragging = false;
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (int i = 0; i < widget.linesCount; i++)
            buildShiftedHalfCircle(
              widget.size / 1.8 + i * 15,
              0.3 - i * 0.05,
              math.pi / 4 - i * math.pi / 6,
              _controllers[i],
            ),
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(painter: KnobPainter(value, widget.color!)),
          ),
          Text(
            '${value.toInt()}%',
            style: TextStyle(
              color: widget.color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- CustomPainter для 0-100 --------------------
class KnobPainter extends CustomPainter {
  final double value;
  final Color color;
  KnobPainter(this.value, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    final backgroundPaint = Paint()
      ..color = Colors.white12
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final sweepAngle = 2 * math.pi * (value / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    final angle = -math.pi / 2 + sweepAngle;
    final indicator = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
    canvas.drawCircle(indicator, 6, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// -------------------- CustomPainter для сплошных полукругов --------------------
class SolidHalfCirclePainter extends CustomPainter {
  final double radius;
  final double opacity;
  final Color color;

  SolidHalfCirclePainter({
    required this.radius,
    required this.opacity,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color.withAlpha((opacity * 255).toInt())
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}