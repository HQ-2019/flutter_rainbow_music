import 'dart:async';
import 'dart:math';

import 'package:flutter_rainbow_music/base/utils/eventbus_util.dart';
import 'package:flutter_rainbow_music/manager/player/eventbus/player_event.dart';
import 'package:flutter_rainbow_music/manager/player/player_manager.dart';
import 'package:flutter_rainbow_music/manager/player/provider/music_provider.dart';
import 'package:flutter_rainbow_music/manager/user/user_manager.dart';
import 'package:flutter_rainbow_music/model/song_item_model.dart';
import 'package:get/get.dart';

class PlaylistPageLogic extends GetxController {
  List<MusicProvider> songs = [];
  String? songsSource;
  List<String> playedList = [];
  List<String> selectedList = [];

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

    songsSource = PlayerManager().playlistSource;

    if (PlayerManager().playlist != null) {
      songs.addAll(PlayerManager().playlist);
      final playHash = PlayerManager().currentSong?.fetchHash();
      if (playHash != null) {
        playedList.add(playHash);
      }
      update();
    }

    // 监听播放音乐
    _playChangeSubscription = eventBus.on<MusicPlayEvent>().listen((event) {
      updatePlayingItem(event.musicProvider.fetchHash());
    });

    // 收藏歌曲变更监听
    _favoriteSongChangeSubscription =
        eventBus.on<FavoriteSongChangedEvent>().listen((event) {
      update();
    });
  }

  int playSongIndex() {
    final playHash = PlayerManager().currentSong?.fetchHash();
    int index = 0;
    if (playHash != null) {
      index = songs.indexWhere((song) => song.fetchHash() == playHash);
    }
    return max(0, index);
  }

  void updatePlayingItem(String? hash) {
    if (hash == null) {
      return;
    }

    // 更新状态
    for (var element in songs) {
      element.updateSelected(
          element.fetchHash() != null && element.fetchHash() == hash);
    }

    // 更新已播放列表
    if (!playedList.contains(hash)) {
      playedList.add(hash);
    }

    update();
  }

  void removeSong(MusicProvider song) {
    songs.remove(song);
    PlayerManager().removePlaySong(song);
    final hash = song.fetchHash();
    playedList.remove(hash);
    selectedList.remove(hash);
    update();
  }

  void removePlaylist() {
    final list = songs
        .where((element) => selectedList.contains(element.fetchHash()))
        .toList();
    if (list.isEmpty) {
      return;
    }
    songs.removeWhere(
        (element) => list.any((b) => b.fetchHash() == element.fetchHash()));
    PlayerManager().removePlayList(list);
    selectedList.clear();
    update();
  }

  void cleanPlaylist() {
    songs.clear();
    playedList.clear();
    selectedList.clear();
    PlayerManager().cleanPlayList();
    update();
  }

  bool isSelectedSong(String hash) {
    return selectedList.contains(hash);
  }

  void updateSelectedList(String? hash) {
    if (hash == null) {
      return;
    }
    bool isExists = selectedList.contains(hash);
    isExists ? selectedList.remove(hash) : selectedList.add(hash);
    update();
  }

  void updateFavoriteSong(MusicProvider? song) async {
    if (song == null || song is! SongItemModel) {
      return;
    }

    await UserManager().updateFavoriteSong(song);
  }
}
