import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rainbow_music/manager/player/player_manager.dart';
import 'package:flutter_rainbow_music/manager/player/provider/music_provider.dart';
import 'package:flutter_rainbow_music/manager/user/user_manager.dart';
import 'package:flutter_rainbow_music/model/song_item_model.dart';
import 'package:flutter_rainbow_music/views/pages/local_songs/logic.dart';
import 'package:flutter_rainbow_music/views/pages/login/login_page.dart';
import 'package:get/get.dart';

class LocalSongsPage extends StatefulWidget {
  const LocalSongsPage({super.key});

  @override
  State<StatefulWidget> createState() => _LocalSongsPageState();
}

class _LocalSongsPageState extends State<LocalSongsPage> {
  final _logic = Get.put(LocalSongsLogic());

  @override
  void dispose() {
    _logic.dispose();
    Get.delete<LocalSongsLogic>();
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
        title: const Text('本地歌曲'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: GetBuilder<LocalSongsLogic>(
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
    final songName = song.fetchSongName() ?? '--';
    final singerName = song.fetchSingerName() ?? '--';
    final isSelected = song.fetchIsSelected();
    final isFavorite = UserManager().isFavoriteSong(song.hash);
    return GestureDetector(
      onTap: () {
        PlayerManager().playList(
          song: song,
          list: _logic.songs.cast<MusicProvider>(),
          source: '本地歌曲 ',
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        width: double.infinity,
        height: 70,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(songName,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 15,
                          color: isSelected ? Colors.blue : Colors.black,
                          overflow: TextOverflow.ellipsis)),
                  Text(singerName,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.blue : Colors.black54,
                          overflow: TextOverflow.ellipsis))
                ],
              ),
            ),
            SizedBox(
              width: 40,
              child: IconButton(
                icon:
                    const Icon(Icons.playlist_add_sharp, color: Colors.black26),
                onPressed: () {
                  PlayerManager().addPlaySong(song: song, toNext: true);
                },
              ),
            ),
            SizedBox(
              width: 40,
              child: IconButton(
                icon: isFavorite
                    ? const Icon(Icons.favorite, color: Colors.pinkAccent)
                    : const Icon(Icons.favorite_border, color: Colors.black26),
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
          ],
        ),
      ),
    );
  }
}
