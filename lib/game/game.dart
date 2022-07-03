import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_work/game/component.dart';

class MiniGame extends FlameGame {
  @override
  Future<void>? onLoad() async {
    print("Game onLoad");
    await add(HeroComponent());
    FlameAudio.play("background.mp3");
    return super.onLoad();
  }
}
