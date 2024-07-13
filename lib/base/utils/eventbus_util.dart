import 'package:event_bus/event_bus.dart';

/// 创建全局 EventBus 实例
final eventBus = EventBus();

/// 全局播放视图显隐事件
class PlayViewVisibleEvent {
  final bool isVisible;
  PlayViewVisibleEvent(this.isVisible);
}

/// 登录状态变更通知
class LoginStateEvent {
  final bool isLogin;
  LoginStateEvent(this.isLogin);
}

/// 收藏歌曲列表变更通知
class FavoriteSongChangedEvent {
  final List<String> list;
  FavoriteSongChangedEvent(this.list);
}
