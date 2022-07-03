import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_work/game/component.dart';

class MiniGame extends FlameGame with HasDraggables {
  final Paint paint = Paint()..color = const Color.fromARGB(255, 35, 36, 38);
  final Path canvasPath = Path();
  late TargetComponent target;
  bool isDrag = false;
  @override
  Future<void>? onLoad() {
    print("Game onLoad");
    canvasPath.addRect(Rect.fromLTWH(0, 0, canvasSize.x, canvasSize.y));
    target =
        TargetComponent(position: Vector2(canvasSize.x / 2, canvasSize.y / 2));
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawPath(canvasPath, paint);
    target.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    super.onDragStart(pointerId, info);
    Path p = Path();
    p.addRect(Rect.fromCircle(
        center: target.position.toOffset(), radius: target.radius));
    if (p.contains(info.eventPosition.game.toOffset())) {
      isDrag = true;
    }
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    super.onDragUpdate(pointerId, info);
    print("onDragUpdate");
    print(isDrag);
    var eventPosition = info.eventPosition.game;
    if (eventPosition.x < target.radius ||
        eventPosition.x > canvasSize.x - target.radius ||
        eventPosition.y < target.radius ||
        eventPosition.y > canvasSize.y - target.radius) {
      return;
    }
    if (isDrag) {
      return;
    }
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    super.onDragEnd(pointerId, info);
    isDrag = false;
  }

  @override
  void onDragCancel(int pointerId) {
    super.onDragCancel(pointerId);
    isDrag = false;
  }

  @override
  void onRemove() {
    super.onRemove();
    print("Game onRemove");
  }
}
