import 'dart:async';

import 'package:flutter_rainbow_music/base/loading/loading.dart';
import 'package:flutter_rainbow_music/base/utils/eventbus_util.dart';
import 'package:flutter_rainbow_music/manager/player/eventbus/player_event.dart';
import 'package:flutter_rainbow_music/model/special_item_model.dart';
import 'package:flutter_rainbow_music/api/api.dart';
import 'package:flutter_rainbow_music/base/network/http_response_model.dart';
import 'package:flutter_rainbow_music/base/network/network_manager.dart';
import 'package:flutter_rainbow_music/manager/player/player_manager.dart';
import 'package:get/get.dart';

class SpecialPageLogic extends GetxController {
  int? specailId;
  SpecialItemModel? model;

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
    int specailId;
    if (this.specailId != null) {
      specailId = this.specailId!;
    } else {
      specailId = model?.specialid ?? 0;
    }
    fetchSpecailItemInfo(specailId);

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

  void updatePlayingItem(String? hash) {
    if (hash == null) {
      return;
    }
    model?.songs?.forEach((element) {
      element.isSelected = element.hash != null && element.hash == hash;
    });
    update();
  }

  void fetchSpecailItemInfo(int specailId) async {
    Loading.show(status: '数据加载中...');
    HttpResponseModel response = await NetworkManager().specailInfo(specailId);
    Loading.dismiss();
    if (response.data != null) {
      if (model == null) {
        model = response.data;
      } else {
        model?.songs = response.data.songs;
      }
    }
    final playingHash = PlayerManager().currentSong?.fetchHash();
    if (playingHash != null) {
      updatePlayingItem(playingHash);
    } else {
      update();
    }
  }
}
