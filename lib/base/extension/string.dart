extension ImageString on String {
  static String get _defaultPath => 'assets/images/';

  static String imagePath({String? path, required String name}) {
    return path ?? _defaultPath + name;
  }
}
