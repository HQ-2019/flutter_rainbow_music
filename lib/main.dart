import 'package:flutter/material.dart';

import 'package:flutter_rainbow_music/base/loading/loading.dart';
import 'package:flutter_rainbow_music/base/utils/router_observer_util.dart';
import 'package:flutter_rainbow_music/base/utils/sp_util.dart';
import 'package:flutter_rainbow_music/manager/user/user_manager.dart';
import 'package:flutter_rainbow_music/views/pages/tabbar/tabbar_page.dart';

void main() async {
  // 将main方法改成async, 提前初始化SharedPreferences，尽量避免使用时报未初始化错误
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TabBarPage(),
      navigatorObservers: [routeObserver],
      builder: Loading.init(),
    );
  }
}
