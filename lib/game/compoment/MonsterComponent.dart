import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

class MonsterComponent extends SpriteAnimationComponent {
  MonsterComponent(
      {required SpriteAnimation sprite,
      required Vector2 size,
      required Vector2 position})
      : super(
            animation: sprite,
            size: size,
            position: position,
            anchor: Anchor.center);

  @override
  Future<void>? onLoad() async {
    // TODO: implement onLoad
    add(RectangleHitbox()..debugMode = true);
  }
}
