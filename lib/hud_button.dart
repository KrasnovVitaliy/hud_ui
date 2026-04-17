import 'package:flutter/material.dart';

// -------------------- HUD кнопка с прозрачным фоном и настраиваемым цветом --------------------
class HudButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool enabled;
  final Color color;

  const HudButton({
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.color = Colors.cyanAccent,
    super.key,
  });

  @override
  _HudButtonState createState() => _HudButtonState();
}

class _HudButtonState extends State<HudButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.enabled;
    final color = widget.color;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed();
            }
          : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.transparent, // прозрачный фон
          border: Border.all(color: isEnabled ? color : Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: color.withAlpha(_isPressed ? 76 : 0), // 0.3 * 255 = 76
                    blurRadius: _isPressed ? 2 : 6,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: isEnabled ? color : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
