import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rainbow_music/manager/player/player_manager.dart';
import 'package:flutter_rainbow_music/manager/player/provider/music_provider.dart';
import 'package:flutter_rainbow_music/manager/user/user_manager.dart';
import 'package:flutter_rainbow_music/model/song_item_model.dart';
import 'package:flutter_rainbow_music/views/pages/login/login_page.dart';
import 'package:flutter_rainbow_music/views/pages/played_songs/logic.dart';
import 'package:get/get.dart';

class PlayedSongsPage extends StatefulWidget {
  const PlayedSongsPage({super.key});

  @override
  State<StatefulWidget> createState() => _PlayedSongsPageState();
}

class _PlayedSongsPageState extends State<PlayedSongsPage> {
  final _logic = Get.put(PlayedSongsPageLogic());

  @override
  void dispose() {
    _logic.dispose();
    Get.delete<PlayedSongsPageLogic>();
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
        title: const Text('最近播放'),
        backgroundColor: Colors.white,
        elevation: 0, // 移除阴影
      ),
      backgroundColor: Colors.white,
      body: GetBuilder<PlayedSongsPageLogic>(
        builder: (logic) {
          return ListView.builder(
            padding: EdgeInsets.only(
              top: 20,
              bottom: MediaQuery.of(context).padding.bottom + 50,
            ),
            itemCount: logic.songs.length,
            itemBuilder: (BuildContext context, int index) {
              final song = logic.songs[index];
              final playCount = logic.getPlayCount(song.hash!) ?? 0;
              return _songItemView(song, playCount);
            },
          );
        },
      ),
    );
  }

  Widget _songItemView(SongItemModel song, int playCount) {
    final songName = song.songName ?? '--';
    final singerName = song.singerName ?? '--';
    final isSelected = song.isSelected;
    final isFavorite = UserManager().isFavoriteSong(song.hash);
    return GestureDetector(
      onTap: () {
        PlayerManager().playList(
          song: song,
          list: _logic.songs.cast<MusicProvider>(),
          source: '最近播放',
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
            const Icon(
              Icons.headset_rounded,
              size: 20,
              color: Colors.black26,
            ),
            const SizedBox(width: 2),
            Text(
              playCount.toString(),
              style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 14,
                  fontWeight: FontWeight.w200),
            ),
            const SizedBox(width: 5),
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
