import 'dart:async';

import 'package:flutter_rainbow_music/base/loading/loading.dart';
import 'package:flutter_rainbow_music/base/utils/eventbus_util.dart';
import 'package:flutter_rainbow_music/manager/player/eventbus/player_event.dart';
import 'package:flutter_rainbow_music/model/recommend_model.dart';
import 'package:flutter_rainbow_music/api/api.dart';
import 'package:flutter_rainbow_music/base/network/http_response_model.dart';
import 'package:flutter_rainbow_music/base/network/network_manager.dart';
import 'package:flutter_rainbow_music/manager/player/player_manager.dart';
import 'package:get/get.dart';

class RecommendPageLogic extends GetxController {
  RecommendModel model = RecommendModel();

  bool isNewSongExpan = false;

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
    fetchRecommendInfo(showLoading: true);

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

  void updateNewsongExpan() {
    isNewSongExpan = !isNewSongExpan;
    update();
  }

  void updatePlayingItem(String? hash) {
    if (hash == null) {
      return;
    }
    model.data?.forEach((element) {
      element.isSelected = element.hash != null && element.hash == hash;
    });

    update();
  }

  void fetchRecommendInfo({bool? showLoading}) async {
    if (showLoading == true) {
      Loading.show(status: '好歌要来了...');
    }
    HttpResponseModel response = await NetworkManager().recommend();
    if (response.data != null) {
      model = response.data;
    }

    final playingHash = PlayerManager().currentSong?.fetchHash();
    if (playingHash != null) {
      updatePlayingItem(playingHash);
    } else {
      update();
    }

    if (showLoading == true && !response.success) {
      Loading.showToast(response.message);
    } else {
      Loading.dismiss();
    }
  }

  void fetchSpecailItemInfo(int id) async {
    HttpResponseModel response = await NetworkManager().specailInfo(id);
    print(response.data);
  }
}
