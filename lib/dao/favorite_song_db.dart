import 'package:flutter_rainbow_music/dao/database_manager.dart';
import 'package:flutter_rainbow_music/dao/song_db.dart';
import 'package:flutter_rainbow_music/dao/song_detail_db.dart';
import 'package:flutter_rainbow_music/model/song_detail_model.dart';
import 'package:flutter_rainbow_music/model/song_item_model.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteSongDB {
  static const String tableName = 'favorite_songs';
  static Future<void> onCreate(Database db, {int? version}) async {
    await db.execute(
      '''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        phone TEXT,
        song_hash TEXT,
        UNIQUE(phone, song_hash),
        FOREIGN KEY(song_hash) REFERENCES ${SongDB.tableName}(hash)
      )
    ''',
    );
  }

  static Future<List<SongItemModel>> getFavoriteList(String phone) async {
    final db = await DatabaseManager().db;
    List<Map<String, dynamic>> list = await db.rawQuery(
      '''
        SELECT s.* FROM $tableName f
        JOIN ${SongDB.tableName} s ON f.song_hash = s.hash
        WHERE f.phone = ?
      ''',
      [phone],
    );

    List<SongItemModel> favoriteSongs = [];
    if (list.isNotEmpty) {
      List<String> songHashes = [];
      for (var item in list) {
        final song = SongItemModel.fromJson(item);
        if (song.hash != null) {
          favoriteSongs.add(song);
          songHashes.add(song.hash!);
        }
      }

      // 批量获取歌曲详细信息
      Map<String, SongDetailModel> songDetails =
          await SongDetailDB.getSongDetails(songHashes);
      for (var song in favoriteSongs) {
        if (song.hash != null) {
          song.songDetail = songDetails[song.hash!];
        }
      }
    }

    return favoriteSongs;
  }

  static Future<List<String>?> getFavoriteSongHashList(String phone) async {
    final db = await DatabaseManager().db;
    List<Map<String, dynamic>> result = await db.rawQuery(
      '''
        SELECT song_hash FROM $tableName WHERE phone = ?
      ''',
      [phone],
    );

    List<String> hashList = [];
    for (var row in result) {
      hashList.add(row['song_hash'] as String);
    }

    return hashList;
  }

  static Future<int> getFavoriteCount(String phone) async {
    final db = await DatabaseManager().db;
    final result = await db.rawQuery(
      '''
        SELECT COUNT(*) as count FROM $tableName WHERE phone = ?
      ''',
      [phone],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  static Future<void> addFavoriteSong(
      {required String phone,
      required String songHash,
      SongItemModel? song}) async {
    final db = await DatabaseManager().db;
    try {
      if (song != null) {
        await SongDB.addSongInfo(song);
      }
      await db.insert(tableName, {'phone': phone, 'song_hash': songHash});
    } catch (e) {
      if (e is DatabaseException && e.isUniqueConstraintError()) {
        // 插入重复数据异常，不需要处理
      } else {
        // 其他错误
        throw e;
      }
    }
  }

  static Future<void> deleteFavoriteSong(String phone, String songHash) async {
    final db = await DatabaseManager().db;
    await db.delete(
      tableName,
      where: 'phone = ? AND song_hash = ?',
      whereArgs: [phone, songHash],
    );
  }
}
