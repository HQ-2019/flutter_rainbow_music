/// 歌曲详细数据
class SongDetailModel {
  SongDetailModel({
    this.authorName,
    this.status,
    this.payType,
    this.mvhash,
    this.fileName,
    this.intro,
    this.imgUrl,
    this.songName,
    this.singerName,
    this.fileSize,
    this.albumid,
    this.url,
    this.choricSinger,
    this.albumImg,
    this.timeLength,
    this.singerId,
    this.hash,
  });

  SongDetailModel.fromJson(dynamic json) {
    authorName = json['author_name'];
    status = json['status'];
    payType = json['pay_type'];
    mvhash = json['mvhash'];
    fileName = json['fileName'];
    intro = json['intro'];
    imgUrl = json['imgUrl']?.replaceAll('/{size}', '');
    songName = json['songName'];
    singerName = json['singerName'];
    fileSize = json['fileSize'];
    albumid = json['albumid'];
    url = json['url'];
    choricSinger = json['choricSinger'];
    albumImg = json['album_img']?.replaceAll('/{size}', '');
    timeLength = json['timeLength'];
    singerId = json['singerId'];
    hash = json['hash'];
  }
  String? hash;
  String? mvhash;
  String? songName;
  String? singerName;
  String? authorName;
  int? singerId;
  String? imgUrl;
  String? intro;
  String? url;
  int? status;
  int? payType;
  int? albumid;
  String? albumImg;
  String? fileName;
  int? fileSize;
  String? choricSinger;
  int? timeLength;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['author_name'] = authorName;
    map['status'] = status;
    map['pay_type'] = payType;
    map['mvhash'] = mvhash;
    map['fileName'] = fileName;
    map['intro'] = intro;
    map['imgUrl'] = imgUrl;
    map['songName'] = songName;
    map['singerName'] = singerName;
    map['fileSize'] = fileSize;
    map['albumid'] = albumid;
    map['url'] = url;
    map['choricSinger'] = choricSinger;
    map['album_img'] = albumImg;
    map['timeLength'] = timeLength;
    map['singerId'] = singerId;
    map['hash'] = hash;
    return map;
  }
}
/**
    https://m.kugou.com/app/i/getSongInfo.php?cmd=playInfo&hash=70de0daf4db31cbb56b82d1821b16f86
{
"authors": [
{
"birthday": "1978-04-04",
"is_publish": 1,
"avatar": "http://singerimg.kugou.com/uploadpic/softhead/{size}/20230512/20230512195120212.jpg",
"author_id": 3249,
"language": "华语",
"identity": 15,
"country": "中国",
"author_name": "杨宗纬",
"type": 1
},
{
"birthday": "1986-07-20",
"is_publish": 1,
"avatar": "http://singerimg.kugou.com/uploadpic/softhead/{size}/20230621/20230621193949786.jpg",
"author_id": 799937,
"language": "华语",
"identity": 15,
"country": "中国",
"author_name": "宝石Gem",
"type": 1
},
{
"birthday": "",
"is_publish": 1,
"avatar": "http://singerimg.kugou.com/uploadpic/softhead/{size}/20230420/20230420215159859876.jpg",
"author_id": 6881402,
"language": "华语",
"identity": 1,
"country": "中国",
"author_name": "王宇宙Leto",
"type": 0
}
],
"q": 0,
"author_name": "杨宗纬、宝石Gem、王宇宙Leto",
"sqprivilege": 10,
"status": 1,
"audio_id": 355044767,
"ctype": 1009,
"errcode": 0,
"req_albumid": "94628686",
"fileHead": 0,
"fail_process": 0,
"pay_type": 0,
"bitRate": 128,
"mvhash": "",
"fileName": "杨宗纬、宝石Gem、王宇宙Leto - 若月亮没来 (Live)",
"intro": "",
"imgUrl": "http://singerimg.kugou.com/uploadpic/softhead/{size}/20230512/20230512195120212.jpg",
"singerHead": "",
"extra": {
"320hash": "9FB39B6B963F3F6D39D4E4BE4EB96498",
"128filesize": 4032296,
"sqfilesize": 27164439,
"sqhash": "074AE72B929B30D4606E0E99460992F8",
"320timelength": 251977,
"128bitrate": 128,
"highbitrate": 1676,
"highhash": "78DEA0192947B77019004F389B5314CD",
"320filesize": 10080374,
"128timelength": 251977,
"sqbitrate": 862,
"highfilesize": 52802101,
"hightimelength": 251938,
"128hash": "031A57CE8B26F88D73626C47169AD581",
"sqtimelength": 251938
},
"album_category": 1,
"songName": "若月亮没来",
"backup_url": [
"https://sharefs.hw.kugou.com/202406020112/b52bdfd83ef56b8574dec9f07f4f9232/v3/031a57ce8b26f88d73626c47169ad581/yp/full/a1000_u0_p409_s4015693773.mp3"
],
"req_hash": "031A57CE8B26F88D73626C47169AD581",
"old_cpy": 0,
"store_type": "audio",
"time": 1717262085,
"area_code": "1",
"singerName": "杨宗纬",
"audio_group_id": 422254434,
"fileSize": 4032296,
"topic_remark": "",
"albumid": 94628686,
"publish_self_flag": 0,
"highprivilege": 10,
"url": "https://sharefs.tx.kugou.com/202406020112/80c7e5f9db7f2015e85f8142a2a0e254/v3/031a57ce8b26f88d73626c47169ad581/yp/full/a1000_u0_p409_s4015693773.mp3",
"choricSinger": "杨宗纬、宝石Gem、王宇宙Leto",
"stype": 11323,
"trans_param": {
"pay_block_tpl": 1,
"classmap": {
"attr0": 234885128
},
"language": "国语",
"free_limited": 1,
"cpy_attr0": 8192,
"musicpack_advance": 0,
"ogg_128_filesize": 2721843,
"display_rate": 1,
"qualitymap": {
"attr0": 524238964
},
"cpy_level": 1,
"cpy_grade": 5,
"cid": 392796561,
"hash_multitrack": "D185BDA882AE9DB21530B4B2BB85E745",
"display": 32,
"songname_suffix": "(Live)",
"ogg_320_hash": "61C958BF658A6AEB3525AD8AC9814138",
"ipmap": {
"attr0": 4128
},
"ogg_128_hash": "F40728175502DD3124880F75AE0B378F",
"ogg_320_filesize": 9866740
},
"topic_url": "",
"album_img": "http://imge.kugou.com/stdmusic/{size}/20240524/20240524155303186784.jpg",
"album_audio_id": 634717392,
"timeLength": 251,
"error": "",
"privilege": 8,
"128privilege": 8,
"extName": "mp3",
"320privilege": 10,
"singerId": 3249,
"hash": "031A57CE8B26F88D73626C47169AD581"
}
*/
