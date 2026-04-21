import 'package:flutter/material.dart';

enum ValuePositionHorizontal { left, right }

class HudHorizontalKnob extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final Color color;
  final ValuePositionHorizontal? valuePosition;

  const HudHorizontalKnob({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.color = Colors.cyan,
    this.valuePosition,
    super.key,
  });

  Widget _buildValueText() {
    return Text(
      value.toStringAsFixed(0),
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    final slider = Expanded(
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 6,
          activeTrackColor: color,
          inactiveTrackColor: Colors.white12,
          thumbColor: color,
          overlayColor: color.withAlpha(51),
        ),
        child: Slider(min: min, max: max, value: value.clamp(min, max), onChanged: onChanged),
      ),
    );

    // без отображения значения
    if (valuePosition == null) {
      return slider;
    }

    return Row(
      children: [
        if (valuePosition == ValuePositionHorizontal.left) ...[_buildValueText(), const SizedBox(width: 8)],
        slider,
        if (valuePosition == ValuePositionHorizontal.right) ...[const SizedBox(width: 8), _buildValueText()],
      ],
    );
  }
}
