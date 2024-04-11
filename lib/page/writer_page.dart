import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../bean/writer.dart';
import '../dao/writer_dao.dart';
import '../open_gridview.dart';
import '../utils.dart';

class WriterPage extends StatefulWidget {
  const WriterPage({super.key});

  @override
  State<WriterPage> createState() => _WriterPageState();
}

class _WriterPageState extends State<WriterPage> {
  final ValueNotifier<int> _dyid = ValueNotifier(6);
  List<Writer> writerList = [];
  List<int> dyNumList = [];
  bool _isLoading = true;
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollWriter = ScrollController();

  void changeDyid(int dyid) {
    _dyid.value = dyid;
    initData();
    _scrollWriter.animateTo(
      0.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _dyid.dispose();
    super.dispose();
  }

  void initData() async {
    final data = await WriterDao.getWritersByDynastyid(_dyid.value + 1);
    final dyNum = await WriterDao.dynastyAndNum();
    setState(() {
      writerList = data;
      dyNumList = dyNum;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.orange),
        home: ValueListenableBuilder(
          valueListenable: _dyid,
          builder: (BuildContext context, value, Widget? child) {
            return Scaffold(
                body: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          _dynumList(),
                          Expanded(child: _writerList())
                        ],
                      ));
          },
        ));
  }

  Widget _dynumList() {
    return SizedBox(
        height: 40,
        child: Scrollbar(
            controller: _scrollController,
            interactive: true,
            child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: dyNumList.length,
                padding: const EdgeInsets.only(bottom: 10),
                itemBuilder: (context, index) {
                  return Container(
                      decoration: BoxDecoration(
                          color: _dyid.value == index
                              ? Colors.amber
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10.0)),
                      margin: const EdgeInsets.only(left: 10),
                      child: Row(children: [
                        TextButton(
                            onPressed: () {
                              changeDyid(index);
                            },
                            child: Text(
                              "${dynastys[index + 1]} ",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.red),
                            )),
                        Text("(${dyNumList[index]}) "),
                      ]));
                })));
  }

  Widget _writerList() {
    return SingleChildScrollView(
      controller: _scrollWriter,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          OptionGridView(
            itemCount: writerList.length,
            rowCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemBuilder: (context, index) {
              Writer wr = writerList[index];
              return Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                color: Colors.red.withOpacity(0.2),
                child: Column(
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          "${wr.writername} · ${dynastys[wr.dynastyid]} ",
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    Html(data: wr.summary),
                    // Text("    ${}"),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
