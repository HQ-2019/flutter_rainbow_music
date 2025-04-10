import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rainbow_music/views/pages/mv/mv_page.dart';
import 'package:flutter_rainbow_music/views/pages/recommend/recommend_page.dart';

/// 首页框架
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  late PageController _pageController;
  final List<String> _tabs = ["推荐", "MV"];
  final List<Widget> _pageViewList = [
    const RecommendPage(),
    const MvPage(),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _tabController = TabController(length: _tabs.length, vsync: this);
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TabBar(
          padding: const EdgeInsets.only(top: 10),
          controller: _tabController,
          tabs: _tabs
              .map((e) => Tab(
                      child: Text(
                    e,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  )))
              .toList(),
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          labelColor: Colors.pink.shade300,
          unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.pink.shade300,
          onTap: (index) {
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut);
          },
        ),
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
      body: PageView(
        controller: _pageController,
        physics: const ClampingScrollPhysics(),
        onPageChanged: (index) {
          log('页面切换到 index $index');
          setState(() {
            _tabController.animateTo(index);
          });
        },
        children: _pageViewList,
      ),
    );
  }
}
