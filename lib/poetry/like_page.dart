import 'package:flutter/material.dart';
import 'package:gsc/common/store.dart';
import 'package:gsc/dao/poetry_dao.dart';
import 'package:gsc/dao/writer_dao.dart';

import '../bean/poem.dart';
import '../bean/writer.dart';
import '../utils.dart';

class LikePage extends StatefulWidget {
  final VoidCallback onRefresh;
  final void Function(String) onShowInfo;

  const LikePage(
      {super.key, required this.onRefresh, required this.onShowInfo});

  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  late List<int> likes;
  late int kindid = 0;
  late int dynastyid = 0;
  late int writerid = 0;
  late int currwid = 0;
  late List<Writer> writers;
  late List<DropdownMenuItem<int>> dlist = [];
  late List<DropdownMenuItem<int>> wlist = [];

  @override
  void initState() {
    super.initState();
    initData(true);
  }

  Future<void> initData(bool first) async {
    likes = GStorage.getLikes(); //获取喜欢信息
    writerid = likes[0];
    kindid = likes[1];

    if (writerid != 0) {
      dynastyid = await WriterDao.getDyidByWrid(writerid);
      writers = await WriterDao.getWritersByDynastyid(dynastyid);
      //根据writerid 返回这个writer 再writers 中的位置
      currwid = writers.indexWhere((writer) => writer.writerid == writerid);
    } else {
      currwid = 0;
      dynastyid = 0;
      writers = [];
    }

    initDlist();
    initWlist(first);
    setState(() {});
  }

  void initDlist() {
    //再获取下面的writer
    for (int i = 0; i < dynastys.length; i++) {
      dlist.add(DropdownMenuItem(
        value: i,
        child: Text(
          dynastys[i],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ));
    }
  }

  void initWlist(bool first) async {
    if (dynastyid != 0) {
      writers = await WriterDao.getWritersByDynastyid(dynastyid);
      wlist.clear();
      for (int i = 0; i < writers.length; i++) {
        wlist.add(DropdownMenuItem(
          value: i,
          child: Text(
            writers[i].writername,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ));
      }
      if (!first) writerid = writers[0].writerid;
    } else {
      wlist.clear();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 600,
        height: 400,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          children: [
            kindidDropdownButton(),
            writerDropdownButton(),
            SizedBox(
              height: 10,
            ),
            Center(
              child: RawMaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ), //圆角
                fillColor: Colors.blue[400], //背景颜色
                elevation: 5, //阴影高度
                padding: EdgeInsets.all(5), //内边距
                child: const Text(
                  "修 改",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () async {
                  if (dynastyid == 0) {
                    writerid = 0;
                  }
                  if (await isSave()) {
                    GStorage.like.put("writerid", writerid);
                    GStorage.like.put("kindid", kindid);
                    GStorage.setting.put("currpid", 0);
                    widget.onRefresh();
                  } else {
                    widget.onShowInfo("角度太过于刁钻,没有需要的结果!");
                  }
                },
              ),
            )
          ],
        ));
  }

  Widget kindidDropdownButton() {
    late List<DropdownMenuItem<int>> list = [];
    for (int i = 0; i < kinds.length; i++) {
      list.add(DropdownMenuItem(
        value: i,
        child: Text(
          kinds[i],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ));
    }
    if (list.isNotEmpty) {
      return Row(children: [
        const Text(
          "体裁 : ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        DropdownButton<int>(
          value: kindid,
          items: list,
          onChanged: (value) async {
            kindid = value ?? 0;
            setState(() {});
          },
        )
      ]);
    } else {
      return const Text("没有数据");
    }
  }

  Widget writerDropdownButton() {
    return Row(children: [
      const Text(
        "作者 : ",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      DropdownButton<int>(
        value: dynastyid,
        items: dlist,
        onChanged: (value) {
          dynastyid = value ?? 0;
          currwid = 0;
          initWlist(false);
          setState(() {});
        },
      ),
      const SizedBox(
        width: 10,
      ),
      DropdownButton<int>(
        hint: Text("请选择"),
        value: currwid,
        items: wlist,
        onChanged: (value) async {
          currwid = value ?? 0;
          print(writers[currwid].writername);
          writerid = writers[currwid].writerid;
          setState(() {});
        },
      )
    ]);
  }

  Future<bool> isSave() async {
    final List<int> tempLikes = [writerid, kindid];
    bool flag = true;
    final List<Poem> pList = await PoetryDao.getLike(tempLikes);
    flag = pList.isEmpty ? false : true;
    return flag;
  }
}
