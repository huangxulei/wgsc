import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gsc/app_module.dart';
import 'package:gsc/app_widget.dart';
import 'package:gsc/page/writer_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';
import 'sql_helper.dart';

enum InitFlag { wait, ok, error }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1000, 800),
      center: true,
      // backgroundColor: Colors.white,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    windowManager.setMaximizable(false);
    windowManager.setResizable(false);
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
        return ModularApp(
          module: AppModule(),
          child: const AppWidget(),
        );
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
