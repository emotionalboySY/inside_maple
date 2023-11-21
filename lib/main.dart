import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:inside_maple/routes.dart';
import 'package:inside_maple/utils/logger.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:window_size/window_size.dart';

import 'constants.dart';
import 'data.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  if(Platform.isWindows) {
    setWindowTitle("Inside Maple");
    setWindowMinSize(const Size(1280, 720));
  }

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 720),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );

  windowManager.waitUntilReadyToShow(
    windowOptions,
      () async {
      await windowManager.show();
      await windowManager.focus();
      }
  );

  var documentPath = await getApplicationDocumentsDirectory();

  String documentPathStr = documentPath.path;

  Hive.init("$documentPathStr/InsideMaple");
  Hive.registerAdapter(BossRecordAdapter());
  Hive.registerAdapter(BossAdapter());
  Hive.registerAdapter(SelectedItemAdapter());
  Hive.registerAdapter(DifficultyAdapter());
  Hive.registerAdapter(ItemAdapter());

  await Hive.openBox("insideMaple");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WindowListener {

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    windowManager.setPreventClose(true);
    _restoreWindowSize();
  }

  Future<void> _restoreWindowSize() async {
    final box = Hive.box("insideMaple");
    final savedSize = await box.get("savedWindowSize", defaultValue: const Size(1280.0, 720.0));
    await windowManager.setSize(savedSize);
  }


  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if(isPreventClose) {
      loggerNoStack.d("onWindowClose");
      final box = Hive.box("insideMaple");
      final size = await windowManager.getSize();
      box.put("savedSize", size);
      loggerNoStack.d("size Saved");

      windowManager.destroy();
    }
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      radius: 5.0,
      position: ToastPosition.bottom,
      child: GetMaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ko', 'KR'),
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: "Pretendard",
        ),
        initialRoute: "/main",
        getPages: routes,
      ),
    );
  }
}