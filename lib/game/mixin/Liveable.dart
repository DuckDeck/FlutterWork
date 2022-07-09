import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_work/game/compoment/DamageText.dart';

mixin Liveable on PositionComponent {
  final Paint _outlinePaint = Paint();
  final Paint _fillPaint = Paint();
  late double lifePoint; // 生命上限
  late double _currentLife; // 当前生命值
  final double offsetY = 10;
  final double widthRadio = 1.5;
  final double lifeBarHeight = 4;

  final TextStyle _defaultTextStyle =
      const TextStyle(fontSize: 10, color: Colors.white);
  late final TextComponent _text;
  final DamageText _damageText = DamageText();
  void initPaint(
      {required double lifePoint,
      Color lifeColor: Colors.red,
      Color outlineColor = Colors.white}) {
    _outlinePaint
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    _fillPaint.color = lifeColor;
    this.lifePoint = lifePoint;
    _currentLife = lifePoint;

    _text = TextComponent(textRenderer: TextPaint(style: _defaultTextStyle));
    _updateLiftText();
    double y = -(offsetY + _text.height + 2);
    double x = (size.x / 2) * (widthRadio - 1);
    _text.position = Vector2(x, y);
    _text.add(RectangleHitbox()..debugMode = true);
    add(_text);
    add(_damageText);
  }

  double get _progress => _currentLife / lifePoint;

  @override
  void render(Canvas canvas) {
    // TODO: implement render
    super.render(canvas);
    Rect rect = Rect.fromCenter(
        center: Offset(size.x / 2, lifeBarHeight / 2 - offsetY),
        width: size.x / 2 * widthRadio,
        height: lifeBarHeight);
    Rect lifeRect = Rect.fromPoints(
        rect.topLeft + Offset(rect.width * (1 - _progress), 0),
        rect.bottomRight);
    canvas.drawRect(lifeRect, _fillPaint);
    canvas.drawRect(rect, _outlinePaint);
  }

  void _updateLiftText() {
    _text.text = 'hp ${_currentLife.toInt()}';
  }

  void loss(double point) {
    _currentLife -= point;
    _updateLiftText();
    _damageText.addDamage(-point.toInt());
    if (_currentLife <= 0) {
      _currentLife = 0;
      onDied();
    }
  }

  void onDied() {}
}
