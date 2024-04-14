import 'package:flutter/material.dart';
import 'package:gsc/common/store.dart';
import 'package:gsc/dao/writer_dao.dart';

import '../bean/writer.dart';
import '../utils.dart';

class LikePage extends StatefulWidget {
  final void Function() invokeTap;

  const LikePage({super.key, required this.invokeTap});

  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  late List<int> likes;
  late int kindid;
  late int dynastyid;
  late int writerid;
  late List<Writer> writers;
  late List<DropdownMenuItem<int>> dlist = [];
  late List<DropdownMenuItem<int>> wlist = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    likes = GStorage.getLikes(); //获取喜欢信息
    writerid = likes[0];
    kindid = likes[1];
    //数据库获取writeid => dyid
    dynastyid = writerid != 0 ? await WriterDao.getDyidByWrid(writerid) : 0;
    writers = await WriterDao.getWritersByDynastyid(dynastyid);
    initDlist();
    initWlist(dynastyid);
    setState(() {});
  }

  void initWlist(int dynastyid) async {
    print(dynastyid);
    if (dynastyid != 0) {
      writers = await WriterDao.getWritersByDynastyid(dynastyid);
    }
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
  }

  void initDlist() {
    //再获取下面的writer
    print(writers[0].writername);
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
          children: [kindidDropdownButton(), writerDropdownButton()],
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
          onChanged: (value) {
            kindid = value ?? 0;
            GStorage.like.put("kindid", kindid);
            GStorage.setting.put("currpid", 0);
            widget.invokeTap();
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
          initWlist(dynastyid);
          setState(() {});
        },
      ),
      const SizedBox(
        width: 10,
      ),
      DropdownButton<int>(
        value: writerid,
        items: wlist,
        onChanged: (value) {
          //value
          print(writers[value ?? 0].writerid);
          writerid = value ?? 0;
          // dynastyid = value ?? 0;
          GStorage.like.put("writerid", writerid);
          setState(() {});
        },
      )
    ]);
  }
}
