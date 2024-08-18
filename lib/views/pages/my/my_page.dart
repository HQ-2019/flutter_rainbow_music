import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rainbow_music/base/utils/eventbus_util.dart';
import 'package:flutter_rainbow_music/base/widgets/song_cover_image_view.dart';
import 'package:flutter_rainbow_music/manager/user/user_manager.dart';
import 'package:flutter_rainbow_music/views/pages/favorite/favorite_page.dart';
import 'package:flutter_rainbow_music/views/pages/local_songs/local_songs_page.dart';
import 'package:flutter_rainbow_music/views/pages/login/login_page.dart';
import 'package:flutter_rainbow_music/views/pages/my/logic.dart';
import 'package:flutter_rainbow_music/views/pages/played_songs/played_songs_page.dart';
import 'package:get/get.dart';

class MyPage extends StatefulWidget {
  final String title;

  const MyPage({super.key, required this.title});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with AutomaticKeepAliveClientMixin {
  final _logic = Get.put(MyPageLogic());
  final ValueNotifier<bool> _isLogin = ValueNotifier(UserManager.isLogin());
  StreamSubscription? _loginStateSubscription;

  @override
  bool get wantKeepAlive => false;

  @override
  void dispose() {
    _logic.dispose();
    Get.delete<MyPageLogic>();
    _loginStateSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loginStateSubscription = eventBus.on<LoginStateEvent>().listen((event) {
      _isLogin.value = event.isLogin;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // 使用AutomaticKeepAliveClientMixin时需要调super.build
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: false,
        titleSpacing: NavigationToolbar.kMiddleSpacing,
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: _isLogin,
            builder: (context, isLogin, child) {
              return isLogin
                  ? IconButton(
                      onPressed: () {
                        UserManager().logout();
                      },
                      icon: const Icon(Icons.logout),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.withOpacity(0.1),
                Colors.purple.withOpacity(0.2)
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 15, bottom: 60),
        child: GetBuilder<MyPageLogic>(
          builder: (logic) {
            return Column(children: [
              _userView(),
              _tabsView(),
              _recentlyPlayView(),
            ]);
          },
        ),
      ),
    );
  }

  Widget _userView() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isLogin,
      builder: (context, isLogin, child) {
        final user = UserManager().user;
        final phoneNumText =
            isLogin && user?.phone != null ? user!.phone! : '立即登录';
        final nicknameText =
            isLogin && user?.nickname != null ? user!.nickname! : '登录后畅听更多动听音乐';
        return GestureDetector(
          onTap: isLogin
              ? null
              : () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
          child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.pinkAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.all(10),
                    child: const Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.black12,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        phoneNumText,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        nicknameText,
                        style: const TextStyle(fontSize: 14),
                      )
                    ],
                  )
                ],
              )),
        );
      },
    );
  }

  Widget _tabsView() {
    return Container(
        height: 120,
        margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Row(
          children: [
            _tabItemView(
              title: '收藏',
              count: _logic.favoriteCount,
              icon: Icon(
                Icons.favorite,
                color: Colors.pinkAccent.shade100,
                size: 50,
              ),
              onTap: () {
                if (_pushLoginPage()) {
                  return;
                }
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const FavoritePage(),
                  ),
                );
              },
            ),
            _tabItemView(
              title: '下载',
              count: _logic.downloadCount,
              icon: Icon(
                Icons.download,
                color: Colors.green.shade200,
                size: 50,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const LocalSongsPage(),
                  ),
                );
              },
            ),
            _tabItemView(
              title: '历史播放',
              count: _logic.playedCount,
              icon: Icon(
                Icons.menu,
                color: Colors.red.shade200,
                size: 50,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const PlayedSongsPage(),
                  ),
                );
              },
            ),
          ],
        ));
  }

  bool _pushLoginPage() {
    if (UserManager.isLogin()) {
      return false;
    }
    Navigator.push(
      context,
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => const LoginPage(),
      ),
    );
    return true;
  }

  Widget _tabItemView(
      {required String title,
      required int count,
      required Icon icon,
      Decoration? decoration,
      GestureTapCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: decoration,
          child: Column(
            children: [
              icon,
              Text(title),
              Text(count.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recentlyPlayView() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '最近播放歌单',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: ListView.separated(
              itemCount: 5,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  width: 10,
                );
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: const SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 100,
                          child: SongCoverImageView(
                              coverUrl:
                                  'https://imgessl.kugou.com/stdmusic/20240709/20240709181216225472.jpg'),
                        ),
                        SizedBox(height: 5),
                        Text('三年级科是那几款电脑上尽可能 那就肯定是',
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
