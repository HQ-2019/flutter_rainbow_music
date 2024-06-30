import 'package:flutter_rainbow_music/model/special_item_model.dart';

class BannerModel {
  BannerModel({
    this.online,
    this.title,
    this.id,
    this.tourl,
    this.type,
    this.imgurl,
    this.extra,
  });

  BannerModel.fromJson(dynamic json) {
    online = json['online'];
    title = json['title'];
    id = json['id'];
    tourl = json['extra']['tourl'];
    type = json['type'];
    imgurl = json['imgurl'];

    if (json['extra'] != null) {
      extra = SpecialItemModel.fromJson(json['extra']!);
    }
  }

  static List<BannerModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => BannerModel.fromJson(json)).toList();
  }

  num? online;
  String? title;
  num? id;
  String? tourl;
  num? type;
  String? imgurl;
  SpecialItemModel? extra;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['online'] = online;
    map['title'] = title;
    map['id'] = id;
    map['tourl'] = tourl;
    map['type'] = type;
    map['imgurl'] = imgurl;
    map['extra'] = extra?.toJson();
    return map;
  }
}
