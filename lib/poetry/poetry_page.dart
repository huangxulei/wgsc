import 'package:flutter/material.dart';

class PoetryPage extends StatefulWidget {
  const PoetryPage({super.key});

  @override
  State<PoetryPage> createState() => _PoetryPageState();
}

class _PoetryPageState extends State<PoetryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("诗歌界面"),
    );
  }
}
