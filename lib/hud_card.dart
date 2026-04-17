import 'package:flutter/material.dart';

// -------------------- HUD Карточка с внешним цветом и опциональной иконкой --------------------
class HudCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Color color;
  final IconData? icon;
  final double? width;
  final double? height;

  const HudCard({
    required this.title,
    required this.child,
    required this.color,
    this.icon,
    this.width,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(153), // фон HUD
        border: Border.all(color: color),
        boxShadow: [BoxShadow(color: color.withAlpha(51), blurRadius: 20)],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          if (icon != null) Icon(icon, color: color),
          if (icon != null) SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: color.withAlpha(179), fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1),
          ),
          SizedBox(height: 4),
          // Оборачиваем child в DefaultTextStyle, чтобы текстовые виджеты наследовали цвет
          child,
        ],
      ),
    );
  }
}
