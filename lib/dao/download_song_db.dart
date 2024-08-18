import 'package:flutter_rainbow_music/dao/database_manager.dart';
import 'package:flutter_rainbow_music/dao/song_db.dart';
import 'package:flutter_rainbow_music/dao/song_detail_db.dart';
import 'package:flutter_rainbow_music/model/song_item_model.dart';
import 'package:sqflite/sqflite.dart';

class DownloadSongDB {
  static const String tableName = 'download_songs';
  static Future<void> onCreate(Database db, {int? version}) async {
    await db.execute(
      '''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        song_hash TEXT,
        state INTEGER,
        UNIQUE(song_hash),
        FOREIGN KEY(song_hash) REFERENCES ${SongDB.tableName}(hash)
      )
    ''',
    );

    await db.execute(
      '''
      CREATE INDEX idx_song_hash ON $tableName (song_hash)
      ''',
    );
  }

  static Future<List<SongItemModel>?> getDownloadList() async {
    final db = await DatabaseManager().db;
    List<Map<String, dynamic>> list = await db.rawQuery(
      '''
      SELECT s.* FROM $tableName f
      JOIN ${SongDB.tableName} s ON f.song_hash = s.hash
    ''',
    );

    if (list.isNotEmpty) {
      List<SongItemModel> favoriteSongs = [];
      for (var item in list) {
        final song = SongItemModel.fromJson(item);
        if (song.hash != null) {
          song.songDetail = await SongDetailDB.getSongDetail(song.hash!);
        }
        favoriteSongs.add(song);
      }
      return favoriteSongs;
    }

    return null;
  }

  static Future<List<String>?> getDownloadSongHashList(String phone) async {
    final db = await DatabaseManager().db;
    List<Map<String, dynamic>> result = await db.rawQuery(
      '''
        SELECT song_hash FROM $tableName
      ''',
    );

    List<String> hashList = [];
    for (var row in result) {
      hashList.add(row['song_hash'] as String);
    }

    return hashList;
  }

  static Future<int> getDownloadCount() async {
    final db = await DatabaseManager().db;
    final result = await db.rawQuery(
      '''
        SELECT COUNT(*) as count FROM $tableName
      ''',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  static Future<void> addDownloadSong(SongItemModel song) async {
    final songHash = song.hash;
    if (songHash == null) {
      return;
    }
    final db = await DatabaseManager().db;
    try {
      await SongDB.addSongInfo(song);
      await db.insert(
        tableName,
        {'song_hash': songHash, 'state': 0},
      );
    } catch (e) {
      if (e is DatabaseException && e.isUniqueConstraintError()) {
        // 插入重复数据异常，不需要做任何处理
      } else {
        throw e;
      }
    }
  }

  static Future<void> updateDownloadState(String songHash, int newState) async {
    final db = await DatabaseManager().db;
    await db.update(
      tableName,
      {'state': newState},
      where: 'song_hash = ?',
      whereArgs: [songHash],
    );
  }

  static Future<void> deleteDownloadSong(String songHash) async {
    final db = await DatabaseManager().db;
    await db.delete(
      tableName,
      where: 'song_hash = ?',
      whereArgs: [songHash],
    );
  }
}
