import 'package:flutter_rainbow_music/dao/favorite_song_db.dart';
import 'package:flutter_rainbow_music/dao/played_song_db.dart';
import 'package:flutter_rainbow_music/dao/song_db.dart';
import 'package:flutter_rainbow_music/dao/song_detail_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
  DatabaseManager._internal();
  static final DatabaseManager _instance = DatabaseManager._internal();
  factory DatabaseManager() => _instance;

  static const String _dbFile = 'rainbow.db';
  static const int _dbVersion = 1;

  static Database? _db;

  /// db创建为异步过程，自定义get方法解决获取db为空的问题
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String dbPath = join(await getDatabasesPath(), _dbFile);
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: (Database db, int version) {
        // 初始化创建数据库表
        SongDetailDB.onCreate(db, version: version);
        SongDB.onCreate(db, version: version);
        FavoriteSongDB.onCreate(db, version: version);
        PlayedSongDB.onCreate(db, version: version);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) {
        // 数据库版本升级，增删表，修改表结构等...
      },
    );
  }

  void deleteDB() async {
    String dbPath = join(await getDatabasesPath(), _dbFile);
    await deleteDatabase(dbPath);
    _db = null;
  }
}
