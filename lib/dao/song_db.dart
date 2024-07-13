import 'package:flutter_rainbow_music/dao/database_manager.dart';
import 'package:flutter_rainbow_music/dao/song_detail_db.dart';
import 'package:flutter_rainbow_music/model/song_item_model.dart';
import 'package:sqflite/sqflite.dart';

class SongDB {
  static const String tableName = 'songs';
  static Future<void> onCreate(Database db, {int? version}) async {
    await db.execute(
      '''
      CREATE TABLE $tableName (
        hash text PRIMARY KEY,
        mvhash text,
        song_name text,
        singer_name text,
        album_sizable_cover text,
        pay_type integer
      )
    ''',
    );
  }

  static Future<SongItemModel?> getSongInfo(String songHash) async {
    final db = await DatabaseManager().db;
    List<Map<String, dynamic>> list =
        await db.query(tableName, where: 'hash = ?', whereArgs: [songHash]);
    if (list.isNotEmpty) {
      final song = SongItemModel.fromJson(list.first);
      song.songDetail = await SongDetailDB.getSongDetail(songHash);
      return song;
    }
    return null;
  }

  static Future<void> addSongInfo(SongItemModel song) async {
    final db = await DatabaseManager().db;
    await db.insert(
      tableName,
      {
        'hash': song.hash,
        'mvhash': song.mvhash,
        'song_name': song.mvhash,
        'singer_name': song.mvhash,
        'album_sizable_cover': song.coverUrl,
        'pay_type': song.payType,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (song.songDetail != null) {
      await SongDetailDB.addSongDetail(song.songDetail!);
    }
  }
}
