import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences便捷使用工具
class SpUtil {
  /// 私有的命名构造函数
  SpUtil._internal();

  /// 单例实例
  static final SpUtil _instance = SpUtil._internal();

  /// 工厂构造函数，返回单例实例
  factory SpUtil() => _instance;

  /// 初始化SharedPreferences
  static Future<void> init() async {
    _instance._prefs = await SharedPreferences.getInstance();
  }

  late SharedPreferences _prefs;

  /// 移除模型对象
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  /// 保存模型对象
  Future<void> saveModel<T>(String key, T model) async {
    final jsonString = json.encode(model);
    final result = await _prefs.setString(key, jsonString);
    print('数据保存: ${result ? '成功' : '失败'}');
  }

  /// 获取模型对象
  Future<T?> getModel<T>(
      String key, T Function(Map<String, dynamic>) fromJson) async {
    final jsonString = _prefs.getString(key);
    if (jsonString == null) {
      return null;
    }
    final jsonMap = json.decode(jsonString);
    return fromJson(jsonMap);
  }

  /// 保存List
  Future<void> saveList<T>(String key, List<T> list) async {
    final jsonString = json.encode(list);
    await _prefs.setString(key, jsonString);
  }

  /// 获取List
  List<T>? getList<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    final jsonString = _prefs.getString(key);
    if (jsonString == null) {
      return null;
    }
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }

  /// 保存Map
  Future<void> saveMap<K, V>(String key, Map<K, V> map) async {
    final jsonString = json.encode(map);
    await _prefs.setString(key, jsonString);
  }

  /// 获取Map
  Map<K, V>? getMap<K, V>(String key, K Function(dynamic) keyFromJson,
      V Function(dynamic) valueFromJson) {
    final jsonString = _prefs.getString(key);
    if (jsonString == null) {
      return null;
    }
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return jsonMap
        .map((key, value) => MapEntry(keyFromJson(key), valueFromJson(value)));
  }
}
