import 'package:flutter/material.dart';

enum ValuePositionVertical { top, bottom }

// -------------------- Линейные регуляторы --------------------
class HudVerticalKnob extends StatefulWidget {
  final ValueChanged<double>? onValueChanged;
  final double initialValue;
  final Color? color;
  final double min;
  final double max;
  final String? label;
  final ValuePositionVertical? valuePosition; // 👈 новый параметр

  const HudVerticalKnob({
    this.onValueChanged,
    this.initialValue = 50,
    this.color = Colors.cyan,
    this.min = 0,
    this.max = 100,
    this.label,
    this.valuePosition, // null = скрыть значение
    super.key,
  });

  @override
  _HudVerticalKnobState createState() => _HudVerticalKnobState();
}

class _HudVerticalKnobState extends State<HudVerticalKnob> {
  late double verticalValue;

  @override
  void initState() {
    super.initState();
    verticalValue = widget.initialValue;
  }

  Widget _buildValueText() {
    return Text(
      verticalValue.toInt().toString(),
      style: TextStyle(
        color: widget.color,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final slider = RotatedBox(
      quarterTurns: -1,
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
          value: verticalValue,
          onChanged: (val) {
            setState(() {
              verticalValue = val;
            });
            widget.onValueChanged?.call(val);
          },
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.valuePosition == ValuePositionVertical.top) ...[
          _buildValueText(),
          const SizedBox(height: 6),
        ],

        slider,

        if (widget.valuePosition == ValuePositionVertical.bottom) ...[
          const SizedBox(height: 6),
          _buildValueText(),
        ],

        if (widget.label != null) ...[
          const SizedBox(height: 6),
          Text(widget.label!, style: TextStyle(color: widget.color)),
        ],
      ],
    );
  }
}