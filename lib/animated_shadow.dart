library animated_shadow;

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedShadow extends StatefulWidget {
  const AnimatedShadow({
    super.key,
    required this.child,
    required this.colors,
    this.blur = 10,
    this.spread = 5,
    this.randomStart = false,
    this.startIndex,
    this.animate = true,
    this.opacity = 0.9,
    this.animationDuration = const Duration(milliseconds: 2000),
    this.delay,
  });

  final double opacity;
  final bool animate;
  final int? startIndex;
  final bool randomStart;
  final double blur;
  final double spread;
  final Widget child;
  final List<Color> colors;
  final Duration animationDuration;
  final Duration? delay;

  @override
  State<AnimatedShadow> createState() => _AnimatedShadowState();
}

class _AnimatedShadowState extends State<AnimatedShadow> {
  int _currentColor = 0;
  Timer? _shadowTimer;

  @override
  void initState() {
    super.initState();
    if (widget.startIndex != null) {
      _currentColor = widget.startIndex!;
      while (_currentColor >= widget.colors.length) {
        _currentColor = _currentColor - widget.colors.length;
      }
    } else if (widget.randomStart) {
      int randomNumber = Random().nextInt(widget.colors.length);
      _currentColor = randomNumber;
    }
    if (widget.colors.length > 1 && widget.animate) {
      Future.delayed(widget.delay ?? Duration.zero, () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          bumpColor();
        });
        _shadowTimer = Timer.periodic(widget.animationDuration, (timer) {
          bumpColor();
        });
      });
    }
  }

  @override
  void dispose() {
    _shadowTimer?.cancel();
    super.dispose();
  }

  void bumpColor() {
    if (!mounted) {
      return;
    }
    setState(() {
      _currentColor++;
      if (_currentColor >= widget.colors.length) {
        _currentColor = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.animationDuration,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: widget.colors[_currentColor].withOpacity(
                widget.opacity), // Adjust the color and opacity as needed
            blurRadius: widget.blur, // Adjust the blur radius as needed
            spreadRadius: widget.spread, // Adjust the spread radius as needed
            offset: const Offset(0, 0), // Offset in x and y axes
          ),
        ],
      ),
      child: widget.child,
    );
  }
}
