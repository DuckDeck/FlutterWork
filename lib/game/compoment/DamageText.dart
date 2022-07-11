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
  final TextStyle _critDamageTextStyle = const TextStyle(
      fontSize: 16,
      color: Colors.yellow,
      fontFamily: 'Menlo',
      shadows: [
        Shadow(color: Colors.red, offset: Offset(1, 1), blurRadius: 1)
      ]);
  Future<void> addDamage(int damage, {bool isCrit = false}) async {
    Vector2 offset = Vector2(-30, 0);
    if (children.isNotEmpty) {
      final PositionComponent last;
      if (children.last is PositionComponent) {
        last = children.last as PositionComponent;
        offset = last.position + Vector2(5, last.height);
      }
    }
    TextComponent? damageText;
    if (isCrit) {
      damageText =
          TextComponent(textRenderer: TextPaint(style: _critDamageTextStyle));
    } else {
      damageText =
          TextComponent(textRenderer: TextPaint(style: _damageTextStyle));
    }
    damageText.text = damage.toString();
    damageText.position = Vector2(-30, 0) + offset;
    TextComponent? infoText;
    if (isCrit) {
      TextStyle style = _critDamageTextStyle.copyWith(fontSize: 10);
      infoText = TextComponent(textRenderer: TextPaint(style: style));
      infoText.text = '暴击';
      infoText.position = Vector2(-30 + damageText.width - infoText.width / 2,
              -infoText.height / 2) +
          offset;

      add(infoText);
    }
    add(damageText);
    await Future.delayed(const Duration(milliseconds: 700));
    damageText.removeFromParent();
    infoText?.removeFromParent();
  }
}
