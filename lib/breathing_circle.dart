import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class BreathingCircle extends StatefulWidget {
  @override
  _BreathingCircleState createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<BreathingCircle>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Color _circleColor = Color.fromRGBO(0, 0, 255, 0.5); // 50% transparent blue
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
  String? _instruction;
  int _animationDuration = 20;

  @override
  void initState() {
    super.initState();

    _initAnimationController();

    _assetsAudioPlayer.open(
      Audio("assets/zen_sound.mp3"),
      autoStart: false,
      showNotification: false,
    );

    _showInstructions();
  }

  void _initAnimationController() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _animationDuration),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void _showInstructions() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _instruction = "Touch the circle!";
    });
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _instruction = null;
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      _instruction = "Breathe slowly.";
    });
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _instruction = null;
    });
    await Future.delayed(const Duration(seconds: 10));
    setState(() {
      _instruction = "Don't rush.";
    });
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _instruction = null;
    });
    await Future.delayed(const Duration(seconds: 10));
    setState(() {
      _instruction =
          "Let your lungs expand and contract with the rhythm of this circle.";
    });
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _instruction = null;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _assetsAudioPlayer.dispose();
    super.dispose();
  }

  void _changeColor() async {
    // Vibrate for 200ms only on mobile platforms
    if (!kIsWeb && await Vibration.hasVibrator() == true) {
      Vibration.vibrate(duration: 200);
    }

    //
    // Play the sound
    _assetsAudioPlayer.play();

    setState(() {
      _circleColor = Color((Random().nextDouble() * 0xFFFFFF).toInt())
          .withOpacity(0.5); // 50% transparent random color
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _changeColor,
      child: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: Text(
              "ZEN BREATH",
              style: TextStyle(
                fontFamily: 'ZenLoop',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: Slider(
              min: 1,
              max: 30,
              divisions: 29,
              value: _animationDuration.toDouble(),
              onChanged: (double value) {
                setState(() {
                  _animationDuration = value.toInt();
                  _controller.stop();
                  _initAnimationController();
                });
              },
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Align(
                alignment: Alignment.center,
                child: ScaleTransition(
                  scale: _animation,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _circleColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_instruction != null)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 16,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  _instruction!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'ZenLoop',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
