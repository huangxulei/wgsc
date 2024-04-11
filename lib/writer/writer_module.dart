import 'package:flutter_modular/flutter_modular.dart';

import 'writer_page.dart';

class WriterModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const WriterPage());
  }
}
