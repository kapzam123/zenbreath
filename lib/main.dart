import 'package:flutter/material.dart';
import 'breathing_circle.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: Stack(
            children: [
              Image.asset(
                'assets/zen_background.jpg',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
              Center(child: BreathingCircle()),
            ],
          ),
        ),
      ),
    );
  }
}
