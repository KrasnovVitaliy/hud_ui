import 'package:flutter/material.dart';

enum ValuePositionVertical { top, bottom }

class HudVerticalKnob extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final Color color;
  final String? label;
  final ValuePositionVertical? valuePosition;

  const HudVerticalKnob({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.color = Colors.cyan,
    this.label,
    this.valuePosition,
    super.key,
  });

  Widget _buildValueText() {
    return Text(
      value.toInt().toString(),
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    final slider = RotatedBox(
      quarterTurns: -1,
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (valuePosition == ValuePositionVertical.top) ...[_buildValueText(), const SizedBox(height: 6)],

        slider,

        if (valuePosition == ValuePositionVertical.bottom) ...[const SizedBox(height: 6), _buildValueText()],

        if (label != null) ...[const SizedBox(height: 6), Text(label!, style: TextStyle(color: color))],
      ],
    );
  }
}
