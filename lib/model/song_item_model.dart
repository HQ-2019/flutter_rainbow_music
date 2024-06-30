import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_rainbow_music/manager/player/provider/music_provider.dart';
import 'package:flutter_rainbow_music/model/song_info_model.dart';

/// 新歌推荐
class SongItemModel implements MusicProvider {
  SongItemModel(
      {this.rankCount,
      this.feetype,
      this.hash,
      this.mvhash,
      this.recommendReason,
      this.payType,
      this.singerName,
      this.songName,
      this.album_sizable_cover,
      this.playProgress = 0.0,
      this.isSelected = false,
      this.playState = PlayerState.stopped,
      this.songDetail});

  SongItemModel.fromJson(dynamic json) {
    rankCount = json['rank_count'];
    feetype = json['feetype'];
    hash = json['hash'];
    mvhash = json['mvhash'];
    recommendReason = json['recommend_reason'];
    payType = json['pay_type'];
    singerName = json['singer_name'];
    songName = json['song_name'];
    album_sizable_cover =
        json['album_sizable_cover']?.replaceAll('/{size}', '');
    songDetail = json['song_detail'];
  }

  static List<SongItemModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SongItemModel.fromJson(json)).toList();
  }

  num? rankCount;
  num? feetype;
  String? hash;
  String? mvhash;
  String? recommendReason;
  num? payType;
  String? singerName;
  String? songName;
  String? album_sizable_cover;

  double playProgress = 0.0;
  bool isSelected = false;
  PlayerState playState = PlayerState.stopped;
  SongInfoModel? songDetail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['rank_count'] = rankCount;
    map['feetype'] = feetype;
    map['hash'] = hash;
    map['mvhash'] = mvhash;
    map['recommend_reason'] = recommendReason;
    map['pay_type'] = payType;
    map['singer_name'] = singerName;
    map['song_name'] = songName;
    map['album_sizable_cover'] = album_sizable_cover;
    map['song_detail'] = songDetail?.toJson();
    map['playProgress'] = playProgress;
    return map;
  }

  @override
  String? fetchCoverUrl() {
    return album_sizable_cover;
  }

  @override
  String? fetchHash() {
    return hash;
  }

  @override
  String? fetchSongName() {
    return songName;
  }

  @override
  String? fetchSongUrl() {
    return songDetail?.url;
  }

  @override
  String? fetchSingerName() {
    return singerName;
  }

  @override
  double fetchPlayProgress() {
    return playProgress;
  }

  @override
  bool fetchIsSelected() {
    return isSelected;
  }

  @override
  PlayerState fetchPlayState() {
    return playState;
  }

  @override
  void updateSongDetail(SongInfoModel value) {
    songDetail = value;
  }

  @override
  void updatePlayState(PlayerState state) {
    playState = state;
  }

  @override
  void updateSelected(bool selected) {
    isSelected = selected;
  }
}

extension RecommendSongItemModelExtension on SongItemModel {
  String? getCover() {
    return album_sizable_cover?.replaceAll('/{}', '');
  }
}
