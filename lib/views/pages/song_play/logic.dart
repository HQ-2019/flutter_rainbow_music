import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rainbow_music/base/utils/eventbus_util.dart';
import 'package:flutter_rainbow_music/manager/player/eventbus/player_event.dart';
import 'package:flutter_rainbow_music/manager/player/player_manager.dart';
import 'package:flutter_rainbow_music/manager/player/provider/music_provider.dart';
import 'package:get/get.dart';

class SongPlayPageLogic extends GetxController {
  MusicProvider? song;
  String? songsSource;
  StreamSubscription? playSubscription;

  @override
  void onReady() {
    super.onReady();

    song = PlayerManager().currentSong;
    update();

    // 监听播放音乐
    playSubscription = eventBus.on<MusicPlayEvent>().listen((event) {
      song = event.musicProvider;
      update();
    });
  }

  void play() {
    if (song != null) {
      PlayerManager().play(song!);
    }
  }

  void playLast() {
    PlayerManager().playlast();
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
}
