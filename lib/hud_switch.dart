import 'package:flutter/material.dart';

// -------------------- HUD переключатель (controlled) --------------------
class HudSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;
  final Color color;
  final Color disabledColor;

  const HudSwitch({
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.color = Colors.cyanAccent,
    this.disabledColor = Colors.grey,
    super.key,
  });

  void _toggle() {
    if (!enabled) return;
    onChanged(!value);
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled;

    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 60,
        height: 30,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: isEnabled ? color : disabledColor, width: 2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isEnabled
              ? [BoxShadow(color: color.withAlpha(value ? 77 : 0), blurRadius: 4, spreadRadius: 1)]
              : [],
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: isEnabled ? color : disabledColor,
              shape: BoxShape.circle,
              boxShadow: isEnabled ? [BoxShadow(color: color.withAlpha(204), blurRadius: 4, spreadRadius: 1)] : [],
            ),
          ),
        ),
      ),
    );
  }
}
