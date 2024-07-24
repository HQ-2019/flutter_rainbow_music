import 'dart:async';

import 'package:flutter_rainbow_music/base/utils/eventbus_util.dart';
import 'package:flutter_rainbow_music/dao/favorite_song_db.dart';
import 'package:flutter_rainbow_music/dao/played_song_db.dart';
import 'package:flutter_rainbow_music/manager/player/eventbus/player_event.dart';
import 'package:flutter_rainbow_music/manager/user/user_manager.dart';
import 'package:get/get.dart';

class MyPageLogic extends GetxController {
  int favoriteCount = 0;
  int downloadCount = 0;
  int playedCount = 0;

  StreamSubscription? _favoriteSongChangeSubscription;
  StreamSubscription? _playChangeSubscription;
  StreamSubscription? _loginStateChangeSubscription;

  @override
  void dispose() {
    _favoriteSongChangeSubscription?.cancel();
    _playChangeSubscription?.cancel();
    _loginStateChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  void onReady() {
    super.onReady();

    handleUserLoginStateChanged();
    readPlayedSongsCount();

    _loginStateChangeSubscription =
        eventBus.on<LoginStateEvent>().listen((event) {
      handleUserLoginStateChanged(isLogin: event.isLogin);
    });

    _favoriteSongChangeSubscription =
        eventBus.on<FavoriteSongChangedEvent>().listen((event) {
      int count = event.list.length;
      if (favoriteCount != count) {
        favoriteCount = count;
        update();
      }
    });

    _playChangeSubscription = eventBus.on<MusicPlayEvent>().listen((event) {
      readPlayedSongsCount();
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

  Future<void> readPlayedSongsCount() async {
    playedCount = await PlayedSongDB.getPlayedSongsCount();
    update();
  }
}
