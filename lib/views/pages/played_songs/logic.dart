import 'dart:async';

import 'package:flutter_rainbow_music/base/utils/eventbus_util.dart';
import 'package:flutter_rainbow_music/dao/played_song_db.dart';
import 'package:flutter_rainbow_music/manager/player/eventbus/player_event.dart';
import 'package:flutter_rainbow_music/manager/player/player_manager.dart';
import 'package:flutter_rainbow_music/manager/user/user_manager.dart';
import 'package:flutter_rainbow_music/model/song_item_model.dart';
import 'package:get/get.dart';

class PlayedSongsPageLogic extends GetxController {
  List<SongItemModel> songs = [];
  Map<String, dynamic> playCount = {};

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

    readPlayedSongs();

    // 收藏歌曲变更监听
    _favoriteSongChangeSubscription =
        eventBus.on<FavoriteSongChangedEvent>().listen((event) {
      update();
    });

    // 监听播放音乐
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

    playCount[hash] = playCount[hash] + 1;

    update();
  }

  Future<void> readPlayedSongs() async {
    final songList = await PlayedSongDB.getPlayedSongs();
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

    final playCountList = await PlayedSongDB.getPlayedRecords();
    for (var element in playCountList) {
      playCount[element['song_hash']] = element['play_count'];
    }

    update();
  }

  int? getPlayCount(String songHash) {
    return playCount[songHash];
  }

  void updateFavoriteSong(SongItemModel song) async {
    await UserManager().updateFavoriteSong(song);
  }

  void deletePlayedSong(SongItemModel song) async {
    final songHash = song.hash;
    if (songHash == null) {
      return;
    }
    songs.removeWhere((element) => element.hash == songHash);
    await PlayedSongDB.deletePlayedSong(songHash);
  }
}
