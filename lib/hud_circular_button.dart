import 'package:flutter/material.dart';
import 'dart:math' as math;

// -------------------- HUD круговая кнопка --------------------
class HudCircularButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  final double size;
  final Color color;
  final int linesCount;

  const HudCircularButton({
    required this.label,
    required this.onPressed,
    this.size = 100.0,
    this.color = Colors.cyanAccent,
    this.linesCount = 3,
    super.key,
  });

  @override
  State<HudCircularButton> createState() => _HudCircularButtonState();
}

class _HudCircularButtonState extends State<HudCircularButton> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  bool _pressed = false;

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
  void didUpdateWidget(covariant HudCircularButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // если изменилось количество линий — пересоздаём контроллеры
    if (oldWidget.linesCount != widget.linesCount) {
      for (var c in _controllers) {
        c.dispose();
      }
      _controllers = List.generate(widget.linesCount, (index) {
        return AnimationController(
          vsync: this,
          duration: Duration(seconds: 5 + index * 3),
        )..repeat();
      });
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _buildHalfCircle(double radius, double opacity, double offset, AnimationController controller) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Transform.rotate(
          angle: controller.value * 2 * math.pi + offset,
          child: CustomPaint(
            size: Size(radius * 2, radius * 2),
            painter: _HalfCirclePainter(radius: radius, opacity: opacity, color: widget.color),
          ),
        );
      },
    );
  }

  void _handleTap() {
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final color = widget.color;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        _handleTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: SizedBox(
          width: size * 2,
          height: size * 2,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // вращающиеся дуги
              for (int i = 0; i < widget.linesCount; i++)
                _buildHalfCircle(
                  size / 1.4 + i * (size * 0.15),
                  0.3 - i * 0.05,
                  math.pi / 4 - i * math.pi / 6,
                  _controllers[i],
                ),

              // центральная кнопка
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: color.withAlpha(_pressed ? 180 : 80),
                      blurRadius: _pressed ? 12 : 6,
                      spreadRadius: _pressed ? 2 : 1,
                    ),
                  ],
                ),
              ),

              // текст
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: size * 0.18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- Painter --------------------
class _HalfCirclePainter extends CustomPainter {
  final double radius;
  final double opacity;
  final Color color;

  _HalfCirclePainter({required this.radius, required this.opacity, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final paint = Paint()
      ..color = color.withAlpha((opacity * 255).toInt())
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2, math.pi, false, paint);
  }

  @override
  bool shouldRepaint(covariant _HalfCirclePainter oldDelegate) {
    return oldDelegate.radius != radius || oldDelegate.opacity != opacity || oldDelegate.color != color;
  }
}
