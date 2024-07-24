import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rainbow_music/base/utils/eventbus_util.dart';
import 'package:flutter_rainbow_music/manager/player/eventbus/player_event.dart';
import 'package:flutter_rainbow_music/manager/player/player_manager.dart';
import 'package:flutter_rainbow_music/manager/player/provider/music_provider.dart';
import 'package:flutter_rainbow_music/manager/user/user_manager.dart';
import 'package:flutter_rainbow_music/model/song_item_model.dart';
import 'package:get/get.dart';

class SongPlayPageLogic extends GetxController {
  MusicProvider? song;
  String? songsSource;

  StreamSubscription? _favoriteSongChangeSubscription;
  StreamSubscription? _playChangeSubscription;

  @override
  void dispose() {
    _favoriteSongChangeSubscription?.cancel();
    _playChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  void onReady() {
    super.onReady();

    song = PlayerManager().currentSong;
    update();

    // 监听播放音乐
    _playChangeSubscription = eventBus.on<MusicPlayEvent>().listen((event) {
      song = event.musicProvider;
      update();
    });

    // 收藏歌曲变更监听
    _favoriteSongChangeSubscription =
        eventBus.on<FavoriteSongChangedEvent>().listen((event) {
      update();
    });
  }

  void play() {
    if (song != null) {
      PlayerManager().play(song!);
    }
  }

  void playLast() {
    PlayerManager().playLast();
  }

  void playNext() {
    PlayerManager().playNext();
  }

  void changePlayMode() {
    PlayerManager().changePlaybackModel();
    update();
  }

  IconData fetchPlayModeIcon() {
    return PlayerManager().fetchPlayModeIcon();
  }

  void updateFavoriteSong(MusicProvider? song) async {
    if (song == null || song is! SongItemModel) {
      return;
    }
    await UserManager().updateFavoriteSong(song);
  }
}
