import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rainbow_music/api/api.dart';
import 'package:flutter_rainbow_music/base/network/http_response_model.dart';
import 'package:flutter_rainbow_music/base/network/network_manager.dart';
import 'package:flutter_rainbow_music/base/utils/eventbus_util.dart';
import 'package:flutter_rainbow_music/dao/played_song_db.dart';
import 'package:flutter_rainbow_music/manager/player/eventbus/player_event.dart';
import 'package:flutter_rainbow_music/manager/player/provider/music_provider.dart';
import 'package:flutter_rainbow_music/model/song_item_model.dart';
import 'package:flutter_rainbow_music/views/pages/played_songs/played_songs_page.dart';

/// 音乐播放循环方式
enum PlaybackMode {
  sequential, // 顺序播放
  shuffle, // 随机播放
  repeatOne, // 单曲循环
}

/// 音乐播放管理器
class PlayerManager {
  PlayerManager._internal() {
    _init();
  }

  static final PlayerManager _instance = PlayerManager._internal();

  factory PlayerManager() => _instance;

  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;
  StreamSubscription? _playerStateChangeSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerDurationChangeSubscription;
  StreamSubscription? _playerPositionChangeSubscription;

  // 播放循环方式
  PlaybackMode _playbackModel = PlaybackMode.sequential;

  PlaybackMode get playbackModel => _playbackModel;

  // 播放列表
  List<MusicProvider> _playlist = [];

  List<MusicProvider> get playlist => _playlist;

  // 当前列表来源
  String? _playlistSource;

  String? get playlistSource => _playlistSource;

  // 当前选择的音乐
  MusicProvider? _currentSong;

  MusicProvider? get currentSong => _currentSong;

  MusicProvider? _lastSong;

  int? _timeLenght;

  int? get timeLenght => _timeLenght;

  void _init() {
    _player.setReleaseMode(ReleaseMode.stop);
    //_player.setPlaybackRate(1);

    // 监听播放状态
    _playerStateChangeSubscription =
        _player.onPlayerStateChanged.listen((state) {
      print("播放状态变更 ${state}");
      eventBus.fire(MusicPlaySateEvent(_currentSong!, _player.state));
    });

    // 监听播放结束
    _playerCompleteSubscription = _player.onPlayerComplete.listen((event) {
      print("播放结束");
      _player.stop();
      // 播放下一首
      playNext();
    });

    // 监听总时长
    _playerDurationChangeSubscription =
        _player.onDurationChanged.listen((event) {
      print("时长 $event");
      _timeLenght = event.inSeconds;
    });

    // 监听播放进度
    _playerPositionChangeSubscription =
        _player.onPositionChanged.listen((event) {
      if (_timeLenght != null) {
        final progress = event.inSeconds.toDouble() / _timeLenght!;
        eventBus.fire(MusicPlayProgressEvent(progress, event.inSeconds));
      }
    });
  }

  void dispose() {
    _playerStateChangeSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerDurationChangeSubscription?.cancel();
    _playerPositionChangeSubscription?.cancel();
  }

  void changePlaybackModel({PlaybackMode? model}) {
    if (model != null) {
      _playbackModel = model;
      return;
    }

    // 按顺序改变播放模式
    switch (_playbackModel) {
      case PlaybackMode.sequential:
        _playbackModel = PlaybackMode.shuffle;
        break;
      case PlaybackMode.shuffle:
        _playbackModel = PlaybackMode.repeatOne;
        break;
      case PlaybackMode.repeatOne:
        _playbackModel = PlaybackMode.sequential;
        break;
    }
  }

  IconData fetchPlayModeIcon() {
    switch (PlayerManager().playbackModel) {
      case PlaybackMode.sequential:
        return Icons.repeat;
      case PlaybackMode.shuffle:
        return Icons.shuffle;
      case PlaybackMode.repeatOne:
        return Icons.repeat_one;
    }
  }

  String fetchPlayModeText() {
    switch (PlayerManager().playbackModel) {
      case PlaybackMode.sequential:
        return '顺序';
      case PlaybackMode.shuffle:
        return '随机';
      case PlaybackMode.repeatOne:
        return '单曲循环';
    }
  }

  void updatePlaylistSource(String? source) {
    _playlistSource = source;
  }

  void updatePlaylist(List<MusicProvider>? list) {
    if (list == null) {
      _playlist = [];
      return;
    }
    if (_playlist != list) {
      _playlist.clear();
      _playlist.addAll(list);
    }
  }

