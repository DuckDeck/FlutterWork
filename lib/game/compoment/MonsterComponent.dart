import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_work/game/mixin/Liveable.dart';

class MonsterComponent extends SpriteAnimationComponent with Liveable {
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
    initPaint(lifeColor: Colors.yellow, lifePoint: 1000);
  }

  void move(Vector2 ds) {
    position.add(ds);
  }

  @override
  void onDied() {
    // TODO: implement onDied
    removeFromParent();
  }
}
