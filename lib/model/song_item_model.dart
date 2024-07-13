import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_rainbow_music/base/utils/color_util.dart';
import 'package:flutter_rainbow_music/manager/player/provider/music_provider.dart';
import 'package:flutter_rainbow_music/model/song_detail_model.dart';

/// 新歌推荐
class SongItemModel implements MusicProvider {
  SongItemModel(
      {this.hash,
      this.mvhash,
      this.singerName,
      this.songName,
      this.coverUrl,
      this.playProgress = 0.0,
      this.payType,
      this.isSelected = false,
      this.playState = PlayerState.stopped,
      this.songDetail});

  SongItemModel.fromJson(dynamic json) {
    hash = json['hash'];
    mvhash = json['mvhash'];
    singerName = json['singer_name'];
    songName = json['song_name'];
    coverUrl = json['album_sizable_cover']?.replaceAll('/{size}', '');
    payType = json['pay_type'];
    final detail = json['song_detail'];
    if (detail != null) {
      songDetail = SongDetailModel.fromJson(detail);
    }
  }

  SongItemModel.fromSpecialJson(dynamic json) {
    hash = json['trans_param']?['ogg_320_hash'] ?? json['hash'];
    mvhash = json['mvhash'];
    singerName = json['author'] ?? json['h5_author_name'] ?? json['singername'];
    songName = json['name'] ?? json['songname'];
    coverUrl = json['album_sizable_cover']?.replaceAll('/{size}', '');
    var authors = json['authors'];
    if (coverUrl == null && authors is List) {
      List<dynamic> authorList = authors;
      if (authorList.isNotEmpty && authorList.first is Map) {
        coverUrl =
            authorList.first['sizable_avatar']?.replaceAll('/{size}', '');
      }
    }
    payType = json['pay_type'];
    final detail = json['song_detail'];
    if (detail != null) {
      songDetail = SongDetailModel.fromJson(detail);
    }
  }

  static List<SongItemModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SongItemModel.fromJson(json)).toList();
  }

  static List<SongItemModel> fromSpecialJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SongItemModel.fromSpecialJson(json)).toList();
  }

  String? hash;
  String? mvhash;
  String? singerName;
  String? songName;
  String? coverUrl;
  num? payType;

  double playProgress = 0.0;
  bool isSelected = false;
  PlayerState playState = PlayerState.stopped;
  SongDetailModel? songDetail;
  Color themeColor = ColorUtil.randomDarkColor();

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['hash'] = hash;
    map['mvhash'] = mvhash;
    map['singer_name'] = singerName;
    map['song_name'] = songName;
    map['album_sizable_cover'] = coverUrl;
    map['pay_type'] = payType;
    map['song_detail'] = songDetail?.toJson();
    return map;
  }

  @override
  String? fetchCoverUrl() {
    return coverUrl;
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
  Color fetchThemeColor() {
    return themeColor;
  }

  @override
  void updateSongDetail(SongDetailModel value) {
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

  @override
  MusicProvider clone() {
    return SongItemModel.fromJson(toJson());
  }
}

extension RecommendSongItemModelExtension on SongItemModel {
  String? getCover() {
    return coverUrl?.replaceAll('/{}', '');
  }
}
