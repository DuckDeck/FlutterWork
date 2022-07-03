import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_work/game/component.dart';

class MiniGame extends FlameGame with HasDraggables, KeyboardEvents {
  late final JoystickComponent joystick;
  late final HeroComponent player;
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
    FlameAudio.play("background.mp3");
    return super.onLoad();
  }

  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;
    if (event.logicalKey == LogicalKeyboardKey.keyY && isKeyDown) {
      print("keyY");
    }
    if (event.logicalKey == LogicalKeyboardKey.keyX && isKeyDown) {
      print("keyX");
    }
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    // if (!joystick.delta.isZero()) {  //这里修改位置
    //   Vector2 ds = joystick.relativeDelta * player.speed * dt;
    //   player.move(ds);
    // }

    if (!joystick.delta.isZero()) {
      //这里是改旋转角度
      player.rotateTo(joystick.delta.screenAngle());
    } else {
      player.rotateTo(0);
    }
  }
}
