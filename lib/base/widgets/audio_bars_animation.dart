import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AudioBarsAnimation extends StatefulWidget {
  const AudioBarsAnimation(
      {super.key,
      required this.itemCount,
      this.itemWidth = 3.0,
      this.itemSpace = 2.0,
      this.minHeight = 5.0,
      this.maxHeight = 20,
      this.duration = const Duration(milliseconds: 300)});

  final int itemCount;
  final double itemWidth;
  final double itemSpace;
  final double maxHeight;
  final double minHeight;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _AudioBarsAnimationState();
}

class _AudioBarsAnimationState extends State<AudioBarsAnimation>
    with SingleTickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<double> _heights;

  @override
  void initState() {
    super.initState();

    _heights = List.generate(widget.itemCount, (_) => _getRandomHeight());

    _controllers = List.generate(widget.itemCount, (index) {
      return AnimationController(
        duration: widget.duration,
        vsync: this,
      )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            setState(() {
              double oldHeight = _animations[index].value;
              double newHeight = _getRandomHeight();
              _animations[index] = Tween<double>(
                begin: oldHeight,
                end: newHeight,
              ).animate(_controllers[index]);
            });
            _controllers[index].forward(from: 0.0);
          }
        });
    });

    _animations = List.generate(widget.itemCount, (index) {
      return Tween<double>(
        begin: _heights[index],
        end: _getRandomHeight(),
      ).animate(_controllers[index])
        ..addListener(() {
          setState(() {});
        });
    });

    for (var controller in _controllers) {
      controller.forward();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  double _getRandomHeight() {
    return widget.minHeight +
        Random().nextDouble() * (widget.maxHeight - widget.minHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(_animations.length, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.itemSpace),
              width: widget.itemWidth,
              height: _animations[index].value,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(widget.itemWidth / 2.0),
              ),
            );
          },
        );
      }),
    );
  }
}
