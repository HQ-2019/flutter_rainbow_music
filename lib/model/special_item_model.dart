import 'package:flutter_rainbow_music/model/rank_item_model.dart';

/// 专属歌单
class SpecialItemModel {
  SpecialItemModel({
    this.specialid,
    this.playcount,
    this.songcount,
    this.publishtime,
    this.url,
    this.collectcount,
    this.userType,
    this.username,
    this.singername,
    this.specialname,
    this.userAvatar,
    this.isSelected,
    this.intro,
    this.imgurl,
    this.songs,
  });

  SpecialItemModel.fromJson(dynamic json) {
    specialid = json['specialid'];
    playcount = json['playcount'];
    songcount = json['songcount'];
    publishtime = json['publishtime'] ?? json['publish_time'];
    url = json['url'];
    collectcount = json['collectcount'];
    userType = json['user_type'];
    username = json['username'];
    singername = json['singername'];
    specialname = json['specialname'] ?? json['name'];
    userAvatar = json['user_avatar'];
    isSelected = json['is_selected'];
    intro = json['intro'];
    imgurl = json['imgurl']?.replaceAll('/{size}', '');
    if (json['songs'] != null) {
      songs = [];
      json['songs'].forEach((v) {
        songs?.add(RankSongItemModel.fromJson(v));
      });
    }
  }

  static List<SpecialItemModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SpecialItemModel.fromJson(json)).toList();
  }

  int? specialid;
  int? playcount;
  int? songcount;
  String? publishtime;
  String? url;
  int? collectcount;
  int? userType;
  String? username;
  String? singername;
  String? specialname;
  String? userAvatar;
  int? isSelected;
  String? intro;
  String? imgurl;
  List<RankSongItemModel>? songs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['specialid'] = specialid;
    map['playcount'] = playcount;
    map['songcount'] = songcount;
    map['publishtime'] = publishtime;
    map['url'] = url;
    map['collectcount'] = collectcount;
    map['user_type'] = userType;
    map['username'] = username;
    map['singername'] = singername;
    map['specialname'] = specialname;
    map['user_avatar'] = userAvatar;
    map['is_selected'] = isSelected;
    map['intro'] = intro;
    map['imgurl'] = imgurl;
    if (songs != null) {
      map['songs'] = songs?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
