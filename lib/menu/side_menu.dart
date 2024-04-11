import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import '../page/router.dart';

class SideMenu extends StatefulWidget {
  //const SideMenu({Key? key}) : super(key: key);
  const SideMenu({super.key});
  @override
  State<SideMenu> createState() => _SideMenu();
}

class SideNavigationBarState extends ChangeNotifier {
  int _selectedIndex = 0;
  bool _isRailVisible = true;

  int get selectedIndex => _selectedIndex;
  bool get isRailVisible => _isRailVisible;

  void updateSelectedIndex(int pageIndex) {
    _selectedIndex = pageIndex;
    notifyListeners();
  }

  void hideNavigate() {
    debugPrint('尝试隐藏侧边栏');
    _isRailVisible = false;
    notifyListeners();
  }

  void showNavigate() {
    _isRailVisible = true;
    notifyListeners();
  }
}

class _SideMenu extends State<SideMenu> {
  final PageController _page = PageController();

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    return ChangeNotifierProvider(
      create: (context) => SideNavigationBarState(),
      child: Scaffold(
        body: Row(
          children: [
            Consumer<SideNavigationBarState>(builder: (context, state, child) {
              return SafeArea(
                child: Visibility(
                  visible: state.isRailVisible,
                  child: NavigationRail(
                    // extended: true,
                    groupAlignment: 1.0,
                    labelType: NavigationRailLabelType.selected,
                    leading: FloatingActionButton(
                      elevation: 0,
                      onPressed: () {},
                      child: Image.asset("assets/images/logo.png"),
                    ),

                    destinations: const <NavigationRailDestination>[
                      NavigationRailDestination(
                        selectedIcon: Icon(Icons.home),
                        icon: Icon(Icons.home_outlined),
                        label: Text('诗歌'),
                      ),
                      NavigationRailDestination(
                        selectedIcon: Icon(Icons.timeline),
                        icon: Icon(Icons.timeline_outlined),
                        label: Text('作者'),
                      ),
                    ],
                    selectedIndex: state.selectedIndex,
                    onDestinationSelected: (int index) {
                      state.updateSelectedIndex(index);
                      switch (index) {
                        case 0:
                          Modular.to.navigate('/tab/poetry/');
                          break;
                        case 1:
                          Modular.to.navigate('/tab/writer/');
                          break;
                      }
                    },
                  ),
                ),
              );
            }),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: PageView.builder(
                  controller: _page,
                  itemCount: menu.size,
                  onPageChanged: (i) =>
                      Modular.to.navigate("/tab${menu.getPath(i)}/"),
                  itemBuilder: (_, __) => const RouterOutlet(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
