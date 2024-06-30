import 'dart:math';
import 'dart:ui';

class ColorUtil {
  /// 获取随机颜色
  static Color random() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  /// 获取随机深色
  static Color randomDarkColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(100) + 50,
      random.nextInt(100) + 50,
      random.nextInt(100) + 50,
    );
  }

  /// 获取除指定颜色之外的随机颜色
  static Color randomExcluding({List<Color>? excludeColors}) {
    final Random random = Random();
    Color color;
    excludeColors ??= [];
    do {
      color = Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
      color = ColorUtil.random();
    } while (excludeColors.contains(color));
    return color;
  }
}
