import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rainbow_music/base/utils/eventbus_util.dart';
import 'package:flutter_rainbow_music/base/utils/router_observer_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rainbow_music/manager/player/player_manager.dart';
import 'package:flutter_rainbow_music/manager/player/provider/music_provider.dart';
import 'package:flutter_rainbow_music/views/pages/login/login_page.dart';
import 'package:flutter_rainbow_music/views/pages/playlist/logic.dart';
import 'package:get/get.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<StatefulWidget> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> with RouteAware {
  Color _color = Colors.transparent;
  final logic = Get.put(PlaylistPageLogic());
  bool _isEditing = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _scrollToPlaySong();
    });
  }

  // 滚动到当前播放的歌曲
  void _scrollToPlaySong() {
    final index = logic.playSongIndex();
    if (index > 7) {
      _scrollController.jumpTo(index * 40.0);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    Get.delete<PlaylistPageLogic>();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    super.didPush();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _color = Colors.black.withOpacity(0.5);
      });
      eventBus.fire(PlaylistPageVisibleEvent(true));
    });
  }

  @override
  void didPop() {
    super.didPop();
    setState(() {
      _color = Colors.transparent;
    });
    eventBus.fire(PlaylistPageVisibleEvent(false));
  }

  @override
  void didPushNext() {
    super.didPushNext();
  }

  @override
  void didPopNext() {
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              color: _color,
            ),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: const Offset(0, 0),
              ).animate(
                CurvedAnimation(
                  parent: ModalRoute.of(context)!.animation!,
                  curve: Curves.ease,
                ),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: MediaQuery.of(context).padding.top + 150,
                      width: double.infinity,
                      color: Colors.transparent,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    padding:
                        const EdgeInsets.only(top: 10, left: 14, right: 14),
                    height: 60,
                    width: double.infinity,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '正在播放',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        GetBuilder<PlaylistPageLogic>(builder: (logic) {
                          final songCount = logic.songs.length;
                          final sourceText = logic.songsSource == null
                              ? ''
                              : '来自${logic.songsSource}';
                          final playText = songCount > 0
                              ? '已播 ${logic.playedList.length}/$songCount'
                              : '';
                          return Text(
                            '$sourceText  $playText',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black45),
                          );
                        }),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: GetBuilder<PlaylistPageLogic>(builder: (logic) {
                        return ListView.builder(
                            controller: _scrollController,
                            itemCount: logic.songs.length,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var model = logic.songs[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: _songItemView(
                                    model,
                                    logic.isSelectedSong(
                                        model.fetchHash() ?? '')),
                              );
                            });
                      }),
                    ),
                  ),
                  _bottomTabView(),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _bottomTabView() {
    return Container(
      height: MediaQuery.of(context).padding.bottom + 49,
      width: double.infinity,
      // color: Colors.redAccent,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
            Colors.white,
            Color.fromRGBO(250, 250, 250, 1),
          ])),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 49,
              // color: Colors.yellow,
              child: DefaultTabController(
                  length: 3,
                  child: TabBar(
                    indicatorColor: Colors.transparent,
                    dividerHeight: 0,
                    labelColor: Colors.black87,
                    onTap: (index) {
                      if (!_isEditing) {
                        if (index == 0) {
                          _showPlaybackModeMenu();
                        } else if (index == 1) {
                          setState(() {
                            _isEditing = true;
                          });
                        } else {
                          Navigator.pop(context);
                        }
                        return;
                      }

                      if (index == 0) {
                        // 下载
                      } else if (index == 1) {
                        // 删除
                        logic.removePlaylist();
                      } else {
                        setState(() {
                          _isEditing = false;
                        });
                      }
                    },
                    tabs: !_isEditing
                        ? [
                            _tabView(
                                text: '顺序', icon: const Icon(Icons.repeat)),
                            _tabView(text: '编辑', icon: const Icon(Icons.edit)),
                            _tabView(
                                text: '收起',
                                icon: const Icon(Icons.keyboard_arrow_down,
                                    size: 30)),
                          ]
                        : [
                            _tabView(
                                text: '下载', icon: const Icon(Icons.download)),
                            _tabView(
                                text: '删除',
                                icon: const Icon(Icons.delete_forever)),
                            _tabView(
                              text: '完成',
                            ),
                          ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  void _showPlaybackModeMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: PlaybackMode.values.map((PlaybackMode mode) {
            String text = '';
            switch (mode) {
              case PlaybackMode.sequential:
                text = '顺序播放';
                break;
              case PlaybackMode.shuffle:
                text = '随机播放';
                break;
              case PlaybackMode.repeatOne:
                text = '单曲循环';
                break;
            }
            return ListTile(
              title: Text(text,
                  style: TextStyle(
                      color: PlayerManager().playbackModel == mode
                          ? Colors.blue
                          : Colors.black87)),
              onTap: () {
                setState(() {
                  PlayerManager().updatePlaybackModel(mode);
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  Tab _tabView({Icon? icon, String? text, Widget? child}) {
    return Tab(
      icon: icon,
      iconMargin: EdgeInsets.zero,
      child: Text(
        text ?? '',
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _songItemView(MusicProvider model, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (_isEditing) {
          logic.updateSelectedList(model.fetchHash());
          return;
        }
        PlayerManager().playList(song: model);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 2, right: 5),
        width: double.infinity,
        height: 40,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_isEditing) ...[
              Checkbox(
                  value: isSelected,
                  activeColor: Colors.pinkAccent,
                  onChanged: (value) {
                    logic.updateSelectedList(model.fetchHash());
                  }),
            ] else ...[
              const SizedBox(width: 14),
            ],
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    color: Colors.white70,
                    child: CachedNetworkImage(
                      imageUrl: model.fetchCoverUrl() ?? '',
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                              color: Colors.pink[100], strokeWidth: 1)),
                      errorWidget: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, color: Colors.black12),
                    ),
                  )),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.fetchSongName() ?? '',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 15,
                          color: model.fetchIsSelected()
                              ? Colors.blue
                              : Colors.black,
                          overflow: TextOverflow.ellipsis)),
                  Text(model.fetchSingerName() ?? '',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 11,
                          color: model.fetchIsSelected()
                              ? Colors.blue
                              : Colors.black54,
                          overflow: TextOverflow.ellipsis))
                ],
              ),
            ),
            if (!_isEditing && model.fetchIsSelected()) ...[
              SizedBox(
                width: 40,
                child: IconButton(
                  color: Colors.black26,
                  icon: const Icon(
                    Icons.favorite_border,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: 40,
                child: IconButton(
                  color: Colors.black26,
                  icon: const Icon(
                    Icons.file_download_outlined,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
              )
            ],
            if (!_isEditing) ...[
              SizedBox(
                width: 40,
                child: IconButton(
                  color: Colors.black26,
                  icon: const Icon(
                    Icons.clear,
                    size: 20,
                  ),
                  onPressed: () {
                    logic.removeSong(model);
                  },
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}

/// 实现背景透明的路由过渡效果(腿出页面透明区域能透视上一个页面)
class TransparentRoute extends PageRoute<void> {
  TransparentRoute({required this.builder, this.fullscreenDialog = false})
      : super();

  final WidgetBuilder builder;

  @override
  final bool fullscreenDialog;

  @override
  Color get barrierColor => Colors.transparent;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => '';

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }
}
