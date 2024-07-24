import 'package:flutter_rainbow_music/dao/database_manager.dart';
import 'package:flutter_rainbow_music/model/song_detail_model.dart';
import 'package:sqflite/sqflite.dart';

class SongDetailDB {
  static const String tableName = 'song_details';
  static Future<void> onCreate(Database db, {int? version}) async {
    await db.execute(
      '''
      CREATE TABLE $tableName (
        hash text PRIMARY KEY,
        mvhash text,
        song_name text,
        singer_name text,
        author_name text,
        singer_id integer,
        img_url text,
        url text,
        pay_type integer, 
        status integer, 
        album_id integer,
        album_img text,
        file_name text,
        file_size text,
        time_length integer
    )
    ''',
    );
  }

  static Future<SongDetailModel?> getSongDetail(String songHash) async {
    final db = await DatabaseManager().db;
    List<Map<String, dynamic>> list =
        await db.query(tableName, where: 'hash = ?', whereArgs: [songHash]);
    if (list.isNotEmpty) {
      return SongDetailModel.fromJson(list.first);
    }
    return null;
  }

  static Future<Map<String, SongDetailModel>> getSongDetails(
      List<String> songHashes) async {
    final db = await DatabaseManager().db;

    if (songHashes.isEmpty) {
      return {};
    }

    // 构建查询语句和参数
    final placeholders = songHashes.map((_) => '?').join(',');
    final List<Map<String, dynamic>> results = await db.rawQuery(
      '''
      SELECT * FROM $tableName
      WHERE hash IN ($placeholders)
      ''',
      songHashes,
    );

    // 将查询结果转换为 Map
    Map<String, SongDetailModel> songDetails = {};
    for (var result in results) {
      final songDetail = SongDetailModel.fromJson(result);
      if (songDetail.hash != null) {
        songDetails[songDetail.hash!] = songDetail;
      }
    }

    return songDetails;
  }

  static Future<void> addSongDetail(SongDetailModel song) async {
    final db = await DatabaseManager().db;
    await db.insert(
      tableName,
      {
        'hash': song.hash,
        'mvhash': song.mvhash,
        'song_name': song.mvhash,
        'singer_name': song.mvhash,
        'author_name': song.authorName,
        'singer_id': song.singerId,
        'img_url': song.imgUrl,
        'url': song.url,
        'pay_type': song.payType,
        'status': song.status,
        'album_id': song.albumid,
        'album_img': song.albumid,
        'file_name': song.fileName,
        'file_size': song.fileSize,
        'time_length': song.timeLength,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
