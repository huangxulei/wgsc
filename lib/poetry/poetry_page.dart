import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gsc/bean/poetry.dart';

import '../dao/poetry_dao.dart';

class PoetryPage extends StatefulWidget {
  const PoetryPage({super.key});

  @override
  State<PoetryPage> createState() => _PoetryPageState();
}

class _PoetryPageState extends State<PoetryPage> {
  final ValueNotifier<int> _pid = ValueNotifier(1);
  Poetry? poetry;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    final Poetry p = await PoetryDao.getPoetrysByid(_pid.value);

    setState(() {
      poetry = p;
      _isLoading = false;
    });
  }

  void changePid(int pid) {
    _pid.value = pid;
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _pid,
        builder: (BuildContext context, value, Widget? child) {
          return Scaffold(
              body: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                alignment: Alignment.center,
                width: 50,
                child: FloatingActionButton(
                  onPressed: () {
                    changePid(_pid.value - 1);
                  },
                  child: const Icon(Icons.arrow_left),
                ),
              ),
              Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : _poetryView()),
              Container(
                  margin: EdgeInsets.only(left: 10),
                  alignment: Alignment.center,
                  width: 50,
                  child: FloatingActionButton(
                    onPressed: () {
                      changePid(_pid.value + 1);
                    },
                    child: const Icon(Icons.arrow_right),
                  )),
            ],
          ));
        });
  }

  Widget _poetryView() {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "${poetry?.title}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 30, color: Colors.red),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Html(
              data: poetry?.content,
              style: {
                "body": Style(
                  fontSize: FontSize(22.0), // 设置全局字体大小
                ),
              },
            ),
          ))
        ],
      ),
    );
  }
}
