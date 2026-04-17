import 'package:flutter/material.dart';

enum ValuePositionHorizontal { left, right }

// -------------------- Горизонтальный регулятор --------------------
class HudHorizontalKnob extends StatefulWidget {
  final ValueChanged<double>? onValueChanged;
  final double initialValue;
  final Color? color;
  final double min;
  final double max;
  final ValuePositionHorizontal? valuePosition;

  const HudHorizontalKnob({
    this.onValueChanged,
    this.initialValue = 50,
    this.color = Colors.cyan,
    this.min = 0,
    this.max = 100,
    this.valuePosition, // по умолчанию null = без отображения
    super.key,
  });

  @override
  _HudHorizontalKnobState createState() => _HudHorizontalKnobState();
}

class _HudHorizontalKnobState extends State<HudHorizontalKnob> {
  late double horizontalValue;

  @override
  void initState() {
    super.initState();
    horizontalValue = widget.initialValue;
  }

  Widget _buildValueText() {
    return Text(
      horizontalValue.toStringAsFixed(0),
      style: TextStyle(
        color: widget.color,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final slider = Expanded(
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 6,
          activeTrackColor: widget.color,
          inactiveTrackColor: Colors.white12,
          thumbColor: widget.color,
          overlayColor: widget.color!.withAlpha(51),
        ),
        child: Slider(
          min: widget.min,
          max: widget.max,
          value: horizontalValue,
          onChanged: (val) {
            setState(() {
              horizontalValue = val;
            });
            widget.onValueChanged?.call(val);
          },
        ),
      ),
    );

    // если позиция не задана — просто слайдер
    if (widget.valuePosition == null) {
      return slider;
    }

    return Row(
      children: [
        if (widget.valuePosition == ValuePositionHorizontal.left) ...[
          _buildValueText(),
          const SizedBox(width: 8),
        ],
        slider,
        if (widget.valuePosition == ValuePositionHorizontal.right) ...[
          const SizedBox(width: 8),
          _buildValueText(),
        ],
      ],
    );
  }
}