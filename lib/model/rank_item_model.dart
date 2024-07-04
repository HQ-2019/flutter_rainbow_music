import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_rainbow_music/manager/player/provider/music_provider.dart';
import 'package:flutter_rainbow_music/model/song_info_model.dart';
import 'package:flutter_rainbow_music/model/song_item_model.dart';

class RankItemModel {
  RankItemModel({
    String? rankname,
    String? albumImg9,
    String? tablePlaque,
    num? updateFrequencyType,
    num? playTimes,
    num? ranktype,
    num? classify,
    num? id,
    String? jumpUrl,
    String? intro,
    String? banner7url,
    int? rankid,
    String? jumpTitle,
    num? isTiming,
    String? rankIdPublishDate,
    String? imgurl,
    List<SongItemModel>? songinfo,
  });

  RankItemModel.fromJson(dynamic json) {
    rankname = json['rankname'];
    albumImg9 = json['album_img_9']?.replaceAll('/{size}', '');
    tablePlaque = json['table_plaque'];
    updateFrequencyType = json['update_frequency_type'];
    playTimes = json['play_times'];
    ranktype = json['ranktype'];
    classify = json['classify'];
    id = json['id'];
    jumpUrl = json['jump_url'];
    intro = json['intro'];
    banner7url = json['banner7url']?.replaceAll('/{size}', '');
    rankid = json['rankid'];
    jumpTitle = json['jump_title'];
    isTiming = json['is_timing'];
    rankIdPublishDate = json['rank_id_publish_date'];
    imgurl = json['imgurl']?.replaceAll('/{size}', '');
    final songList = json['songinfo'] ?? json['songs'];
    if (songList != null) {
      songs = SongItemModel.fromSpecialJsonList(songList);
    }
  }

  static List<RankItemModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => RankItemModel.fromJson(json)).toList();
  }

  String? rankname;
  String? albumImg9;
  String? tablePlaque;
  num? updateFrequencyType;
  num? playTimes;
  num? ranktype;
  num? classify;
  num? id;
  String? jumpUrl;
  String? intro;
  String? banner7url;
  int? rankid;
  String? jumpTitle;
  num? isTiming;
  String? rankIdPublishDate;
  String? imgurl;
  List<SongItemModel>? songs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['rankname'] = rankname;
    map['album_img_9'] = albumImg9;
    map['table_plaque'] = tablePlaque;
    map['update_frequency_type'] = updateFrequencyType;
    map['play_times'] = playTimes;
    map['ranktype'] = ranktype;
    map['classify'] = classify;
    map['id'] = id;
    map['jump_url'] = jumpUrl;
    map['intro'] = intro;
    map['banner7url'] = banner7url;
    map['rankid'] = rankid;
    map['jump_title'] = jumpTitle;
    map['is_timing'] = isTiming;
    map['rank_id_publish_date'] = rankIdPublishDate;
    map['imgurl'] = imgurl;
    if (songs != null) {
      map['songs'] = songs?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

// class RankSongItemModel extends MusicProvider {
//   RankSongItemModel(
//       {String? hash,
//       String? name,
//       String? songname,
//       String? album_sizable_cover,
//       double playProgress = 0.0,
//       bool isSelected = false,
//       PlayerState playState = PlayerState.stopped,
//       SongInfoModel? songDetail});
//
//   RankSongItemModel.fromJson(dynamic json) {
//     hash = json['trans_param']?['ogg_320_hash'] ?? json['hash'];
//     singername = json['author'] ?? json['h5_author_name'] ?? json['singername'];
//     songname = json['name'] ?? json['songname'];
//     album_sizable_cover =
//         json['album_sizable_cover']?.replaceAll('/{size}', '');
//
//     var authors = json['authors'];
//     if (album_sizable_cover == null && authors is List) {
//       List<dynamic> authorList = authors;
//       if (authorList.isNotEmpty && authorList.first is Map) {
//         album_sizable_cover =
//             authorList.first['sizable_avatar']?.replaceAll('/{size}', '');
//       }
//     }
//   }
//
//   static List<RankSongItemModel> fromJsonList(List<dynamic> jsonList) {
//     return jsonList.map((json) => RankSongItemModel.fromJson(json)).toList();
//   }
//
//   String? hash;
//   String? singername;
//   String? songname;
//   String? album_sizable_cover;
//
//   double playProgress = 0.0;
//   bool isSelected = false;
//   PlayerState playState = PlayerState.stopped;
//   SongInfoModel? songDetail;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['hash'] = hash;
//     map['singername'] = singername;
//     map['songname'] = songname;
//     map['album_sizable_cover'] = album_sizable_cover;
//     map['playProgress'] = playProgress;
//     return map;
//   }
//
//   @override
//   String? fetchCoverUrl() {
//     return album_sizable_cover;
//   }
//
//   @override
//   String? fetchHash() {
//     return hash;
//   }
//
//   @override
//   String? fetchSongName() {
//     return songname;
//   }
//
//   @override
//   String? fetchSongUrl() {
//     return songDetail?.url;
//   }
//
//   @override
//   String? fetchSingerName() {
//     return singername;
//   }
//
//   @override
//   double fetchPlayProgress() {
//     return playProgress;
//   }
//
//   @override
//   bool fetchIsSelected() {
//     return isSelected;
//   }
//
//   @override
//   PlayerState fetchPlayState() {
//     return playState;
//   }
//
//   @override
//   void updateSongDetail(SongInfoModel value) {
//     songDetail = value;
//   }
//
//   @override
//   void updatePlayState(PlayerState state) {
//     playState = state;
//   }
//
//   @override
//   void updateSelected(bool selected) {
//     isSelected = selected;
//   }
// }
