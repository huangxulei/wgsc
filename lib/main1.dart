// 在应用程序的入口处调用复制数据库方法，并执行其他操作
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gsc/dao/writer_dao.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'bean/writer.dart';
import 'sql_helper.dart';

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
  bool _isLoading = true;

  void initData() async {
    // final data = await WriterDao.fetchWriters();
    final data = await WriterDao.getWritersByDynastyid(5);
    setState(() {
      writerList = data;
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
            ),
            body: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 0.5,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                    itemCount: writerList.length,
                    // 遍历
                    itemBuilder: (context, index) {
                      Writer wr = writerList[index];
                      openWriter() {
                        print("打开");
                      }

                      return InkWell(onTap: openWriter, child: writer_item(wr));
                    })));
  }
}

Widget writer_item(Writer w) {
  return Flex(direction: Axis.vertical, children: <Widget>[
    Container(
      alignment: Alignment.center,
      child: Text(
        '${w.writerid} - ${w.writername}'.trim(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    SizedBox(height: 6),
    Expanded(
        child: Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      width: double.maxFinite,
      child: Text(
        '${w.summary}'.trim(),
      ),
    ))
  ]);
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
