import 'package:event_bus/event_bus.dart';

/// 创建全局 EventBus 实例
final eventBus = EventBus();

/// 全局播放视图显隐事件
class PlayViewVisibleEvent {
  final bool isVisible;
  PlayViewVisibleEvent(this.isVisible);
}
