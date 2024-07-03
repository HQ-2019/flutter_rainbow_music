import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rainbow_music/manager/player/player_manager.dart';
import 'package:flutter_rainbow_music/manager/user/user_manager.dart';
import 'package:flutter_rainbow_music/model/banner_model.dart';
import 'package:flutter_rainbow_music/model/rank_item_model.dart';
import 'package:flutter_rainbow_music/model/song_item_model.dart';
import 'package:flutter_rainbow_music/model/special_item_model.dart';
import 'package:flutter_rainbow_music/views/pages/login/login_page.dart';
import 'package:flutter_rainbow_music/views/pages/recommend/logic.dart';
import 'package:flutter_rainbow_music/views/pages/song_chart/song_chart_page.dart';
import 'package:flutter_rainbow_music/views/pages/special/special_page.dart';
import 'package:flutter_rainbow_music/views/widgets/rank_item_view.dart';
import 'package:flutter_rainbow_music/views/widgets/song_item_view.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rainbow_music/views/widgets/special_item_view.dart';

/// 首页推荐
class RecommendPage extends StatefulWidget {
  const RecommendPage({super.key});

  @override
  State<StatefulWidget> createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage>
    with AutomaticKeepAliveClientMixin {
  final logic = Get.put(RecommendPageLogic());

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    Get.delete<RecommendPageLogic>();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    logic.fetchRecommendInfo();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.pink.shade50.withOpacity(0.5),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 15, bottom: 60),
          child: GetBuilder<RecommendPageLogic>(
            builder: (logic) {
              // 子项列表
              List<Widget> columnChildren = [];

              final bannerList = logic.model.bannerList;
              final newSongList = logic.model.data;
              final specialList = logic.model.specialList;
              final rankList = logic.model.rankList;

              if (bannerList != null && bannerList.isNotEmpty) {
                columnChildren.add(_bannerView(bannerList));
              }
              if (newSongList != null && newSongList.isNotEmpty) {
                columnChildren.add(_newSongListView(newSongList));
              }
              if (specialList != null && specialList.isNotEmpty) {
                columnChildren.add(_specialView(specialList));
              }
              if (rankList != null && rankList.isNotEmpty) {
                columnChildren.add(_rankListView(rankList));
              }

              return Column(children: columnChildren);
            },
          ),
        ),
      ),
    );
  }

  Widget _bannerView(List<BannerModel> items) {
    final itemWidth = MediaQuery.of(context).size.width;
    const ratio = 3.0 / 1.0;
    final itemHeight = itemWidth / ratio;
    return CarouselSlider(
      options: CarouselOptions(
          height: itemHeight,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          viewportFraction: 0.9,
          enlargeFactor: 0.2,
          enlargeCenterPage: true),
      items: items.map((model) {
        return Builder(
          builder: (BuildContext context) => GestureDetector(
            onTap: () {
              if (model.extra == null) {
                return;
              }
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => SpecialPage(model: model.extra)));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.white24,
                width: itemWidth,
                child: CachedNetworkImage(
                  imageUrl: model.imgurl ?? '',
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _sectionHeaderView(String text) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      width: double.infinity,
      height: 44,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _newSongListView(List<SongItemModel> songs) {
    int itemCount = songs.length;
    if (!logic.isNewSongExpan) {
      itemCount = min(4, itemCount);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        _sectionHeaderView('新歌速递'),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            itemCount: itemCount,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var itemModel = songs[index];
              return SongItemView(
                padding: const EdgeInsets.all(8),
                borderRadius: 6,
                coverUrl: itemModel?.fetchCoverUrl() ?? '',
                songName: itemModel?.fetchSongName() ?? '--',
                singerName: itemModel?.fetchSingerName() ?? '--',
                isSelected: itemModel?.fetchIsSelected() ?? false,
                onTap: () {
                  if (itemModel == null) {
                    return;
                  }
                  PlayerManager().playList(
                      song: itemModel, list: songs, source: '首页：新歌速递');
                },
                favoriteTap: () {
                  if (UserManager.isLogin()) {
                    UserManager().addFavoriteSong();
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
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            logic.updateNewsongExpan();
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.white70,
            minimumSize: const Size(120, 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text(
            logic.isNewSongExpan ? '收起' : '展开全部',
            style: const TextStyle(color: Colors.black),
          ),
        )
      ]),
    );
  }

  Widget _rankListView(List<RankItemModel> items) {
    double itemHeight = 100; // 子项高度
    int itemCount = items.length; // 子项总数
    int crossAxisCount = min(3, itemCount); // 行数
    double viewHeight =
        crossAxisCount * itemHeight + (crossAxisCount - 1) * 10; // 动态计算高度
    return LayoutBuilder(builder: (context, constraints) {
      double itemWidth = constraints.maxWidth - 50; // 子项宽度
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: _sectionHeaderView('排行榜'),
          ),
          SizedBox(
            height: viewHeight,
            child: GridView.builder(
              padding: const EdgeInsets.only(left: 10, right: 10),
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount, // 每行显示的子项数
                mainAxisSpacing: 10, // 行间距
                crossAxisSpacing: 10, // 列间距
                childAspectRatio: itemHeight / itemWidth, // 设置子项的宽高比
              ),
              itemBuilder: (context, index) {
                final model = items[index];
                return RankItemView(
                    onTap: () {
                      if (model.rankid == null) {
                        return;
                      }
                      Navigator.push(
                          context,
                          CupertinoPageRoute<void>(
                              maintainState: false, // 是否前一个路由将保留在内存中
                              builder: (BuildContext context) =>
                                  SongChartPage(model: model)));
                    },
                    model: model);
              },
              itemCount: itemCount,
            ),
          )
        ],
      );
    });
  }

  Widget _specialView(List<SpecialItemModel> items) {
    double itemHeight = 150; // 子项高度
    double itemWidth = 100; // 子项宽度
    int itemCount = items.length; // 子项总数
    int crossAxisCount = min(2, itemCount); // 行数
    double viewHeight =
        crossAxisCount * itemHeight + (crossAxisCount - 1) * 10; // 动态计算高度

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _sectionHeaderView('专属推荐'),
        ),
        SizedBox(
          height: viewHeight,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount, // 每行显示的子项数
              mainAxisSpacing: 5, // 行间距
              crossAxisSpacing: 5, // 列间距
              childAspectRatio: itemHeight / itemWidth, // 设置子项的宽高比
            ),
            itemBuilder: (context, index) {
              final model = items[index];
              return SpecialItemView(
                  onTap: () {
                    if (model.specialid == null) {
                      return;
                    }
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => SpecialPage(model: model)));
                  },
                  coverUrl: model.imgurl ?? '',
                  specialName: model.specialname ?? '');
            },
            itemCount: itemCount,
          ),
        )
      ],
    );
  }
}
