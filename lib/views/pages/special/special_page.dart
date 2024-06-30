import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rainbow_music/base/extension/string.dart';
import 'package:flutter_rainbow_music/base/widgets/custom_sliver_persistent_header_delegate.dart';
import 'package:flutter_rainbow_music/manager/player/provider/music_provider.dart';
import 'package:flutter_rainbow_music/model/rank_item_model.dart';
import 'package:flutter_rainbow_music/model/special_item_model.dart';
import 'package:flutter_rainbow_music/manager/player/player_manager.dart';
import 'package:flutter_rainbow_music/views/pages/special/logic.dart';
import 'package:flutter_rainbow_music/views/widgets/song_item_view.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// 专属歌单
class SpecialPage extends StatefulWidget {
  int? specailId;
  SpecialItemModel? model;

  SpecialPage({super.key, this.model, this.specailId});

  @override
  State<StatefulWidget> createState() => _SpecialPageState();
}

class _SpecialPageState extends State<SpecialPage>
    with SingleTickerProviderStateMixin {
  final _logic = Get.put(SpecialPageLogic());

  final ScrollController _scrollController = ScrollController();
  double _blurSigma = 0.0;
  double _offset = 0.0;

  final String _bannerName = 'banner_${Random().nextInt(3) + 1}.png';

  @override
  void initState() {
    if (widget.specailId != null) {
      _logic.specailId = widget.specailId;
    }
    if (widget.model != null) {
      final m = SpecialItemModel.fromJson(widget.model!.toJson())
        ..songs?.clear();
      _logic.model = m;
    }
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<SpecialPageLogic>();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // 设置顶部视图的毛玻璃效果
    _offset = _scrollController.offset;
    setState(() {
      _blurSigma = (_offset / 30.0).clamp(0.0, 10.0);
    });

    // 自动加载更多
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<SpecialPageLogic>(
        builder: (logic) {
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
                child: SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 50),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _sliverAppBar(SpecialItemModel? model) {
    return SliverAppBar(
      title: Text(_offset < 150 ? '歌单' : (model?.specialname ?? '')),
      backgroundColor: Colors.blue.shade50,
      expandedHeight: 230,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.none,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              ImageString.imagePath(name: _bannerName),
              fit: BoxFit.cover,
            ),
            Positioned(
              left: 15,
              right: 10,
              bottom: 30,
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 120,
                        height: 120,
                        color: Colors.white70.withOpacity(0.1),
                        child: CachedNetworkImage(
                          imageUrl: model?.imgurl ?? '',
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorWidget: (context, error, stackTrace) =>
                              Container(
                                  width: 60, height: 60, color: Colors.white70),
                        ),
                      )),
                  const SizedBox(width: 10),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model?.specialname ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (model?.userAvatar != null ||
                                model?.username != null) ...[
                              Padding(
                                padding: const EdgeInsets.only(right: 40),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          color:
                                              Colors.white70.withOpacity(0.1),
                                          child: CachedNetworkImage(
                                            imageUrl: model?.userAvatar ?? '',
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                            errorWidget:
                                                (context, error, stackTrace) =>
                                                    Container(
                                                        width: 20,
                                                        height: 20,
                                                        color: Colors.white70),
                                          ),
                                        )),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        model?.username ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                            Padding(
                              padding: const EdgeInsets.only(right: 40),
                              child: Text(
                                model?.intro ?? '',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: _blurSigma, sigmaY: _blurSigma),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sliverPersistentHeader(List<RankSongItemModel>? songs) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: CustomSliverPersistentHeaderDelegate(
        minHeight: 50,
        maxHeight: 50,
        child: Container(
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
                if (songs != null && songs.isNotEmpty) {
                  PlayerManager().playList(song: songs.first, list: songs);
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

  Widget _listView(List<RankSongItemModel>? songs) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          var itemModel = songs?[index];
          return Container(
            // margin: const EdgeInsets.symmetric(vertical: 5),
            child: SongItemView(
              ranking: index + 1,
              padding: const EdgeInsets.all(6),
              coverUrl: itemModel?.fetchCoverUrl() ?? '',
              songName: itemModel?.fetchSongName() ?? '--',
              singerName: itemModel?.fetchSingerName() ?? '--',
              isSelected: itemModel?.fetchIsSelected() ?? false,
              onTap: () {
                if (itemModel != null) {
                  PlayerManager().playList(
                      song: itemModel, list: songs!.cast<MusicProvider>());
                }
              },
            ),
          );
        },
        childCount: max(0, songs?.length ?? 0),
      ),
    );
  }
}
