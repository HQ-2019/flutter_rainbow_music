import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rainbow_music/base/extension/string.dart';
import 'package:flutter_rainbow_music/base/widgets/custom_sliver_persistent_header_delegate.dart';
import 'package:flutter_rainbow_music/manager/player/provider/music_provider.dart';
import 'package:flutter_rainbow_music/manager/user/user_manager.dart';
import 'package:flutter_rainbow_music/model/rank_item_model.dart';
import 'package:flutter_rainbow_music/manager/player/player_manager.dart';
import 'package:flutter_rainbow_music/model/song_item_model.dart';
import 'package:flutter_rainbow_music/views/pages/login/login_page.dart';
import 'package:flutter_rainbow_music/views/pages/song_chart/logic.dart';
import 'package:flutter_rainbow_music/views/widgets/song_item_view.dart';
import 'package:get/get.dart';

/// 歌曲排行榜
class SongChartPage extends StatefulWidget {
  final RankItemModel model;

  const SongChartPage({super.key, required this.model});

  @override
  State<StatefulWidget> createState() => _SongChartPageState();
}

class _SongChartPageState extends State<SongChartPage>
    with SingleTickerProviderStateMixin {
  final _logic = Get.put(SongChartPageLogic());

  final ScrollController _scrollController = ScrollController();
  double _blurSigma = 0.0;
  double _offset = 0.0;

  final String _bannerName = 'banner_${Random().nextInt(3) + 1}.png';

  @override
  void initState() {
    _logic.model = RankItemModel.fromJson(widget.model.toJson())
      ..songs?.clear();

    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<SongChartPageLogic>();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // 设置顶部视图的毛玻璃效果
    _offset = _scrollController.offset;
    setState(() {
      _blurSigma = (_offset / 30).clamp(0.0, 10.0);
    });

    // 自动加载更多
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _logic.fetchRankInfo(_logic.model?.rankid ?? 0, loadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<SongChartPageLogic>(builder: (logic) {
        return CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            _sliverAppBar(logic.model),
            _sliverPersistentHeader(logic.model?.songs),
            const SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),
            _listView(logic.model?.songs),
            SliverToBoxAdapter(
              child:
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 50),
            )
          ],
        );
      }),
    );
  }

  Widget _sliverAppBar(RankItemModel? model) {
    return SliverAppBar(
      title: _offset < 150 ? null : Text(model?.rankname ?? ''),
      backgroundColor: Colors.purple.shade50,
      expandedHeight: 200,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        // title: const Text('移动的标题'),
        centerTitle: true,
        collapseMode: CollapseMode.parallax,
        expandedTitleScale: 1.5,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              ImageString.imagePath(name: _bannerName),
              fit: BoxFit.cover,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: _blurSigma, sigmaY: _blurSigma),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 60,
              child: Column(
                children: [
                  Text(
                    model?.rankname ?? '',
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic),
                  ),
                  Text(
                    '更新：${model?.rankIdPublishDate ?? '--'}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sliverPersistentHeader(List<SongItemModel>? songs) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: CustomSliverPersistentHeaderDelegate(
        minHeight: 50,
        maxHeight: 50,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                if (songs != null && songs.isNotEmpty) {
                  PlayerManager().playList(
                      song: songs.first,
                      list: songs,
                      source: '排行榜：${_logic.model?.rankname}');
                }
              },
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.play_circle,
                    size: 20,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 4.0),
                  Text.rich(
                    TextSpan(
                      text: '播放全部',
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      children: [
                        TextSpan(
                            text: ' ${songs?.length ?? ''}',
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                fontWeight: FontWeight.w600))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _listView(List<SongItemModel>? songs) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          var itemModel = songs?[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 0),
            child: SongItemView(
              ranking: index + 1,
              padding: const EdgeInsets.all(6),
              coverUrl: itemModel?.fetchCoverUrl() ?? '',
              songName: itemModel?.fetchSongName() ?? '--',
              singerName: itemModel?.fetchSingerName() ?? '--',
              isSelected: itemModel?.fetchIsSelected() ?? false,
              isFavorite: UserManager().isFavoriteSong(itemModel?.hash),
              onTap: () {
                if (itemModel != null) {
                  PlayerManager().playList(
                      song: itemModel, list: songs!.cast<MusicProvider>());
                }
              },
              favoriteTap: () {
                if (itemModel == null) {
                  return;
                }
                if (UserManager.isLogin()) {
                  UserManager().updateFavoriteSong(itemModel);
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
          );
        },
        childCount: max(0, songs?.length ?? 0),
      ),
    );
  }
}
