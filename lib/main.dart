import 'dart:math';

import 'package:flutter/material.dart';

import 'open_gridview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(home: InitPage()));
}

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  List<String> options = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OptionGridView')),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: double.maxFinite,
        height: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            children: [
              OptionGridView(
                itemCount: options.length,
                rowCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    color: Colors.red.withOpacity(0.2),
                    child: Column(
                      children: [
                        Text(options[index]),
                        SizedBox(height: Random().nextBool() ? 30 : 10),
                        if (Random().nextBool())
                          const Icon(Icons.add_circle, size: 20),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
