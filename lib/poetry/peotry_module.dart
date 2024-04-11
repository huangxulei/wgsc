import 'package:flutter_modular/flutter_modular.dart';

import 'poetry_page.dart';

class PoetryModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const PoetryPage());
  }
}
