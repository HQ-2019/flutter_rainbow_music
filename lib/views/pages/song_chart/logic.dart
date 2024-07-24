import 'dart:async';

import 'package:flutter_rainbow_music/base/utils/eventbus_util.dart';
import 'package:flutter_rainbow_music/manager/player/eventbus/player_event.dart';
import 'package:flutter_rainbow_music/manager/user/user_manager.dart';
import 'package:flutter_rainbow_music/model/rank_item_model.dart';
import 'package:flutter_rainbow_music/api/api.dart';
import 'package:flutter_rainbow_music/base/network/http_response_model.dart';
import 'package:flutter_rainbow_music/base/network/network_manager.dart';
import 'package:flutter_rainbow_music/manager/player/player_manager.dart';
import 'package:get/get.dart';

class SongChartPageLogic extends GetxController {
  RankItemModel? model;

  int _page = 1;
  bool _isLoaing = false;

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
    fetchRankInfo(model?.rankid ?? 0);

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

  void fetchRankInfo(int id, {bool loadMore = false}) async {
    if (_isLoaing) {
      return;
    }
    _isLoaing = true;

    if (loadMore) {
      _page += 1;
    }

    HttpResponseModel response =
        await NetworkManager().rankInfo(rankId: id, page: _page);
    _isLoaing = false;

    if (response.data != null) {
      if (model == null || !loadMore) {
        model = response.data;
      } else {
        model!.songs?.addAll(response.data.songs);
      }
    } else if (loadMore) {
      _page -= 1;
    }

    final playingHash = PlayerManager().currentSong?.fetchHash();
    if (playingHash != null) {
      updatePlayingItem(playingHash);
    } else {
      update();
    }
  }
}
