import 'package:flutter_rainbow_music/base/utils/eventbus_util.dart';
import 'package:flutter_rainbow_music/dao/favorite_song_db.dart';
import 'package:flutter_rainbow_music/manager/player/eventbus/player_event.dart';
import 'package:flutter_rainbow_music/manager/player/player_manager.dart';
import 'package:flutter_rainbow_music/manager/user/user_manager.dart';
import 'package:flutter_rainbow_music/model/song_item_model.dart';
import 'package:get/get.dart';

class DownloadPageLogic extends GetxController {
  List<SongItemModel> songs = [];

  @override
  void onReady() {
    super.onReady();

    readFavoriteSongList();

    // 收藏歌曲变更监听
    eventBus.on<FavoriteSongChangedEvent>().listen((event) {
      update();
    });

    // 监听播放音乐
    eventBus.on<MusicPlayEvent>().listen((event) {
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
