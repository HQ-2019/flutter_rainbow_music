import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MvPage extends StatefulWidget {
  const MvPage({super.key});

  @override
  State<StatefulWidget> createState() => _MvPageState();
}

class _MvPageState extends State<MvPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      body: const Center(
        child: Text('制作中，敬请期待'),
      ),
    );
  }
}
