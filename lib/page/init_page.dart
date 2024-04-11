import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    Modular.to.navigate('/tab/poetry/');
  }

  @override
  Widget build(BuildContext context) {
    return const RouterOutlet();
  }
}
