import 'dart:convert';

import 'package:flutter_rainbow_music/model/rank_item_model.dart';
import 'package:flutter_rainbow_music/model/special_item_model.dart';
import 'package:html/parser.dart';
import 'package:flutter_rainbow_music/model/recommend_model.dart';
import 'package:flutter_rainbow_music/model/song_detail_model.dart';
import 'package:flutter_rainbow_music/base/network/http_response_model.dart';
import 'package:flutter_rainbow_music/base/network/network_manager.dart';
import 'package:dio/dio.dart';

extension Api on NetworkManager {
  Future<HttpResponseModel> recommend() async {
    HttpResponseModel response =
        await NetworkManager().get('http://m.kugou.com/?json=true');

    if (response.data == null) {
      return HttpResponseModel.failure(
          code: response.code, message: response.message);
    }

    Map<String, dynamic> dataMap = json.decode(response.data);
    Map<String, dynamic> m = {};
    m['banner'] = dataMap['banner'];
    m['data'] = dataMap['data'];
    m['special'] = dataMap['special']['list']['info'];
    m['rankList'] = dataMap['rank']['list'];
    HttpResponseModel r = HttpResponseModel.success(RecommendModel.fromJson(m));
    return r;
  }

  Future<HttpResponseModel> songDetail(String hash) async {
    HttpResponseModel response = await NetworkManager().get(
        'https://m.kugou.com/app/i/getSongInfo.php',
        params: {'cmd': 'playInfo', 'hash': hash});
    Map<String, dynamic> map = json.decode(response.data);
    HttpResponseModel r =
        HttpResponseModel.success(SongDetailModel.fromJson(map));
    return r;
  }

  Future<HttpResponseModel> specailInfo(int specail) async {
    HttpResponseModel response = await NetworkManager()
        .get('http://m.kugou.com/plist/list/${specail}', params: {
      'json': true
    }, headers: {
      'User-Agent':
          'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
      'Accept': 'application/json',
    });
    Map<String, dynamic> map = {};

    // 该接口返回的是一个html,需要自行解析截取对应的数据
    var document = parse(response.data);
    var scriptTags = document.getElementsByTagName('script');

    for (var script in scriptTags) {
      if (script.text.contains('var specialInfo')) {
        var specialInfoJson =
            script.text.split('var specialInfo = ')[1].split(';')[0];
        Map<String, dynamic> specialInfoMap = jsonDecode(specialInfoJson);
        map.addAll(specialInfoMap);
      }
      if (script.text.contains('var data=')) {
        // 分割字符串，获取 "var data=" 后的部分
        String dataPart = script.text.split('var data=')[1];
        // 获取最后一个 '],' 的位置
        int lastIndex = dataPart.lastIndexOf('],');
        // 截取从开始到最后一个 '],' 之前的字符串
        String result = dataPart.substring(0, lastIndex + 1);
        List songList = jsonDecode(result);
        map['songs'] = songList;
      }
    }

    return HttpResponseModel.success(SpecialItemModel.fromJson(map));
  }

  Future<HttpResponseModel> rankList() async {
    HttpResponseModel response = await NetworkManager().get(
        'http://m.kugou.com/rank/list?json=true',
        options: Options(headers: {"requiresToken": false}));
    Map<String, dynamic> dataMap = json.decode(response.data);
    List<RankItemModel> rankList = [];
    List list = dataMap['rank']['list'];
    if (list != null) {
      list.forEach((v) {
        rankList?.add(RankItemModel.fromJson(v));
      });
    }
    return HttpResponseModel.success(rankList);
  }

  Future<HttpResponseModel> rankInfo(
      {required int rankId, int page = 1}) async {
    HttpResponseModel response = await NetworkManager().get(
        'http://m.kugou.com/rank/info/songs',
        params: {'rankid': rankId, 'json': true, 'page': page});

    Map<String, dynamic> dataMap = json.decode(response.data);
    Map<String, dynamic> map = {};

    if (dataMap['info'] != null) {
      map = dataMap['info'];
      map['songs'] = dataMap['songs']['list'];
    }

    return HttpResponseModel.success(RankItemModel.fromJson(map));
  }

  void singerInfo(int singerId) {
    NetworkManager().get('http://m.kugou.com/singer/info/$singerId', params: {
      'json': true
    }, headers: {
      'User-Agent':
          'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
      'Accept': 'application/json',
    });
  }
}
