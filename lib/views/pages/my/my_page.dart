import 'dart:math';

import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  final String title;

  const MyPage({super.key, required this.title});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
      body: Container(
        color: Colors.purple,
        child: Column(children: [
          const SizedBox(
            height: 50,
          ),
          _gridView(),
          const SizedBox(
            height: 50,
          ),
          _specialView()
        ]),
      ),
    );
  }

  Widget _gridView() {
    double itemHeight = 100; // 子项高度
    double itemWidth = 80; // 子项宽度
    int itemCount = 23; // 子项总数
    int crossAxisCount = min(2, itemCount); // 行数
    double viewHeight =
        crossAxisCount * itemHeight + (crossAxisCount - 1) * 10; // 动态计算高度
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      height: viewHeight,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount, // 每行显示的子项数
          mainAxisSpacing: 5, // 行间距
          crossAxisSpacing: 5, // 列间距
          childAspectRatio: itemHeight / itemWidth, // 设置子项的宽高比
        ),
        itemBuilder: (context, index) {
          return Container(
            color: Colors.blue,
          );
        },
        itemCount: itemCount,
      ),
    );
  }

  Widget _specialView() {
    int itemCount = 11; // 子项总数
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<Widget>.generate((itemCount / 2).ceil(), (index) {
          return Container(
            margin: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.red,
                ),
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.yellow,
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
