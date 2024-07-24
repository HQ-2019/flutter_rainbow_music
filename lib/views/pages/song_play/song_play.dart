import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rainbow_music/base/utils/color_util.dart';
import 'package:flutter_rainbow_music/base/utils/eventbus_util.dart';
import 'package:flutter_rainbow_music/base/utils/time_formatter.dart';
import 'package:flutter_rainbow_music/base/utils/router_observer_util.dart';
import 'package:flutter_rainbow_music/base/widgets/audio_bars_animation.dart';
import 'package:flutter_rainbow_music/manager/player/eventbus/player_event.dart';
import 'package:flutter_rainbow_music/manager/player/player_manager.dart';
import 'package:flutter_rainbow_music/manager/player/provider/music_provider.dart';
import 'package:flutter_rainbow_music/manager/user/user_manager.dart';
import 'package:flutter_rainbow_music/views/pages/login/login_page.dart';
import 'package:flutter_rainbow_music/views/pages/playlist/playlist_page.dart';
import 'package:flutter_rainbow_music/views/pages/song_play/logic.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audioplayers/audioplayers.dart';

class SongPlayPage extends StatefulWidget {
  const SongPlayPage({super.key});

  @override
  State<StatefulWidget> createState() => _SongPlayPageState();
}

class _SongPlayPageState extends State<SongPlayPage> with RouteAware {
  final _logic = Get.put(SongPlayPageLogic());
  final ValueNotifier<double> _progress = ValueNotifier<double>(0.0);
  final ValueNotifier<int> _playTime = ValueNotifier<int>(0);
  PlayerState _playState = PlayerState.playing;

  StreamSubscription? _playStateSubscription;
  StreamSubscription? _playProgessSubscription;

  @override
  void initState() {
    super.initState();

    if (_logic.song != null) {
      _playState = _logic.song!.fetchPlayState();
    }

    _playProgessSubscription =
        eventBus.on<MusicPlayProgressEvent>().listen((event) {
      _progress.value = event.progress;
      _playTime.value = event.time;
    });

    _playStateSubscription = eventBus.on<MusicPlaySateEvent>().listen((event) {
      setState(() {
        _playState = event.playState;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    _logic.dispose();
    Get.delete<SongPlayPageLogic>();
    routeObserver.unsubscribe(this);
    _playProgessSubscription?.cancel();
    _playStateSubscription?.cancel();
    super.dispose();
  }

  @override
  void didPush() {
    super.didPush();
    Future.delayed(const Duration(milliseconds: 100), () {
      eventBus.fire(PlayViewVisibleEvent(true));
    });
  }

  @override
  void didPop() {
    super.didPop();
    eventBus.fire(PlayViewVisibleEvent(false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: GetBuilder<SongPlayPageLogic>(
        builder: (logic) {
          final song = logic.song;
          return Stack(
            children: [
              _backgroundView(song),
              Column(
                children: [
                  Expanded(
                    child: _songInfoView(song),
                  ),
                  const SizedBox(height: 10),
                  _playControlView(song),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _backgroundView(MusicProvider? song) {
    final imageUrl = song?.fetchCoverUrl() ?? '';
    final themeColor = song?.fetchThemeColor() ?? ColorUtil.randomDarkColor();
    return Stack(
      children: [
        Container(
          color: themeColor,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            useOldImageOnUrlChange: true,
            errorWidget: (context, error, stackTrace) =>
                Container(color: Colors.transparent),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: themeColor.withOpacity(0.85),
          ),
        ),
      ],
    );
  }

  Widget _songInfoView(MusicProvider? song) {
    final themeColor = song?.fetchThemeColor() ?? ColorUtil.randomDarkColor();
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 50),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 60, right: 60, top: 30),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 20,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Container(
                      height: double.infinity,
                      color: themeColor,
                      child: CachedNetworkImage(
                        imageUrl: song?.fetchCoverUrl() ?? '',
                        fit: BoxFit.cover,
                        useOldImageOnUrlChange: true,
                        errorWidget: (context, error, stackTrace) => Container(
                          color: themeColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              song?.fetchSongName() ?? '歌曲',
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
            Text(
              song?.fetchSingerName() ?? '',
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 20),
            const Text(
              '暂无歌词',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _playControlView(MusicProvider? song) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 30,
            child: Stack(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: AudioBarsAnimation(
                    itemCount: 5,
                  ),
                ),
                Row(
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: 40,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        color: UserManager().isFavoriteSong(song?.fetchHash())
                            ? Colors.pinkAccent
                            : Colors.white70,
                        icon: const Icon(
                          Icons.favorite_border,
                          size: 25,
                        ),
                        onPressed: () {
                          if (UserManager.isLogin()) {
                            _logic.updateFavoriteSong(song);
                            return;
                          }
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
                        padding: EdgeInsets.zero,
                        color: Colors.white70,
                        icon: const Icon(
                          Icons.file_download_outlined,
                          size: 25,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 30,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: ValueListenableBuilder<int>(
                      valueListenable: _playTime,
                      builder: (context, value, child) {
                        return Text(
                          TimeFormatter.formatDuration(value),
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                        );
                      }),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ValueListenableBuilder<double>(
                    valueListenable: _progress,
                    builder: (context, value, child) {
                      return LinearProgressIndicator(
                        minHeight: 4,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        value: value,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                        borderRadius: BorderRadius.circular(2),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 50,
                  child: Text(
                    TimeFormatter.formatDuration(
                        PlayerManager().timeLenght ?? 0),
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: IconButton(
                      iconSize: 30,
                      icon: Icon(
                        _logic.fetchPlayModeIcon(),
                        color: Colors.white.withOpacity(0.5),
                      ),
                      onPressed: () => _logic.changePlayMode(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: IconButton(
                      iconSize: 35,
                      icon:
                          const Icon(Icons.skip_previous, color: Colors.white),
                      onPressed: () => _logic.playLast(),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: IconButton(
                      iconSize: 35,
                      icon: Icon(
                          _playState == PlayerState.playing
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white),
                      onPressed: () => _logic.play(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: IconButton(
                      iconSize: 35,
                      icon: const Icon(Icons.skip_next, color: Colors.white),
                      onPressed: () => _logic.playNext(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: IconButton(
                      iconSize: 30,
                      icon: Icon(
                        Icons.queue_music,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      onPressed: () => _playListButtonTap(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _playListButtonTap(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        fullscreenDialog: true,
        pageBuilder: (context, animation, secondaryAnimation) {
          return const PlaylistPage(updatePlayViewVisible: false);
        },
      ),
    );
  }
}
