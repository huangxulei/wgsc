import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    dynamic color;
    dynamic defaultThemeColor = 'default';
    if (defaultThemeColor == 'default') {
      color = null;
    } else {
      color = Color(int.parse(defaultThemeColor, radix: 16));
    }
    var app = AdaptiveTheme(
      light: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorSchemeSeed: color),
      dark: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: color),
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp.router(
        title: "古诗词",
        theme: theme,
        darkTheme: darkTheme,
        routerConfig: Modular.routerConfig,
        builder: FlutterSmartDialog.init(),
        // navigatorObservers: [Asuka.asukaHeroController],
      ),
    );
    Modular.setObservers([FlutterSmartDialog.observer]);
    return app;
  }
}
