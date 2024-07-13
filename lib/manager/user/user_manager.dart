import 'package:flutter_rainbow_music/base/utils/eventbus_util.dart';
import 'package:flutter_rainbow_music/base/utils/sp_util.dart';
import 'package:flutter_rainbow_music/dao/favorite_song_db.dart';
import 'package:flutter_rainbow_music/dao/song_db.dart';
import 'package:flutter_rainbow_music/model/song_item_model.dart';
import 'package:flutter_rainbow_music/model/user_model.dart';

class UserManager {
  UserManager._internal();
  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;

  static Future<void> init() async {
    await _instance.readLocalUserInfo();
    await _instance.readLocalFavoriteSongHash();
  }

  final String userInfoKey = 'userInfoKey';

  UserModel? _user;
  UserModel? get user => _user;

  List<String> _favoriteList = [];
  List<String> get favoriteList => _favoriteList;

  Future<void> readLocalUserInfo() async {
    _user = await SpUtil()
        .getModel(userInfoKey, (json) => UserModel.fromJson(json));
  }

  static bool isLogin() {
    return UserManager().user == null ? false : true;
  }

  void login(UserModel userInfo) {
    updateUserInfo(userInfo);
    saveUserInfoLocal();
    readLocalFavoriteSongHash();
    eventBus.fire(LoginStateEvent(true));
  }

  void logout() {
    clearUserInfo();
    eventBus.fire(LoginStateEvent(false));
  }

  void saveUserInfoLocal() async {
    if (_user == null) {
      return;
    }
    await SpUtil().saveModel(userInfoKey, _user);
  }

  void updateUserInfo(UserModel? userInfo) {
    _user = userInfo;
  }

  void clearUserInfo() {
    updateUserInfo(null);
    SpUtil().remove(userInfoKey);

    _favoriteList.clear();
    eventBus.fire(FavoriteSongChangedEvent(_favoriteList));
  }

  Future<void> updateFavoriteSong(SongItemModel song) async {
    final phone = user?.phone;
    final songHash = song.hash;
    if (phone != null && songHash != null) {
      if (_favoriteList.contains(songHash)) {
        // 取消收藏
        _favoriteList.remove(songHash);
        await FavoriteSongDB.deleteFavoriteSong(phone, songHash);
      } else {
        // 添加收藏
        _favoriteList.add(songHash);
        await FavoriteSongDB.addFavoriteSong(
          phone: phone,
          songHash: songHash,
          song: song,
        );
      }
      eventBus.fire(FavoriteSongChangedEvent(_favoriteList));
    }
  }

  Future<void> readLocalFavoriteSongHash() async {
    final phone = user?.phone;
    if (phone == null) {
      return;
    }
    final list = await FavoriteSongDB.getFavoriteSongHashList(phone);
    if (list != null && list.isNotEmpty) {
      _favoriteList = list;
    }
  }

  bool isFavoriteSong(String? songHash) {
    if (songHash == null ||
        _user == null ||
        !_favoriteList.contains(songHash)) {
      return false;
    }
    return true;
  }
}
