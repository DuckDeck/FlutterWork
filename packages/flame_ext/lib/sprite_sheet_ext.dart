import 'package:flame/sprite.dart';

extension SpriteSheetEx on SpriteSheet {
  /// 获取指定索引区间的 [Sprite] 列表
  /// [row] : 第几行
  /// [start] : 第几个开始
  /// [count] : 有几个
  List<Sprite> getRowSprites(
      {required int row, int start = 0, required count}) {
    return List.generate(count, (index) => getSprite(row, start + index))
        .toList();
  }
}
