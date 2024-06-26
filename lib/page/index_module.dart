import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'index_page.dart';
import 'init_page.dart';
import 'router.dart';

class IndexModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child("/", //1 默认从这里出发
        child: (_) => const InitPage(), // 2 这里执行跳转到/tab/popular/
        children: [
          ChildRoute(
            "/error",
            child: (_) => Scaffold(
              appBar: AppBar(title: const Text("古诗词")),
              body: const Center(child: Text("初始化失败")),
            ),
          ),
        ],
        transition: TransitionType.noTransition);
    r.child("/tab", child: (_) {
      return const IndexPage();
    }, children: menu.routes, transition: TransitionType.noTransition);
  }
}
