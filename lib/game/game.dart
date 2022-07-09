import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_work/game/compoment/HeroComponent.dart';
import 'package:flutter_work/game/compoment/MonsterComponent.dart';

class MiniGame extends FlameGame
    with HasDraggables, KeyboardEvents, PanDetector {
  late final JoystickComponent joystick;
  late final HeroComponent player;
  late final MonsterComponent monster;
  final Random _random = Random();
  @override
  Future<void>? onLoad() async {
    print("Game onLoad");

    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystick = JoystickComponent(
        knob: CircleComponent(radius: 25, paint: knobPaint),
        background: CircleComponent(radius: 60, paint: backgroundPaint),
        margin: const EdgeInsets.only(left: 40, bottom: 40));

    add(joystick);

    player = HeroComponent();
    await add(player);

    const String src = 'adventure/animatronic.png';
    await images.load(src);
    var image = images.fromCache(src);
    SpriteSheet sheet =
        SpriteSheet.fromColumnsAndRows(image: image, columns: 13, rows: 6);
    int framecount = sheet.rows * sheet.columns;
    List<Sprite> sprites = List.generate(framecount, sheet.getSpriteById);
    SpriteAnimation animation =
        SpriteAnimation.spriteList(sprites, stepTime: 1 / 24, loop: true);
    Vector2 monsterSize = Vector2(64, 64);
    final double py = _random.nextDouble() * size.y;
    final double px = size.x - monsterSize.x / 2;
    monster = MonsterComponent(
        sprite: animation, size: monsterSize, position: Vector2(px, py));
    add(monster);
    //  FlameAudio.play("background.mp3");
    return super.onLoad();
  }

  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final double step = 10;
    final isKeyDown = event is RawKeyDownEvent;
    if (event.logicalKey == LogicalKeyboardKey.keyY && isKeyDown) {
      print("keyY");
      player.flip(y: true);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyX && isKeyDown) {
      print("keyX");
      player.flip(x: true);
    }

    if ((event.logicalKey == LogicalKeyboardKey.arrowUp ||
            event.logicalKey == LogicalKeyboardKey.keyW) &&
        isKeyDown) {
      player.move(Vector2(0, -step));
    }

    if ((event.logicalKey == LogicalKeyboardKey.arrowDown ||
            event.logicalKey == LogicalKeyboardKey.keyS) &&
        isKeyDown) {
      player.move(Vector2(0, step));
    }

    if ((event.logicalKey == LogicalKeyboardKey.arrowLeft ||
            event.logicalKey == LogicalKeyboardKey.keyA) &&
        isKeyDown) {
      player.move(Vector2(-step, 0));
    }

    if ((event.logicalKey == LogicalKeyboardKey.arrowRight ||
            event.logicalKey == LogicalKeyboardKey.keyD) &&
        isKeyDown) {
      player.move(Vector2(step, 0));
    }

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onPanDown(DragDownInfo info) {
    // TODO: implement onPanDown
    super.onPanDown(info);
    player.debugMode = true;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    // TODO: implement onPanUpdate
    super.onPanUpdate(info);
    player.move(info.delta.global);
  }

  @override
  void onPanEnd(DragEndInfo info) {
    // TODO: implement onPanEnd
    super.onPanEnd(info);
    player.debugMode = false;
  }

  @override
  void onPanCancel() {
    // TODO: implement onPanCancel
    super.onPanCancel();
    player.debugMode = false;
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    if (!joystick.delta.isZero()) {
      //这里修改位置
      Vector2 ds = joystick.relativeDelta * player.speed * dt;
      player.move(ds);
    }

    // if (!joystick.delta.isZero()) {
    //   //这里是改旋转角度
    //   player.rotateTo(joystick.delta.screenAngle());
    // } else {
    //   player.rotateTo(0);
    // }
  }
}