  void addPlaySong({required MusicProvider song, bool toNext = false}) {
    bool songExists =
        _playlist.any((item) => item.fetchHash() == song.fetchHash());
    if (songExists) {
      return;
    }

    if (toNext && _currentSong?.fetchHash() != null) {
      int index = _playlist.indexWhere(
          (element) => element.fetchHash() == _currentSong!.fetchHash());
      if (index >= 0) {
        _playlist.insert(index + 1, song);
        return;
      }
    }

    _playlist.add(song);
  }

  void cleanPlayList() {
    _player.stop();
    _playlist.clear();
    _playlistSource = null;
    _currentSong = null;
    _lastSong = null;
    _timeLenght = null;
  }

  void removePlayList(List<MusicProvider> list) {
    _playlist.removeWhere(
        (element) => list.any((b) => b.fetchHash() == element.fetchHash()));

    if (list.contains(_currentSong)) {
      _player.stop();
      playNext();
    }
  }

  void removePlaySong(MusicProvider song) {
    if (song == _currentSong) {
      _player.stop();
      playNext();
    }
    _playlist.remove(song);
  }

  /// 播放上一首
  void playLast() {
    if (_lastSong != null) {
      play(_lastSong!);
      return;
    }

    if (_currentSong?.fetchHash() == null) {
      play(_playlist.first);
      return;
    }

    int index = _playlist.indexWhere(
        (element) => element.fetchHash() == _currentSong!.fetchHash());
    play(_playlist[max(0, index - 1)]);
  }

  /// 播放下一首
  void playNext() {
    if (_playlist.isEmpty) {
      return;
    }

    if (_currentSong?.fetchHash() == null) {
      play(_playlist.first);
      return;
    }

    // 下一首的索引
    int nextIndex = 0;
    // 当前播放
    int index = _playlist.indexWhere(
        (element) => element.fetchHash() == _currentSong!.fetchHash());

    switch (_playbackModel) {
      case PlaybackMode.sequential:
        nextIndex = _playlist.length - 1 > index ? index + 1 : 0;
        break;
      case PlaybackMode.shuffle:
        nextIndex = Random().nextInt(_playlist.length);
        break;
      case PlaybackMode.repeatOne:
        nextIndex = max(0, index);
        break;
    }

    // 播放下一首
    play(_playlist[nextIndex]);
  }

  /// 播放歌曲列表
  void playList(
      {required MusicProvider song,
      List<MusicProvider>? list,
      String? source}) {
    if (list != null && list.isNotEmpty) {
      updatePlaylist(list);
    }
    if (source != null) {
      updatePlaylistSource(source);
    }
    play(song);
  }

  /// 播放歌曲
  void play(MusicProvider song) {
    if (_currentSong != null && _currentSong != song) {
      _lastSong = _currentSong!.clone();
    }
    if (_currentSong == null || _currentSong?.fetchHash() != song.fetchHash()) {
      _currentSong = song;
      eventBus.fire(MusicPlayEvent(song));
    } else {
      _currentSong = song;
    }

    // 如果播放的歌曲还为添加到列表中，则进行添加
    addPlaySong(song: _currentSong!);

    // 判断是否需要请求歌曲的播放信息
    String? url = _currentSong!.fetchSongUrl();
    if (url == null || url.isEmpty) {
      requestSongInfo(_currentSong!);
      return;
    }

    UrlSource newSource = UrlSource(url);
    Source? currentSource = _player.source;

    // 判断是否是当前播放器中的歌曲
    bool isSameUrlSource =
        currentSource is UrlSource && currentSource.url == newSource.url;

    if (!isSameUrlSource) {
      _player.play(newSource);
      // 保存播放记录
      PlayedSongDB.addPlayedSong(
          songHash: song.fetchHash()!, song: song as SongItemModel);
      return;
    }

    if (_player.state == PlayerState.playing) {
      _player.pause();
    } else if (_player.state == PlayerState.paused) {
      _player.resume();
    } else {
      _player.play(newSource);
    }
  }

  void requestSongInfo(MusicProvider song) async {
    var hash = song.fetchHash();
    if (hash == null) {
      return;
    }
    HttpResponseModel response = await NetworkManager().songDetail(hash);
    if (response.data != null) {
      song.updateSongDetail(response.data);
    }
    final songUrl = song.fetchSongUrl();
    if (songUrl != null && songUrl.isNotEmpty) {
      play(song);
      return;
    }
    // 获取不到音乐链接时自动播放下一首
    playNext();
  }

  /// 从指定位置播放
  seek(Duration position) {
    _player.seek(position);
  }
}
