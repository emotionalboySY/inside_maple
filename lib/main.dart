import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:inside_maple/routes.dart';
import 'package:inside_maple/utils/logger.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:window_size/window_size.dart';

import 'constants.dart';
import 'controllers/main_controller.dart';
import 'data.dart';

void main() async {

  var documentPath = await getApplicationDocumentsDirectory();

  String documentPathStr = documentPath.path;

  Hive.init("$documentPathStr/Inside Maple");

  Get.put(MainController());

  final box = await Hive.openBox("insideMaple");
  final savedSize = await box.get("savedWindowSize", defaultValue: {"width": 1280.0, "height": 720.0});
  await windowManager.setSize(Size(savedSize["width"], savedSize["height"]));
  box.close();

  loggerNoStack.d("savedSize: $savedSize");

  WidgetsFlutterBinding.ensureInitialized();

  if(Platform.isWindows) {
    await windowManager.ensureInitialized();
    setWindowTitle("Inside Maple");
    setWindowMinSize(const Size(1280, 720));

    WindowOptions windowOptions = WindowOptions(
      size: Size(savedSize["width"], savedSize["height"]),
      minimumSize: const Size(1280, 720),
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
  }

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
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if(isPreventClose) {
      loggerNoStack.d("onWindowClose");
      final box = await Hive.openBox("insideMaple");
      final size = await windowManager.getSize();
      Map sizeMap = {
        "height": size.height,
        "width": size.width,
      };
      loggerNoStack.d("last size: $sizeMap");
      await box.put("savedWindowSize", sizeMap);
      loggerNoStack.d("size Saved");
      await box.close();
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
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ko', 'KR'),
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: "Pretendard",
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              minimumSize: MaterialStateProperty.all(Size.zero),
            ),
          ),
        ),
        initialRoute: "/main",
        getPages: routes,
      ),
    );
  }
}