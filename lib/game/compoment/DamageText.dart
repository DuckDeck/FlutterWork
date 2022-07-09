import 'dart:ffi';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DamageText extends PositionComponent {
  final TextStyle _damageTextStyle = const TextStyle(
      fontSize: 14,
      color: Colors.white,
      fontFamily: 'Menlo',
      shadows: [
        Shadow(color: Colors.red, offset: Offset(1, 1), blurRadius: 1)
      ]);

  Future<void> addDamage(int damage, {bool isCrit = false}) async {
    TextComponent damageText =
        TextComponent(textRenderer: TextPaint(style: _damageTextStyle));
    damageText.text = damage.toString();
    damageText.position = Vector2(-30, 0);
    if (isCrit) {
      // TextStyle style = _create
    }
    add(damageText);
    await Future.delayed(const Duration(milliseconds: 700));
    damageText.removeFromParent();
  }
}
