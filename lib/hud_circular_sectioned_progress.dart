import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'utils.dart';

// -------------------- Круговой прогресс --------------------
class HudCircularSectionedProgressIndicator extends StatefulWidget {
  final int value;
  final int segments;

  final IconData? icon;
  final String? label;
  final int linesCount;
  final double size;
  final double segmentGap;
  final Map<int, Color>? colorMap;
  final Color color;

  const HudCircularSectionedProgressIndicator({
    required this.value,
    this.segments = 20,
    this.icon,
    this.label,
    this.linesCount = 3,
    this.size = 100.0,
    this.segmentGap = 0.05,
    this.color = Colors.cyanAccent,
    this.colorMap,
    super.key,
  });

  @override
  _HudCircularSectionedProgressIndicatorState createState() => _HudCircularSectionedProgressIndicatorState();
}

class _HudCircularSectionedProgressIndicatorState extends State<HudCircularSectionedProgressIndicator>
    with TickerProviderStateMixin {
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

  double get percent => widget.value / widget.segments;

  Color getColor() {
    if (widget.colorMap == null) {
      return widget.color;
    }

    for (var colorPair in sortMapByKey(widget.colorMap!).entries) {
      if (widget.value < colorPair.key) return colorPair.value;
    }
    return widget.color;
  }

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
          // Вращающиеся линии
          for (int i = 0; i < widget.linesCount; i++)
            buildShiftedHalfCircle(
              widget.size / 1.4 + i * (widget.size * 0.15),
              0.3 - i * 0.05,
              math.pi / 4 - i * math.pi / 6,
              _controllers[i],
            ),

          // -------------------- СЕГМЕНТЫ --------------------
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: SegmentedArcPainter(
                activeSegments: widget.value,
                totalSegments: widget.segments,
                strokeWidth: widget.size * 0.06,
                activeColor: getColor(),
                inactiveColor: Colors.white12,
                gap: widget.segmentGap,
              ),
            ),
          ),

          // Контент
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) Icon(widget.icon, color: getColor(), size: widget.size * 0.24),

              if (widget.icon != null) SizedBox(height: widget.size * 0.04),

              Text(
                '${(percent * 100).toInt()}%',
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

// -------------------- СЕГМЕНТЫ --------------------
class SegmentedArcPainter extends CustomPainter {
  final int activeSegments;
  final int totalSegments;
  final double strokeWidth;
  final Color activeColor;
  final Color inactiveColor;
  final double gap;

  SegmentedArcPainter({
    required this.activeSegments,
    required this.totalSegments,
    required this.strokeWidth,
    required this.activeColor,
    required this.inactiveColor,
    this.gap = 0.05,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final totalAngle = 2 * math.pi;
    final segmentAngle = (totalAngle - gap * totalSegments) / totalSegments;

    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startAngle = -math.pi / 2;

    for (int i = 0; i < totalSegments; i++) {
      paint.color = i < activeSegments ? activeColor : inactiveColor;

      canvas.drawArc(rect, startAngle, segmentAngle, false, paint);

      startAngle += segmentAngle + gap;
    }
  }

  @override
  bool shouldRepaint(covariant SegmentedArcPainter oldDelegate) {
    return oldDelegate.activeSegments != activeSegments ||
        oldDelegate.totalSegments != totalSegments ||
        oldDelegate.activeColor != activeColor;
  }
}

// -------------------- ПОЛУКРУГИ --------------------
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
