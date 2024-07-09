import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rainbow_music/base/utils/color_util.dart';
import 'package:flutter_rainbow_music/base/utils/eventbus_util.dart';
import 'package:flutter_rainbow_music/manager/player/eventbus/player_event.dart';
import 'package:flutter_rainbow_music/manager/player/player_manager.dart';
import 'package:flutter_rainbow_music/manager/player/provider/music_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_rainbow_music/views/pages/playlist/playlist_page.dart';
import 'package:flutter_rainbow_music/views/pages/song_play/song_play.dart';

/// 音乐播放视图，HookWidget是StatefulWidget替代方案
class PlayerView extends HookWidget {
  const PlayerView(
      {super.key,
      this.song,
      this.width = double.infinity,
      this.height = 50,
      this.margin,
      this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      this.decoration});

  final MusicProvider? song;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final currentSong = useState<MusicProvider?>(song);
    final progress = useState(0.0);
    final playState = useState(currentSong.value?.fetchPlayState());
    final hasSong = currentSong.value != null;

    final rotationController = useAnimationController(
      duration: const Duration(seconds: 8),
    );

    useEffect(() {
      final songSubscription = eventBus.on<MusicPlayEvent>().listen((event) {
        currentSong.value = event.musicProvider;
      });

      final stateSubscription =
          eventBus.on<MusicPlaySateEvent>().listen((event) {
        playState.value = event.playState;
      });

      final progressSubscription =
          eventBus.on<MusicPlayProgressEvent>().listen((event) {
        progress.value = event.progress;
      });

      return () {
        songSubscription.cancel();
        stateSubscription.cancel();
        progressSubscription.cancel();
      };
    }, []);

    useEffect(() {
      if (playState.value == PlayerState.playing) {
        rotationController.repeat();
      } else {
        rotationController.stop();
      }
      return null;
    }, [playState.value]);

    return GestureDetector(
      onTap: () => _viewTap(context),
      child: Container(
        margin: margin,
        padding: padding,
        width: width,
        height: height,
        decoration: decoration ??
            BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: currentSong.value?.fetchThemeColor() ??
                  ColorUtil.randomDarkColor(),
            ),
        child: Stack(
          children: [
            ValueListenableBuilder<double>(
              valueListenable: progress,
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  minHeight: 2,
                  backgroundColor: Colors.transparent,
                  value: value,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(1),
                );
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RepaintBoundary(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      height: 30,
                      width: 30,
                      color: hasSong ? Colors.white : Colors.grey,
                      child: hasSong == null
                          ? null
                          : AnimatedBuilder(
                              animation: rotationController,
                              child: CachedNetworkImage(
                                imageUrl:
                                    currentSong.value?.fetchCoverUrl() ?? '',
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    Container(),
                              ),
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: rotationController.value * 2 * pi,
                                  child: child,
                                );
                              },
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Song Name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        hasSong
                            ? currentSong.value!.fetchSongName() ?? ''
                            : 'No song playing',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: hasSong ? Colors.white : Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (hasSong) ...[
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: Center(
                      child: IconButton(
                        iconSize: 24,
                        icon: Icon(
                            playState.value == PlayerState.playing
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white),
                        onPressed: () =>
                            _playButtonTap(context, currentSong.value),
                      ),
                    ),
                  ),
                  // const SizedBox(width: 2),
                ],
                SizedBox(
                  height: 40,
                  width: 40,
                  child: Center(
                    child: IconButton(
                      iconSize: 24,
                      icon: Icon(
                        Icons.queue_music,
                        color: hasSong ? Colors.white : Colors.transparent,
                      ),
                      onPressed: () => _playListButtonTap(context),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _viewTap(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => const SongPlayPage(),
      ),
    );
  }

  void _playButtonTap(BuildContext context, MusicProvider? song) {
    if (song != null) {
      PlayerManager().play(song);
    }
  }

  void _playListButtonTap(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        fullscreenDialog: true,
        pageBuilder: (context, animation, secondaryAnimation) {
          return const PlaylistPage();
        },
      ),
    );

    // 自定义过渡动效，设置路由页面背景透明
    // Navigator.push(
    //     context,
    //     PageRouteBuilder(
    //         opaque: false,
    //         barrierColor: Colors.transparent,
    //         fullscreenDialog: true,
    //         pageBuilder:
    //             (context, animation, secondaryAnimation) {
    //           return const PlaylistPage();
    //         },
    //         transitionsBuilder: (context, animation,
    //             secondaryAnimation, child) {
    //           // 实现过渡动效（上下移动）
    //           const begin = Offset(0.0, 1.0);
    //           const end = Offset.zero;
    //           const curve = Curves.ease;
    //
    //           final tween = Tween(begin: begin, end: end)
    //               .chain(CurveTween(curve: curve));
    //
    //           return SlideTransition(
    //             position: animation.drive(tween),
    //             child: child,
    //           );
    //         }));
  }
}
