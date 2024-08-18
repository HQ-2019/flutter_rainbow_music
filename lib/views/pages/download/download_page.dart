import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rainbow_music/manager/player/player_manager.dart';
import 'package:flutter_rainbow_music/manager/player/provider/music_provider.dart';
import 'package:flutter_rainbow_music/manager/user/user_manager.dart';
import 'package:flutter_rainbow_music/model/song_item_model.dart';
import 'package:flutter_rainbow_music/views/pages/download/logic.dart';
import 'package:flutter_rainbow_music/views/pages/favorite/logic.dart';
import 'package:flutter_rainbow_music/views/pages/login/login_page.dart';
import 'package:flutter_rainbow_music/views/widgets/song_item_view.dart';
import 'package:get/get.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<StatefulWidget> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  final _logic = Get.put(DownloadPageLogic());

  @override
  void dispose() {
    Get.delete<DownloadPageLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('下载'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: GetBuilder<DownloadPageLogic>(
        builder: (logic) {
          return Column(
            children: [
              _headerView(),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(
                      top: 20,
                      bottom: MediaQuery.of(context).padding.bottom + 50),
                  itemCount: logic.songs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final song = logic.songs[index];
                    return _songItemView(song);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _headerView() {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () {
            if (_logic.songs.isNotEmpty) {
              PlayerManager().playList(
                song: _logic.songs.first,
                list: _logic.songs,
              );
            }
          },
          style: TextButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_circle,
                size: 20,
                color: Colors.black54,
              ),
              SizedBox(width: 4.0),
              Text(
                '播放全部',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _songItemView(SongItemModel song) {
    return SongItemView(
      padding: const EdgeInsets.only(top: 6, bottom: 6, right: 8, left: 16),
      coverUrl: song.fetchCoverUrl() ?? '',
      songName: song.fetchSongName() ?? '--',
      singerName: song.fetchSingerName() ?? '--',
      isSelected: song.fetchIsSelected(),
      isFavorite: UserManager().isFavoriteSong(song.hash),
      onTap: () {
        PlayerManager().playList(
            song: song,
            list: _logic.songs.cast<MusicProvider>(),
            source: '歌单：收藏');
      },
      favoriteTap: () {
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
    );
  }
}
