import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gsc/common/store.dart';
import 'package:hive/hive.dart';
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
  Box Setting = GStorage.setting;
  late int currpid = Setting.get("currpid", defaultValue: 0);
  final ValueNotifier<int> _pid = ValueNotifier(0);
  late Poem poem;
  bool _isLoading = true;
  List<Info> infoList = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _pid.value = currpid;
    initData();
  }

  void initData() async {
    allPoem = await PoetryDao.getAllPoem();
    Poem p = allPoem[_pid.value];
    infoList = await PoetryDao.findInfoByPid(p.poetryid);
    _tabController = TabController(
      length: infoList.length,
      vsync: this,
    );
    setState(() {
      poem = p;
      _isLoading = false;
    });
    await Setting.put("currpid", _pid.value);
  }

  void changePid(int pid) {
    if (pid == allPoem.length) {
      _pid.value = 1;
    } else if (pid == -1) {
      _pid.value = allPoem.length - 1;
    } else {
      _pid.value = pid;
    }
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
                      changePid(_pid.value + 1);
                    },
                    child: const Icon(Icons.arrow_right),
                  )),
            ],
          ));
        });
  }

  Widget _poetryView() {
    return SelectionArea(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "${poem.title} (${_pid.value + 1} / ${allPoem.length})",
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
}
