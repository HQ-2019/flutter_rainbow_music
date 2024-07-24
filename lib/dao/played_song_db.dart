import 'package:flutter_rainbow_music/dao/database_manager.dart';
import 'package:flutter_rainbow_music/dao/song_db.dart';
import 'package:flutter_rainbow_music/dao/song_detail_db.dart';
import 'package:flutter_rainbow_music/model/song_detail_model.dart';
import 'package:flutter_rainbow_music/model/song_item_model.dart';
import 'package:sqflite/sqflite.dart';

class PlayedSongDB {
  static const String tableName = 'played_songs';
  static Future<void> onCreate(Database db, {int? version}) async {
    await db.execute(
      '''
      CREATE TABLE $tableName (
        song_hash TEXT PRIMARY KEY,
        play_count INTEGER DEFAULT 1,
        FOREIGN KEY(song_hash) REFERENCES ${SongDB.tableName}(hash)
      )
    ''',
    );
  }

  static Future<List<Map<String, dynamic>>> getPlayedRecords() async {
    final db = await DatabaseManager().db;
    List<Map<String, dynamic>> list = await db.rawQuery(
      '''
        SELECT * FROM $tableName
      ''',
    );
    return list;
  }

  static Future<List<SongItemModel>> getPlayedSongs() async {
    final db = await DatabaseManager().db;
    List<Map<String, dynamic>> list = await db.rawQuery(
      '''
        SELECT s.* FROM $tableName f
        JOIN ${SongDB.tableName} s ON f.song_hash = s.hash
      ''',
    );

    List<SongItemModel> playedSongs = [];
    if (list.isNotEmpty) {
      List<String> songHashes = [];
      for (var item in list) {
        final song = SongItemModel.fromJson(item);
        if (song.hash != null) {
          playedSongs.add(song);
          songHashes.add(song.hash!);
        }
      }

      // 批量获取歌曲详细信息
      Map<String, SongDetailModel> songDetails =
          await SongDetailDB.getSongDetails(songHashes);
      for (var song in playedSongs) {
        if (song.hash != null) {
          song.songDetail = songDetails[song.hash!];
        }
      }
    }
    return playedSongs;
  }

  static Future<List<String>?> getPlayedSongsHash() async {
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

  static Future<int> getPlayedSongsCount() async {
    final db = await DatabaseManager().db;
    final result = await db.rawQuery(
      '''
        SELECT COUNT(*) as count FROM $tableName
      ''',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  static Future<void> addPlayedSong(
      {required String songHash, SongItemModel? song}) async {
    final db = await DatabaseManager().db;
    if (song != null) {
      await SongDB.addSongInfo(song);
    }

    // 使用INSERT...ON CONFLICT...语句自动处理插入和更新（低版本不支持）
    // 即当song_hash已存在是自动更新play_count
    // await db.rawInsert(
    //   '''
    //     INSERT INTO $tableName (song_hash, play_count)
    //     VALUES (?, 1)
    //     ON CONFLICT(song_hash)
    //     DO UPDATE SET play_count = play_count + 1
    //   ''',
    //   [songHash],
    // );

    // 尝试更新 play_count，如果更新的行数为 0（表示记录不存在），则插入新记录
    int count = await db.rawUpdate(
      '''
      UPDATE $tableName
      SET play_count = play_count + 1
      WHERE song_hash = ?
      ''',
      [songHash],
    );

    if (count == 0) {
      await db.rawInsert(
        '''
        INSERT INTO $tableName (song_hash, play_count)
        VALUES (?, 1)
        ''',
        [songHash],
      );
    }
  }

  static Future<void> deletePlayedSong(String songHash) async {
    final db = await DatabaseManager().db;
    await db.delete(
      tableName,
      where: 'song_hash = ?',
      whereArgs: [songHash],
    );
  }
}
