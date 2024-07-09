import 'package:flutter_rainbow_music/base/utils/eventbus_util.dart';
import 'package:flutter_rainbow_music/base/utils/sp_util.dart';
import 'package:flutter_rainbow_music/model/user_model.dart';

class UserManager {
  UserManager._internal();
  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;

  static Future<void> init() async {
    await _instance.readLocalUserInfo();
  }

  final String userInfoKey = 'userInfoKey';
  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  Future<void> readLocalUserInfo() async {
    _userModel = await SpUtil()
        .getModel(userInfoKey, (json) => UserModel.fromJson(json));
  }

  static bool isLogin() {
    return UserManager().userModel == null ? false : true;
  }

  void login(UserModel userInfo) {
    updateUserInfo(userInfo);
    saveUserInfoLocal();
    eventBus.fire(LoginStateEvent(true));
  }

  void logout() {
    clearUserInfo();
    eventBus.fire(LoginStateEvent(false));
  }

  void saveUserInfoLocal() async {
    if (_userModel == null) {
      return;
    }
    await SpUtil().saveModel(userInfoKey, _userModel);
  }

  void updateUserInfo(UserModel? userInfo) {
    _userModel = userInfo;
  }

  void clearUserInfo() {
    updateUserInfo(null);
    SpUtil().remove(userInfoKey);
  }

  void addFavoriteSong() {}
}
