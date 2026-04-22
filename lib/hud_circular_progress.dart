import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'utils.dart';

// -------------------- Круговой прогресс с полукругами и иконкой --------------------
class HudCircularProgressIndicator extends StatefulWidget {
  final double value;
  final double minValue;
  final double maxValue;

  final IconData? icon;
  final String? label;
  final int linesCount;
  final double size;
  final Map<double, Color>? colorMap;
  final Color color;
  final bool usePercentIndicator;

  const HudCircularProgressIndicator({
    required this.value,
    this.minValue = 0.0,
    this.maxValue = 1.0,
    this.icon,
    this.label,
    this.linesCount = 3,
    this.size = 100.0,
    this.color = Colors.cyanAccent,
    this.colorMap,
    this.usePercentIndicator = true,
    super.key,
  });

  @override
  _HudCircularProgressIndicatorState createState() => _HudCircularProgressIndicatorState();
}

class _HudCircularProgressIndicatorState extends State<HudCircularProgressIndicator> with TickerProviderStateMixin {
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

  // -------------------- Нормализация значения --------------------
  double get normalizedValue {
    double min = widget.minValue;
    double max = widget.maxValue;

    // Если границы перепутаны — меняем местами
    if (min > max) {
      final temp = min;
      min = max;
      max = temp;
    }

    final range = max - min;
    if (range == 0) return 0;

    // Ограничиваем значение диапазоном
    final clampedValue = widget.value.clamp(min, max);

    return ((clampedValue - min) / range).clamp(0.0, 1.0);
  }

  // -------------------- Цвет --------------------
  Color getColor() {
    if (widget.colorMap == null) {
      return widget.color;
    }

    for (var colorPair in sortMapByKey(widget.colorMap!).entries) {
      if (normalizedValue < colorPair.key) return colorPair.value;
    }
    return widget.color;
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
            painter: SolidHalfCirclePainter(radius: radius, opacity: opacity, lineColor: getColor()),
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
              widget.size / 1.4 + i * (widget.size * 0.15),
              0.3 - i * 0.05,
              math.pi / 4 - i * math.pi / 6,
              _controllers[i],
            ),

          // Основной прогресс
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              value: normalizedValue,
              strokeWidth: widget.size * 0.06,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation(getColor()),
            ),
          ),

          // Контент
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) Icon(widget.icon, color: getColor(), size: widget.size * 0.24),

              if (widget.icon != null) SizedBox(height: widget.size * 0.04),

              Text(
                widget.usePercentIndicator ? '${(normalizedValue * 100).toInt()}%' : widget.value.toStringAsFixed(0),
                style: TextStyle(color: getColor(), fontWeight: FontWeight.bold, fontSize: widget.size * 0.16),
              ),

              if (widget.label != null) SizedBox(height: widget.size * 0.04),

              if (widget.label != null)
                Text(
                  widget.label!,
                  style: TextStyle(color: getColor(), fontSize: widget.size * 0.12),
                ),
            ],
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
