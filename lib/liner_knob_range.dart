import 'package:flutter/material.dart';

// -------------------- Линейный регулятор -100 до 100 --------------------
class LinearKnobRange extends StatefulWidget {
  @override
  _LinearKnobRangeState createState() => _LinearKnobRangeState();
}

class _LinearKnobRangeState extends State<LinearKnobRange> {
  double horizontalValue = 0; // Начало в середине
  double verticalValue = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Вертикальный регулятор
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${verticalValue.toInt()}%', style: TextStyle(color: Colors.cyanAccent)),
            SizedBox(
              height: 150,
              child: RotatedBox(
                quarterTurns: -1,
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6,
                    activeTrackColor: Colors.cyanAccent,
                    inactiveTrackColor: Colors.white12,
                    thumbColor: Colors.cyanAccent,
                    overlayColor: Colors.cyanAccent.withOpacity(0.2),
                  ),
                  child: Slider(
                    min: -100,
                    max: 100,
                    value: verticalValue,
                    onChanged: (val) {
                      setState(() {
                        verticalValue = val;
                      });
                    },
                  ),
                ),
              ),
            ),
            Text('Vertical', style: TextStyle(color: Colors.cyanAccent.withOpacity(0.7))),
          ],
        ),
        SizedBox(width: 40),
        // Горизонтальный регулятор
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${horizontalValue.toInt()}%', style: TextStyle(color: Colors.cyanAccent)),
            SizedBox(
              width: 150,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 6,
                  activeTrackColor: Colors.cyanAccent,
                  inactiveTrackColor: Colors.white12,
                  thumbColor: Colors.cyanAccent,
                  overlayColor: Colors.cyanAccent.withOpacity(0.2),
                ),
                child: Slider(
                  min: -100,
                  max: 100,
                  value: horizontalValue,
                  onChanged: (val) {
                    setState(() {
                      horizontalValue = val;
                    });
                  },
                ),
              ),
            ),
            Text('Horizontal', style: TextStyle(color: Colors.cyanAccent.withOpacity(0.7))),
          ],
        ),
      ],
    );
  }
}