import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class TargetComponent {
  final Vector2 position;
  final double radius;

  late Paint paint = Paint()..color = Colors.greenAccent;

  TargetComponent({required this.position, this.radius = 20});
  void render(Canvas canvas) {
    canvas.drawCircle(position.toOffset(), radius, paint);
  }
}
