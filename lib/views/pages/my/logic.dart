import 'dart:async';

import 'package:flutter_rainbow_music/base/utils/eventbus_util.dart';
import 'package:flutter_rainbow_music/dao/favorite_song_db.dart';
import 'package:flutter_rainbow_music/manager/user/user_manager.dart';
import 'package:get/get.dart';

class MyPageLogic extends GetxController {
  int favoriteCount = 0;
  int downloadCount = 0;
  int playCount = 0;

  @override
  void onReady() {
    super.onReady();

    handleUserLoginStateChanged();

    eventBus.on<LoginStateEvent>().listen((event) {
      handleUserLoginStateChanged(isLogin: event.isLogin);
    });

    eventBus.on<FavoriteSongChangedEvent>().listen((event) {
      int count = event.list.length;
      if (favoriteCount != count) {
        favoriteCount = count;
        update();
      }
    });
  }

  Future<void> handleUserLoginStateChanged({bool? isLogin}) async {
    final login = isLogin ?? UserManager.isLogin();
    if (!login) {
      favoriteCount = 0;
      update();
      return;
    }

    final phone = UserManager().user?.phone;
    if (phone != null) {
      favoriteCount = await FavoriteSongDB.getFavoriteCount(phone);
    }

    update();
  }
}
