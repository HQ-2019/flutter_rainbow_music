import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rainbow_music/base/utils/eventbus_util.dart';
import 'package:flutter_rainbow_music/base/utils/router_observer_util.dart';
import 'package:flutter_rainbow_music/manager/player/eventbus/player_event.dart';
import 'package:flutter_rainbow_music/manager/player/player_manager.dart';
import 'package:flutter_rainbow_music/views/pages/home/home_page.dart';
import 'package:flutter_rainbow_music/views/pages/my/my_page.dart';
import 'package:flutter_rainbow_music/views/widgets/player_view.dart';

class TabBarPage extends StatefulWidget {
  const TabBarPage({super.key});

  @override
  State<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> with RouteAware {
  int _currentIndex = 0;
  final List<Widget> _pageList = [const HomePage(), const MyPage(title: '我的')];

  // 系统提供的icons可参阅 https://fonts.google.com/icons
  // final List<BottomNavigationBarItem> _barItemList = [
  //   const BottomNavigationBarItem(
  //       icon: Icon(Icons.music_note_outlined), label: "首页"),
  //   const BottomNavigationBarItem(icon: Icon(Icons.person), label: "我的"),
  // ];
  final List<Tab> _barItemList = [
    const Tab(
      text: "首页",
      icon: Icon(Icons.music_note_outlined),
      iconMargin: EdgeInsets.zero,
    ),
    const Tab(
      text: "我的",
      icon: Icon(Icons.person),
      iconMargin: EdgeInsets.zero,
    ),
  ];

  bool _bottomViewIsVisible = true;
  bool _bottomBarIsVisible = true;
  bool _playViewIsVisible = false;
  OverlayEntry? _overlayEntry;
  StreamSubscription? _playSubscription;
  StreamSubscription? _playlistPageSubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bottomContainer();
    });

    _playSubscription = eventBus.on<MusicPlayEvent>().listen((event) {
      if (!_playViewIsVisible) {
        setState(() {
          _playViewIsVisible = true;
        });
        _updateOverlay();
      }
    });

    _playlistPageSubscription =
        eventBus.on<PlayViewVisibleEvent>().listen((event) {
      if (_bottomViewIsVisible == event.isVisible) {
        setState(() {
          _bottomViewIsVisible = !event.isVisible;
        });
        _updateOverlay();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _overlayEntry?.remove();
    _playSubscription?.cancel();
    _playlistPageSubscription?.cancel();
    super.dispose();
  }

  @override
  void didPush() {
    super.didPush();
    print('Page is now visible');
  }

  @override
  void didPop() {
    super.didPop();
    print('Popped from this page');
  }

  @override
  void didPushNext() {
    super.didPushNext();
    print('Navigated to another page');
    setState(() {
      _bottomBarIsVisible = false;
    });
  }

  @override
  void didPopNext() {
    super.didPopNext();
    print('Returned to this page');
    setState(() {
      _bottomBarIsVisible = true;
      _bottomViewIsVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = _bottomBarIsVisible
        ? (MediaQuery.of(context).padding.bottom + 49)
        : 0.0;
    return Scaffold(
      body: AnimatedContainer(
        margin: EdgeInsets.only(bottom: bottomInset),
        duration: const Duration(milliseconds: 300),
        child: IndexedStack(
          index: _currentIndex,
          children: _pageList,
        ),
      ),
    );
  }

  void _bottomContainer() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _updateOverlay() {
    _overlayEntry?.remove();
    _bottomContainer();
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: AnimatedOpacity(
          opacity: _bottomViewIsVisible ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: IgnorePointer(
            ignoring: !_bottomViewIsVisible,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_playViewIsVisible) ...[
                  _playView(),
                ],
                AnimatedContainer(
                  height: _bottomBarIsVisible
                      ? (MediaQuery.of(context).padding.bottom + 49)
                      : 0,
                  width: double.infinity,
                  duration: const Duration(milliseconds: 300),
                  // color: Colors.white,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.purple.withOpacity(0.1),
                        Colors.blue.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: Wrap(
                    children: [
                      DefaultTabController(
                        length: _barItemList.length,
                        child: TabBar(
                          tabs: _barItemList,
                          padding: EdgeInsets.zero,
                          labelColor: Colors.pinkAccent,
                          labelStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          unselectedLabelColor: Colors.black54,
                          indicatorColor: Colors.transparent,
                          dividerHeight: 0,
                          onTap: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                      ),
                      // BottomNavigationBar(
                      //   backgroundColor: Colors.white,
                      //   currentIndex: _currentIndex,
                      //   items: _barItemList,
                      //   type: BottomNavigationBarType.fixed,
                      //   iconSize: 30,
                      //   selectedFontSize: 12,
                      //   selectedItemColor: Colors.pinkAccent,
                      //   unselectedItemColor: Colors.black54,
                      //   onTap: (index) {
                      //     setState(() {
                      //         _currentIndex = index;
                      //       });
                      //   },
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _playView() {
    return Stack(children: [
      AnimatedContainer(
        margin: const EdgeInsets.only(top: 20),
        height: _bottomBarIsVisible ? 30 : 50,
        width: double.infinity,
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin:
                _bottomBarIsVisible ? Alignment.bottomCenter : Alignment.center,
            end: Alignment.topCenter,
            colors: [
              Colors.white,
              Colors.white.withOpacity(0),
            ],
          ),
        ),
      ),
      PlayerView(
        margin: const EdgeInsets.only(left: 15, right: 15),
        height: 50,
        width: double.infinity,
        song: PlayerManager().currentSong,
      ),
    ]);
  }
}
