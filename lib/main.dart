import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gsc/dao/writer_dao.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'bean/writer.dart';
import 'open_gridview.dart';
import 'sql_helper.dart';
import 'utils.dart';

enum InitFlag { wait, ok, error }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const InitPage());
}

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  late StackTrace _stackTrace;
  dynamic _error;

  InitFlag initFlag = InitFlag.wait;

  @override
  void initState() {
    super.initState();

    () async {
      try {
        await SQLHelper.initialDatabase();
        initFlag = InitFlag.ok;
      } catch (e, st) {
        _error = e;
        _stackTrace = st;
        initFlag = InitFlag.error;
      }
      setState(() {});
    }();
  }

  @override
  Widget build(BuildContext context) {
    switch (initFlag) {
      case InitFlag.ok:
        return const MyApp();
      case InitFlag.error:
        return MaterialApp(
          darkTheme: ThemeData.dark(),
          home: ErrorApp(error: _error, stackTrace: _stackTrace),
        );
      default:
        return const MaterialApp(
          home: FirstPage(),
        );
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Writer> writerList = [];
  List<int> dyNumList = [];
  bool _isLoading = true;
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void initData() async {
    // final data = await WriterDao.fetchWriters();
    int currDyid = 6;
    final data = await WriterDao.getWritersByDynastyid(5);
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
        home: Scaffold(
            appBar: AppBar(
              title: const Text('古诗词'),
              backgroundColor: Colors.amber,
              // actions: [_dynumList()],
            ),
            body: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _writerList()));
  }

  Widget _dynumList() {
    return Container(
        height: 40,
        child: Scrollbar(
            controller: _scrollController,
            interactive: true,
            child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: dyNumList.length,
                padding: EdgeInsets.only(bottom: 10),
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Row(children: [
                        Text(
                          "${dynastys[index + 1]} ",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.red),
                        ),
                        Text("(${dyNumList[index]} )"),
                      ]));
                })));
  }

  Widget _writerList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          _dynumList(),
          SizedBox(
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
                    Text(
                      "${wr.writername} · ${dynastys[wr.dynastyid]} ",
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text("    ${wr.summary}"),
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

class ErrorApp extends StatelessWidget {
  final error;
  final stackTrace;
  const ErrorApp({this.error, this.stackTrace});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            Text(
              "$error\n$stackTrace",
              style: TextStyle(color: Color(0xFFF56C6C)),
            )
          ],
        ),
      ),
    );
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: const [
            Text(
              "加载中",
              style: TextStyle(color: Color(0xFFF56C6C)),
            )
          ],
        ),
      ),
    );
    ;
  }
}
