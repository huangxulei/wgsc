import 'package:flutter_modular/flutter_modular.dart';
import '../poetry/peotry_module.dart';
import '../writer/writer_module.dart';

class MenuRouteItem {
  final String path;
  final Module module;

  const MenuRouteItem({
    required this.path,
    required this.module,
  });
}

class MenuRoute {
  final List<MenuRouteItem> menuList;

  const MenuRoute(this.menuList);

  int get size => menuList.length;

  List<Module> get moduleList {
    return menuList.map((e) => e.module).toList();
  }

  List<ModuleRoute> get routes {
    return menuList.map((e) => ModuleRoute(e.path, module: e.module)).toList();
  }

  getPath(int index) {
    return menuList[index].path;
  }
}

//初始化菜单栏 path 路由 module 指向 模块 menuList = 参数
final MenuRoute menu = MenuRoute([
  MenuRouteItem(
    path: "/poetry",
    module: PoetryModule(),
  ),
  MenuRouteItem(
    path: "/writer",
    module: WriterModule(),
  ),
]);
