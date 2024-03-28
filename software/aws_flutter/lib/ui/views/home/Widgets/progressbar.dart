import 'package:flutter/material.dart';
import 'package:vertical_percent_indicator/vertical_percent_indicator.dart';

class ProgressBar extends StatelessWidget {
  final int value;
  final String name;
  const ProgressBar({super.key, required this.value, required this.name});

  @override
  Widget build(BuildContext context) {
    return VerticalBarIndicator(
      animationDuration: Duration(seconds: 4),
      percent: value / 10,
      height: 150,
      width: 30,
      color: const [
        Color.fromARGB(255, 241, 3, 3),
        Color.fromARGB(255, 232, 109, 8),
      ],
      header: '${value * 10}%',
      footer: name,
    );
  }
}
