import 'package:flutter/material.dart';
import 'package:hud_ui/hud_button.dart';
import 'package:hud_ui/hud_switch.dart';
import 'package:hud_ui/hud_vertical_knob.dart';
import 'package:hud_ui/hud_horizontal_knob.dart';
import 'package:hud_ui/hud_card.dart';
import 'package:hud_ui/hud_circular_progress.dart';
import 'package:hud_ui/hud_circular_sectioned_progress.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hud UI Example',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool toggleValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.cyanAccent, title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: [
            SizedBox(
              height: 120,
              child: HudCard(
                title: "Buttons",
                color: Colors.cyanAccent,
                child: Row(
                  children: [
                    HudButton(label: "Default", onPressed: () {}),
                    SizedBox(width: 8),
                    HudButton(label: "Red", color: Colors.redAccent, onPressed: () {}),
                    SizedBox(width: 8),
                    HudButton(label: "Green", color: Colors.greenAccent, onPressed: () {}),
                    SizedBox(width: 8),
                    HudButton(label: "Orange", color: Colors.orangeAccent, onPressed: () {}),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: HudCard(
                title: "Switches",
                color: Colors.cyanAccent,
                child: Row(
                  children: [
                    HudSwitch(
                      value: toggleValue,
                      onChanged: (value) {
                        setState(() {
                          toggleValue = value;
                        });
                      },
                    ),
                    SizedBox(width: 8),
                    HudSwitch(
                      value: toggleValue,
                      color: Colors.redAccent,
                      onChanged: (value) {
                        setState(() {
                          toggleValue = value;
                        });
                      },
                    ),
                    SizedBox(width: 8),
                    HudSwitch(
                      value: true,
                      color: Colors.orange,
                      disabledColor: Colors.orange.withAlpha(100),
                      enabled: false,
                      onChanged: (value) {},
                    ),
                    SizedBox(width: 8),
                    HudSwitch(value: false, color: Colors.orange, enabled: false, onChanged: (value) {}),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: HudCard(
                title: "Knobs",
                color: Colors.cyanAccent,
                child: Row(
                  children: [
                    HudVerticalKnob(valuePosition: ValuePositionVertical.bottom),
                    HudVerticalKnob(color: Colors.redAccent, valuePosition: ValuePositionVertical.top),
                    SizedBox(width: 300, child: HudHorizontalKnob(valuePosition: ValuePositionHorizontal.left)),
                    SizedBox(
                      width: 300,
                      child: HudHorizontalKnob(
                        color: Colors.orangeAccent,
                        valuePosition: ValuePositionHorizontal.right,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: HudCard(
                title: "Progress indicator",
                color: Colors.cyanAccent,
                child: Row(
                  children: [
                    HudCircularProgressIndicator(value: 0.1, color: Colors.greenAccent),
                    SizedBox(width: 8),
                    HudCircularProgressIndicator(
                      value: 1,
                      minValue: -100,
                      maxValue: 100,
                      linesCount: 0,
                      colorMap: {0.75: Colors.yellowAccent, 0.5: Colors.orangeAccent, 0.35: Colors.redAccent},
                    ),
                    SizedBox(width: 8),
                    HudCircularProgressIndicator(icon: Icons.battery_charging_full_rounded, value: 0.9, linesCount: 2),
                    SizedBox(width: 8),
                    HudCircularSectionedProgressIndicator(
                      value: 14,
                      segments: 20,
                      icon: Icons.bolt,
                      label: "Power",
                      colorMap: {15: Colors.yellowAccent, 10: Colors.orangeAccent, 5: Colors.redAccent},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
