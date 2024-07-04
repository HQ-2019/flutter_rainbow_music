import 'package:flutter_rainbow_music/manager/player/provider/music_provider.dart';
import 'package:audioplayers/audioplayers.dart';

/// 定义音乐播放相关的EventBus事件类接口
abstract class MusicEvent {
  final MusicProvider musicProvider;
  MusicEvent(this.musicProvider);
}

/// 音乐切换事件
class MusicPlayEvent extends MusicEvent {
  MusicPlayEvent(super.musicProvider);
}

/// 音乐播放状态变更事件
class MusicPlaySateEvent extends MusicEvent {
  final PlayerState playState;
  MusicPlaySateEvent(super.musicProvider, this.playState);
}

/// 音乐播放进度回调事件
class MusicPlayProgressEvent {
  final double progress;
  final int time;
  MusicPlayProgressEvent(this.progress, this.time);
}
