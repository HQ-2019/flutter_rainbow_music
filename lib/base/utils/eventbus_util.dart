import 'package:event_bus/event_bus.dart';

/// 创建全局 EventBus 实例
final eventBus = EventBus();

/// 播放列表页面显隐事件
class PlaylistPageVisibleEvent {
  final bool isVisible;
  PlaylistPageVisibleEvent(this.isVisible);
}
