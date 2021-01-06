import 'package:flutter/material.dart';
import 'screens/pulse_rate_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PPG',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      home: PulseRate(),
    );
  }
}
