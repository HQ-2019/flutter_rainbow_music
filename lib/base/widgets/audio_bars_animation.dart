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
      this.maxHeight = 20});

  final int itemCount;
  final double itemWidth;
  final double itemSpace;
  final double maxHeight;
  final double minHeight;

  @override
  State<StatefulWidget> createState() => _AudioBarsAnimationState();
}

class _AudioBarsAnimationState extends State<AudioBarsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;
  late List<double> _currentHeights;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          _generateAnimations();
          _controller.forward(from: 0.0);
        }
      });

    _currentHeights = List.generate(widget.itemCount, (index) => 10.0);
    _generateAnimations();
    _controller.forward();
  }

  void _generateAnimations() {
    final random = Random();
    setState(() {
      _animations = List.generate(widget.itemCount, (index) {
        final endHeight =
            random.nextDouble() * (widget.maxHeight - widget.minHeight) +
                widget.minHeight;
        final beginHeight = _currentHeights[index];
        Animation<double> animation =
            Tween<double>(begin: beginHeight, end: endHeight).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
          ),
        );
        _currentHeights[index] = endHeight;
        return animation;
      });
    });
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
