import 'dart:async';

import 'package:flutter_rainbow_music/base/utils/eventbus_util.dart';
import 'package:flutter_rainbow_music/dao/favorite_song_db.dart';
import 'package:flutter_rainbow_music/manager/player/eventbus/player_event.dart';
import 'package:flutter_rainbow_music/manager/player/player_manager.dart';
import 'package:flutter_rainbow_music/manager/user/user_manager.dart';
import 'package:flutter_rainbow_music/model/song_item_model.dart';
import 'package:get/get.dart';

class LocalSongsLogic extends GetxController {
  List<SongItemModel> songs = [];

  StreamSubscription? _songsChangeSubscription;
  StreamSubscription? _playChangeSubscription;

  @override
  void dispose() {
    _songsChangeSubscription?.cancel();
    _playChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  void onReady() {
    super.onReady();

    readFavoriteSongList();

    _songsChangeSubscription =
        eventBus.on<FavoriteSongChangedEvent>().listen((event) {
      update();
    });

    _playChangeSubscription = eventBus.on<MusicPlayEvent>().listen((event) {
      updatePlayingItem(event.musicProvider.fetchHash());
    });
  }

  void updatePlayingItem(String? hash) {
    if (hash == null) {
      return;
    }
    for (var element in songs) {
      element.isSelected = element.hash != null && element.hash == hash;
    }
    update();
  }

  Future<void> readFavoriteSongList() async {
    final phone = UserManager().user?.phone;
    if (phone == null) {
      return;
    }
    final songList = await FavoriteSongDB.getFavoriteList(phone);
    if (songList == null) {
      return;
    }
    songs = songList;

    final playSong = PlayerManager().currentSong;
    if (playSong != null && songs.isNotEmpty) {
      for (var element in songs) {
        if (element.hash == playSong.fetchHash()) {
          element.playState = playSong.fetchPlayState();
          element.isSelected = playSong.fetchIsSelected();
          element.playProgress = playSong.fetchPlayProgress();
        }
      }
    }

    update();
  }

  void updateFavoriteSong(SongItemModel song) async {
    songs.removeWhere((element) => element.hash == song.hash);
    await UserManager().updateFavoriteSong(song);
  }
}
