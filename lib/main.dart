import 'package:flutter/material.dart';
//import pulse_rate_screen that the UI
import 'screens/pulse_rate_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ixir Task',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      home: PulseRate(), //our page
    );
  }
}
