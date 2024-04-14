import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gsc/common/store.dart';
import 'package:gsc/dao/writer_dao.dart';
import 'package:gsc/poetry/like_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../bean/info.dart';
import '../bean/poem.dart';
import '../dao/poetry_dao.dart';
import '../utils.dart';

class PoetryPage extends StatefulWidget {
  const PoetryPage({super.key});

  @override
  State<PoetryPage> createState() => _PoetryPageState();
}

class _PoetryPageState extends State<PoetryPage> with TickerProviderStateMixin {
  List<Poem> allPoem = [];
  late int currpid;
  late int _pid;
  late Poem poem;
  bool _isLoading = true;
  List<Info> infoList = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    _pid = GStorage.setting.get("currpid") ?? 0; //记录上次的查看的
    allPoem = await PoetryDao.getLike(); //获取根据喜欢的作品
    poem = allPoem[_pid]; //当前显示的作品
    infoList = await PoetryDao.findInfoByPid(poem.poetryid); //该作品下面的info
    _tabController = TabController(
      length: infoList.length,
      vsync: this,
    );
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> changePid(int pid) async {
    if (pid >= allPoem.length) {
      _pid = 1;
    } else if (pid == -1) {
      _pid = allPoem.length - 1;
    } else {
      _pid = pid;
    }
    await GStorage.setting.put("currpid", _pid); //修改索引
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () {
                  _attachImitate(context);
                },
                child: Text("筛选"))
          ],
        ),
        body: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              alignment: Alignment.center,
              width: 50,
              child: FloatingActionButton(
                onPressed: () {
                  changePid(_pid - 1);
                },
                child: const Icon(Icons.arrow_left),
              ),
            ),
            Flexible(
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
                    changePid(_pid + 1);
                  },
                  child: const Icon(Icons.arrow_right),
                )),
          ],
        ));
  }

  Widget _poetryView() {
    return SelectionArea(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "${poem.title} (${_pid + 1} / ${allPoem.length})",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 30, color: Colors.red),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 100),
              child: Text(
                "${dynastys[poem.dynastyid]} · ${poem.writername}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )),
          const SizedBox(
            height: 10,
          ),
          Flexible(
              child: SingleChildScrollView(
                  child: Html(
            data: poem.content,
            style: {
              "body": Style(
                  fontSize: FontSize(22.0),
                  textAlign: poem.kindid == 1 && poem.content.length < 100
                      ? TextAlign.center
                      : TextAlign.left),
            },
          ))),
          const SizedBox(
            height: 10,
          ),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _infoView()
        ],
      ),
    );
  }

  Widget _infoView() {
    return Flexible(
        flex: 1,
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: List.generate(
                  infoList.length, (index) => Text(infoList[index].title)),
            ),
            Flexible(
              child: TabBarView(
                  controller: _tabController,
                  children: List.generate(infoList.length, (index) {
                    return SingleChildScrollView(
                        child: Html(data: infoList[index].content));
                  })),
            )
          ],
        ));
  }

  void _attachImitate(context) {
    // kindidDropdownButton() {
    //   late List<DropdownMenuItem<int>> list = [];
    //   for (int i = 0; i < kinds.length; i++) {
    //     list.add(DropdownMenuItem(
    //       value: i,
    //       child: Text(
    //         kinds[i],
    //         style: const TextStyle(
    //           fontWeight: FontWeight.bold,
    //           fontSize: 20,
    //         ),
    //       ),
    //     ));
    //   }
    //   if (list.isNotEmpty) {
    //     return Row(children: [
    //       const Text(
    //         "体裁 : ",
    //         style: TextStyle(
    //           fontWeight: FontWeight.bold,
    //           fontSize: 20,
    //         ),
    //       ),
    //       const SizedBox(
    //         width: 10,
    //       ),
    //       DropdownButton<int>(
    //         value: kindid,
    //         items: list,
    //         onChanged: (value) {
    //           setState(() {
    //             kindid = value ?? 0;
    //             GStorage.like.put("kindid", kindid);
    //             GStorage.setting.put("currpid", 0);
    //             _pid = 0;
    //             initData();
    //           });
    //           SmartDialog.dismiss();
    //         },
    //       )
    //     ]);
    //   } else {
    //     return const Text("没有数据");
    //   }
    // }

    // dynastyDropdownButton() {
    //   //获取writerid的
    //   dynastyid = WriterDao.getDyidByWrid(writerid);
    //   late List<DropdownMenuItem<int>> list = [];
    //   for (int i = 0; i < dynastys.length; i++) {
    //     list.add(DropdownMenuItem(
    //       value: i,
    //       child: Text(
    //         dynastys[i],
    //         style: const TextStyle(
    //           fontWeight: FontWeight.bold,
    //           fontSize: 20,
    //         ),
    //       ),
    //     ));
    //   }
    //   if (list.isNotEmpty) {
    //     return Row(children: [
    //       const Text(
    //         "作者 : ",
    //         style: TextStyle(
    //           fontWeight: FontWeight.bold,
    //           fontSize: 20,
    //         ),
    //       ),
    //       const SizedBox(
    //         width: 10,
    //       ),
    //       DropdownButton<int>(
    //         value: kindid,
    //         items: list,
    //         onChanged: (value) {},
    //       )
    //     ]);
    //   } else {
    //     return const Text("没有数据");
    //   }
    // }

    // SmartDialog.show(builder: (_) {
    //   return Container(
    //     width: 600,
    //     height: 400,
    //     alignment: Alignment.center,
    //     margin: EdgeInsets.all(20),
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(20),
    //       color: Colors.white,
    //     ),
    //     child: MaterialApp(
    //       debugShowCheckedModeBanner: false,
    //       home: Container(
    //         padding: EdgeInsets.symmetric(horizontal: 100),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             kindidDropdownButton(),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    // });

    SmartDialog.show(builder: (_) {
      return Container(
          width: 600,
          height: 400,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: MaterialApp(
              home: Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                        onPressed: () {
                          SmartDialog.dismiss();
                        },
                        icon: const Icon(Icons.keyboard_return)),
                    title: Text("修改喜欢"),
                  ),
                  body: LikePage(
                    invokeTap: () {
                      initData();
                    },
                  ))));
    });
  }
}
