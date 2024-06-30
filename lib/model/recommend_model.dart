import 'package:flutter_rainbow_music/model/banner_model.dart';
import 'package:flutter_rainbow_music/model/rank_item_model.dart';
import 'package:flutter_rainbow_music/model/song_item_model.dart';
import 'package:flutter_rainbow_music/model/special_item_model.dart';

class RecommendModel {
  RecommendModel({
    List<BannerModel>? bannerList,
    List<SongItemModel>? data,
    List<SpecialItemModel>? specialList,
    List<RankItemModel>? rankList,
  }) {
    _bannerList = bannerList;
    _data = data;
    _specialList = specialList;
    _rankList = rankList;
  }

  List<BannerModel>? _bannerList;
  List<SongItemModel>? _data;
  List<SpecialItemModel>? _specialList;
  List<RankItemModel>? _rankList;

  List<BannerModel>? get bannerList => _bannerList;
  List<SongItemModel>? get data => _data;
  List<SpecialItemModel>? get specialList => _specialList;
  List<RankItemModel>? get rankList => _rankList;

  RecommendModel.fromJson(dynamic json) {
    final banners = json['banner'];
    if (banners != null && banners is List) {
      _bannerList = BannerModel.fromJsonList(banners);
    }

    final songs = json['data'];
    if (songs != null && songs is List) {
      _data = SongItemModel.fromJsonList(songs);
    }

    final specials = json['special'];
    if (specials != null && specials is List) {
      _specialList = SpecialItemModel.fromJsonList(specials);
    }

    final ranks = json['rankList'];
    if (ranks != null && ranks is List) {
      _rankList = RankItemModel.fromJsonList(ranks);
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_bannerList != null) {
      map['bannerList'] = _specialList?.map((v) => v.toJson()).toList();
    }
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    if (_specialList != null) {
      map['specialList'] = _specialList?.map((v) => v.toJson()).toList();
    }
    if (_data != null) {
      map['rankList'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/**
    // 首页综合接口  data:新歌推荐   special:专属推荐歌单   rank:排行榜   ts:专辑
    // http://m.kugou.com/?json=true

    {
    "JS_CSS_DATE": 20130320,
    "kg_domain": "https://m.kugou.com",
    "src": "http://downmobile.kugou.com/promote/package/download/channel=6",
    "fr": null,
    "ver": "v3",
    "data": [
    {
    "last_sort": 0,
    "authors": [
    {
    "sizable_avatar": "http://singerimg.kugou.com/uploadpic/softhead/{size}/20230531/20230531160722881.jpg",
    "is_publish": 1,
    "author_name": "周深",
    "author_id": 169967
    }
    ],
    "rank_count": 0,
    "rank_id_publish_date": "",
    "songname": "红星闪闪亮",
    "topic_url_320": "",
    "sqhash": "6045901ED56B62335990682B1E9AB60E",
    "fail_process": 4,
    "pkg_price": 1,
    "addtime": "2021-12-25 22:00:00",
    "rp_type": "audio",
    "album_id": "95009521",
    "privilege_high": 10,
    "topic_url_sq": "",
    "rank_cid": 0,
    "inlist": 1,
    "320filesize": 7994714,
    "pkg_price_320": 1,
    "feetype": 0,
    "filename": "周深 - 红星闪闪亮",
    "duration_high": 199,
    "fail_process_320": 4,
    "zone": "",
    "topic_url": "",
    "rp_publish": 1,
    "hash": "C92896BF71DCD1156D85AAF0B96EF6A3",
    "sqfilesize": 24616262,
    "sqprivilege": 10,
    "pay_type_sq": 3,
    "bitrate": 128,
    "pkg_price_sq": 1,
    "has_accompany": 1,
    "musical": null,
    "pay_type_320": 3,
    "extname_super": "",
    "duration_super": 0,
    "bitrate_super": 0,
    "hash_high": "6B0FAB6D19B4352335AA339382DB010C",
    "duration": 199,
    "album_sizable_cover": "https://imgessl.kugou.com/stdmusic/{size}/20240530/20240530105801932065.jpg",
    "price_sq": 200,
    "old_cpy": 0,
    "filesize_super": 0,
    "m4afilesize": 0,
    "filesize_high": 45321780,
    "320privilege": 10,
    "remark": "红星闪闪亮",
    "isfirst": 0,
    "privilege": 8,
    "320hash": "380F45A27AA5CBF226950AF9E3D8F8C4",
    "price": 200,
    "extname": "mp3",
    "price_320": 200,
    "mvhash": "858D042F7BD4EA9FCD95DCC395EF4683",
    "sort": 1,
    "trans_param": {
    "cpy_grade": 5,
    "classmap": {
    "attr0": 234893320
    },
    "language": "国语",
    "cpy_attr0": 8192,
    "musicpack_advance": 0,
    "display": 32,
    "display_rate": 3,
    "qualitymap": {
    "attr0": 116
    },
    "cpy_level": 1,
    "cid": 394238693,
    "ogg_128_filesize": 2411464,
    "ogg_320_hash": "481F049EE602BDBC548778F8A10F3E72",
    "ipmap": {
    "attr0": 4096
    },
    "hash_offset": {
    "clip_hash": "7D70F8206CF2E86E020EEE4B93FFE733",
    "start_byte": 0,
    "end_ms": 60000,
    "end_byte": 960123,
    "file_type": 0,
    "start_ms": 0,
    "offset_hash": "2FFC878B48E01CDCE89FD2E4A95FBAFF"
    },
    "pay_block_tpl": 1,
    "ogg_128_hash": "18D56BE26704CD79356A206050B1B8F2",
    "ogg_320_filesize": 8401339
    },
    "recommend_reason": "",
    "album_audio_id": 636292916,
    "bitrate_high": 1814,
    "issue": 1,
    "pay_type": 3,
    "filesize": 3198005,
    "hash_super": "",
    "audio_id": 356387090,
    "first": 0,
    "privilege_super": 0,
    "fail_process_sq": 4,
    "song_url": "https://m.kugou.com/mixsong/aityr8e8.html",
    "singer_name": "周深",
    "song_name": "红星闪闪亮"
    }
    ],
    "special": {
    "list": {
    "timestamp": 1717214277,
    "total": 600,
    "info": [
    {
    "specialid": 4173317,
    "playcount": 319785263,
    "songcount": 116,
    "publishtime": "2021-08-31 00:00:00",
    "songs": [
    {
    "hash": "A21D08E024D1DB392C0BCB9674268A1C",
    "sqfilesize": 38258609,
    "sqprivilege": 0,
    "pay_type_sq": 0,
    "bitrate": 128,
    "pkg_price_sq": 0,
    "has_accompany": 1,
    "topic_url_320": "",
    "sqhash": "8229FA786940406DFA7629003E17D744",
    "fail_process": 0,
    "pay_type": 0,
    "rp_type": "audio",
    "album_id": "3668553",
    "mvhash": "B0D8EF11BCE855529C65F05194647AC1",
    "duration": 376,
    "topic_url_sq": "",
    "320hash": "75332521CAC10794500F3FB9611A360D",
    "price_sq": 0,
    "inlist": 1,
    "m4afilesize": 0,
    "old_cpy": 1,
    "320filesize": 15040388,
    "pkg_price_320": 0,
    "price_320": 0,
    "feetype": 0,
    "price": 0,
    "filename": "鹿先森乐队 - 春风十里",
    "extname": "mp3",
    "pkg_price": 0,
    "fail_process_320": 0,
    "trans_param": {
    "pay_block_tpl": 1,
    "qualitymap": {
    "attr0": 121225268
    },
    "language": "国语",
    "cid": -1,
    "ipmap": {
    "attr0": 4224
    },
    "cpy_attr0": 0,
    "hash_multitrack": "DAE12B8D9BCD1A6A16C6C0E68B52709A",
    "classmap": {
    "attr0": 234885128
    },
    "musicpack_advance": 0,
    "display": 32,
    "display_rate": 1
    },
    "remark": "鹿先森",
    "filesize": 6016790,
    "album_audio_id": 82190290,
    "brief": "",
    "rp_publish": 1,
    "privilege": 0,
    "topic_url": "",
    "audio_id": 302431846,
    "320privilege": 0,
    "pay_type_320": 0,
    "fail_process_sq": 0
    },
    ],
    "suid": 520032980,
    "url": "",
    "type": 0,
    "slid": 9,
    "verified": 0,
    "global_specialid": "collection_3_520032980_9_0",
    "selected_reason": "",
    "tags": [],
    "collectcount": 68054,
    "trans_param": {
    "special_tag": 0
    },
    "user_type": 0,
    "username": "好听的歌都在这儿了",
    "singername": "",
    "percount": 0,
    "recommendfirst": 0,
    "ugc_talent_review": 1,
    "specialname": "民谣酒馆：故事填饱岁月漫长",
    "user_avatar": "http://imge.kugou.com/kugouicon/165/20221122/20221122201725783113.jpg",
    "is_selected": 0,
    "intro": "春风十里，不如你扣弦一曲。\n唯有人间烟火，山川依旧。",
    "imgurl": "https://imgessl.kugou.com/custom/{size}/20210831/20210831104624819566.jpg",
    "encode_id": "2hg5h08",
    "play_count_text": "3.2亿"
    }
    ],
    "has_next": 1
    },
    "pagesize": 10
    },
    "rank": {
    "children": [

    ],
    "rankname": "TOP500",
    "new_cycle": 1800,
    "banner_9": "http:\/\/imge.kugou.com\/mcommon\/{size}\/20220112\/20220112175202472916.png",
    "album_img_9": "http:\/\/imge.kugou.com\/stdmusic\/{size}\/20240604\/20240604172454768671.jpg",
    "table_plaque": "http:\/\/imge.kugou.com\/mcommon\/{size}\/20240311\/20240311161214589894.png",
    "update_frequency_type": 1,
    "play_times": 34357563,
    "img_9": "",
    "ranktype": 2,
    "classify": 1,
    "haschildren": 0,
    "songinfo": [
    {
    "trans_param": {
    "ogg_128_hash": "3818F1295D4ED57B207E8357CD5B69C7",
    "classmap": {
    "attr0": 234881032
    },
    "language": "\u56fd\u8bed",
    "cpy_attr0": 7296,
    "musicpack_advance": 1,
    "display": 0,
    "display_rate": 0,
    "ogg_320_filesize": 9027249,
    "qualitymap": {
    "attr0": 524271732
    },
    "ogg_320_hash": "9BA7A0DC57780E43E286D671D3F6DD80",
    "appid_block": "3124",
    "cid": 390793890,
    "cpy_grade": 5,
    "ogg_128_filesize": 2630907,
    "ipmap": {
    "attr0": 4096
    },
    "hash_offset": {
    "clip_hash": "E2AC3EEA2ADC084B0916E6E0DE97E94C",
    "start_byte": 0,
    "end_ms": 60000,
    "end_byte": 960121,
    "file_type": 0,
    "start_ms": 0,
    "offset_hash": "8A42925DBF64BD756F6277AA72181D3C"
    },
    "hash_multitrack": "0F8095E66104F264AEF8E81B35F1B0C1",
    "pay_block_tpl": 1,
    "cpy_level": 1
    },
    "author": "\u5218\u9633\u9633",
    "name": "\u4eba\u95f4\u534a\u9014",
    "songname": "\u5218\u9633\u9633 - \u4eba\u95f4\u534a\u9014"
    },
    {
    "trans_param": {
    "ogg_128_hash": "ACD891E6A558724AE60645B93FA7D7D6",
    "classmap": {
    "attr0": 234881032
    },
    "language": "\u56fd\u8bed",
    "cpy_attr0": 7296,
    "musicpack_advance": 1,
    "display": 0,
    "display_rate": 0,
    "ogg_320_filesize": 6601905,
    "qualitymap": {
    "attr0": 524271732
    },
    "ogg_320_hash": "FCAA35A9CCDE267786E53FCBE81115A7",
    "appid_block": "3124",
    "cid": 390414301,
    "cpy_grade": 5,
    "ogg_128_filesize": 1972119,
    "ipmap": {
    "attr0": 4096
    },
    "hash_offset": {
    "clip_hash": "EBCC9E477FADF839FA1CD3F451D3038C",
    "start_byte": 0,
    "end_ms": 60000,
    "end_byte": 960139,
    "file_type": 0,
    "start_ms": 0,
    "offset_hash": "F2C5E1501B8ACC125E5BFE33149503EB"
    },
    "hash_multitrack": "C68AB950517F0906E9F95DBF01DEAE60",
    "pay_block_tpl": 1,
    "cpy_level": 1
    },
    "author": "\u5409\u661f\u51fa\u79df",
    "name": "\u66ae\u8272\u56de\u54cd",
    "songname": "\u5409\u661f\u51fa\u79df - \u66ae\u8272\u56de\u54cd"
    },
    {
    "trans_param": {
    "ogg_128_hash": "F40728175502DD3124880F75AE0B378F",
    "classmap": {
    "attr0": 234885128
    },
    "language": "\u56fd\u8bed",
    "free_limited": 1,
    "cpy_attr0": 0,
    "musicpack_advance": 0,
    "display": 32,
    "display_rate": 1,
    "ogg_320_filesize": 9866740,
    "qualitymap": {
    "attr0": 524271732
    },
    "cpy_grade": 5,
    "ogg_320_hash": "61C958BF658A6AEB3525AD8AC9814138",
    "cid": 392796561,
    "ipmap": {
    "attr0": 4128
    },
    "ogg_128_filesize": 2721843,
    "songname_suffix": "(Live)",
    "hash_offset": {
    "clip_hash": "DB25687C498A978B379605F0C4A72CFE",
    "start_byte": 0,
    "end_ms": 60000,
    "end_byte": 960167,
    "file_type": 0,
    "start_ms": 0,
    "offset_hash": "E78FFBA896A61314FB816A1018DB498B"
    },
    "hash_multitrack": "53AF761FDC5A1F90118314F1CAE0CD4F",
    "pay_block_tpl": 1,
    "cpy_level": 1
    },
    "author": "\u6768\u5b97\u7eac\u3001\u5b9d\u77f3Gem\u3001\u738b\u5b87\u5b99Leto",
    "name": "\u82e5\u6708\u4eae\u6ca1\u6765 (Live)",
    "songname": "\u6768\u5b97\u7eac\u3001\u5b9d\u77f3Gem\u3001\u738b\u5b87\u5b99Leto - \u82e5\u6708\u4eae\u6ca1\u6765 (Live)"
    }
    ],
    "rank_cid": 81036,
    "share_bg": "http:\/\/imge.kugou.com\/mcommon\/{size}\/20240505\/20240505213952649412.png",
    "id": 2,
    "jump_url": "",
    "share_logo": "http:\/\/imge.kugou.com\/mcommon\/{size}\/20240311\/20240311161212168226.png",
    "bannerurl": "http:\/\/imge.kugou.com\/mcommonbanner\/{size}\/20181019\/20181019122517263545.jpg",
    "show_play_count": 1,
    "isvol": 1,
    "video_ending": "http:\/\/imge.kugou.com\/mcommon\/{size}\/20240313\/20240313142811662716.jpg",
    "zone": "tx6_gz_kmr",
    "show_play_button": 0,
    "custom_type": 0,
    "issue": 163,
    "count_down": 1800,
    "update_frequency": "\u6bcf\u5929",
    "intro": "\u6570\u636e\u6765\u6e90\uff1a\u5168\u66f2\u5e93\u6b4c\u66f2\r\n\u6392\u5e8f\u65b9\u5f0f\uff1a\u6309\u6b4c\u66f2\u559c\u7231\u7528\u6237\u6570\u7684\u603b\u91cf\u6392\u5e8f\r\n\u66f4\u65b0\u9891\u7387\uff1a\u6bcf\u5929",
    "banner7url": "http:\/\/imge.kugou.com\/mcommon\/{size}\/20181019\/20181019122516438289.jpg",
    "rankid": 8888,
    "jump_title": "",
    "is_timing": 1,
    "img_cover": "http:\/\/imge.kugou.com\/mcommon\/{size}\/20211117\/20211117115003451494.png",
    "extra": {
    "resp": {
    "scheduled_release_conf": {
    "scheduled_release_time": "10:00:00",
    "latest_rank_cid": 81036,
    "latest_rank_cid_publish_date": "2024-06-11 08:30:00"
    },
    "recent_year_total": 139,
    "new_total": 8,
    "follow_total": 0,
    "rank_tag": [
    {
    "desc": "\u67098\u9996\u4e0a\u65b0",
    "type": 3
    }
    ],
    "all_total": 500,
    "vip_total": 0,
    "enjoy_total": 0
    }
    },
    "rank_id_publish_date": "2024-06-11 08:30:00",
    "imgurl": "http:\/\/imge.kugou.com\/mcommon\/{size}\/20181019\/20181019122513972113.jpg"
    }
    ],
    "rank_cid": 80744,
    "share_bg": "http://imge.kugou.com/mcommon/{size}/20240505/20240505213952649412.png",
    "id": 2,
    "jump_url": "",
    "share_logo": "http://imge.kugou.com/mcommon/{size}/20240311/20240311161212168226.png",
    "bannerurl": "http://imge.kugou.com/mcommonbanner/{size}/20181019/20181019122517263545.jpg",
    "show_play_count": 1,
    "isvol": 1,
    "video_ending": "http://imge.kugou.com/mcommon/{size}/20240313/20240313142811662716.jpg",
    "zone": "tx6_gz_kmr",
    "show_play_button": 0,
    "custom_type": 0,
    "issue": 153,
    "count_down": 1800,
    "update_frequency": "每天",
    "intro": "数据来源：全曲库歌曲\r\n排序方式：按歌曲喜爱用户数的总量排序\r\n更新频率：每天",
    "banner7url": "http://imge.kugou.com/mcommon/{size}/20181019/20181019122516438289.jpg",
    "rankid": 8888,
    "jump_title": "",
    "is_timing": 1,
    "img_cover": "http://imge.kugou.com/mcommon/{size}/20211117/20211117115003451494.png",
    "extra": {
    "resp": {
    "scheduled_release_conf": {
    "scheduled_release_time": "10:00:00",
    "latest_rank_cid": 80744,
    "latest_rank_cid_publish_date": "2024-06-01 08:30:00"
    },
    "recent_year_total": 135,
    "new_total": 8,
    "follow_total": 0,
    "rank_tag": [
    {
    "desc": "有8首上新",
    "type": 3
    }
    ],
    "all_total": 500,
    "vip_total": 0,
    "enjoy_total": 0
    }
    },
    "rank_id_publish_date": "2024-06-01 08:30:00",
    "imgurl": "http://imge.kugou.com/mcommon/{size}/20181019/20181019122513972113.jpg"
    }
    ]
    },
    "ts": {
    "albums": [
    {
    "album_name": "香归丨精品多人有声剧丨真千金归来丨古言宅斗",
    "is_new": 0,
    "sizable_cover": "https://imgessl.kugou.com/stdmusic/240/20240508/20240508133101934011.jpg",
    "play_count": 1051688,
    "publish_date": "2024-05-08",
    "album_id": 93295446,
    "is_pay": 0,
    "special_tag": 3600,
    "rank_status": 0,
    "intro": "带着记忆的荀香投了个好胎。\n母亲是公主，父亲是状元，她天生带有异香。\n可刚刚高兴一个月就被调了包，成了乡下孩子丁香。\n乡下日子鸡飞狗跳又乐趣多多。\n祖父是恶人，三个哥哥个个是人才。\n看丁香如何调教老小孩子，带领全家走上人生巅峰。\n一切准备就绪，她寻着记忆找到那个家。\n假荀香风光正好……",
    "audio_total": 300,
    "play_count_text": "105.2万",
    "special_tag_text": "精品"
    },
    {
    "album_name": "弃少归来：专治各种不服",
    "is_new": 0,
    "sizable_cover": "https://imgessl.kugou.com/stdmusic/240/20240520/20240520155301236266.jpg",
    "play_count": 915943,
    "publish_date": "2024-05-20",
    "album_id": 94265104,
    "is_pay": 0,
    "special_tag": 3600,
    "rank_status": 0,
    "intro": "燕京第一世家刘家弃子，天生不举，体弱多病，骨瘦如柴，不学无术，纨绔第一人！\n被逐出刘家后，刘星无依无靠，晕死街头。还好刘星还有一个未婚妻，不仅是燕京第一美女，而且心地善良，给了刘星一个安身之处，还让刘星进入燕大就读！\n也许天意弄人，在刘星去燕大军训的第一天，一个晴天惊雷，让刘星陷入昏迷之中，成了植物人！\n祸福相依，两个月后，刘星居然醒过来了，开始新的人生……",
    "audio_total": 765,
    "play_count_text": "91.6万",
    "special_tag_text": "精品"
    }
    ],
    "total": 10
    },
    "banner": [
    {
    "online": 1586190207,
    "title": "经典国风粤语：流风遗世，称快世俗",
    "id": 10429,
    "extra": {
    "percount": 0,
    "type": 0,
    "collectcount": 15836,
    "specialid": 1932365,
    "global_specialid": "collection_3_812556201_338_0",
    "songcount": 18,
    "trans_param": {
    "special_tag": 0
    },
    "publishtime": "2020-01-17",
    "imgurl": "http://c1.kgimg.com/custom/{size}/20200117/20200117072053233864.jpg",
    "play_count": 7004371,
    "singername": "",
    "specialname": "经典国风粤语：流风遗世，称快世俗。",
    "intro": "古风粤语，粤与的诗韵配上古雅曲调和那诗文、古词一般的词作，真是令...",
    "slid": 338,
    "suid": 812556201,
    "tourl": "https://m.kugou.com/plist/list/1932365"
    },
    "type": 1,
    "imgurl": "https://imgessl.kugou.com/mobilebanner/20200407/20200407002325623540.jpg"
    }
    ],
    "singers": [
    {
    "mvcount": 0,
    "fanscount": 5286160,
    "descibe": "8675条问答",
    "offline_url": "https://miniapp.kugou.com/node/v2?type=1&id=120&path=%2Findex.html%23%2Fsinger2%2F722869%2F5286160",
    "sortoffset": -35,
    "singerid": 722869,
    "songcount": 0,
    "banner_url": "",
    "singername": "毛不易",
    "is_settled": 1,
    "heatoffset": 2,
    "heat": 20745,
    "url": "https://h5.kugou.com/apps/singer-qa-v2/#/singer2/722869/5286160",
    "albumcount": 0,
    "intro": "",
    "imgurl": "https://imgessl.kugou.com/uploadpic/softhead/{size}/20230420/20230420151924717193.jpg",
    "encode_id": "M1TLK4AA81AEA"
    }
    ],
    "__Tpl": "index/index.html"
    }
 */
