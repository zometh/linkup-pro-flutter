import 'package:flutter/material.dart';
import 'package:linkup_pro/core/utils/services/assets_path.dart';
import 'package:linkup_pro/main.dart';
class CustomProgress extends StatefulWidget {
  const CustomProgress({super.key});

  @override
  State<CustomProgress> createState() => _CustomProgressState();
}

class _CustomProgressState extends State<CustomProgress> with
SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
      animation: _animation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _animation.value * 6.3,
            child: child,
          );
        },
        child: Image.asset(AssetsPath.logoOnly, width: context.screenWidth * 0.13,),
      ),
    );
  }
}
