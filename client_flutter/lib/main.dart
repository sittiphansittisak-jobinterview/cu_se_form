import 'package:client_flutter/page/application_form_page.dart';
import 'package:client_flutter/page/index_page.dart';
import 'package:client_flutter/page/initial_page.dart';
import 'package:client_flutter/path/page_path.dart';
import 'package:client_flutter/private/setting/scroll_setting.dart';
import 'package:client_flutter/private/style/color_style.dart';
import 'package:client_flutter/private/style/font_family_style.dart';
import 'package:client_flutter/private/style/font_size_style.dart';
import 'package:client_flutter/private/widget/loading/cover_loading_widget.dart';
import 'package:client_flutter/private/setting/app_initial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:share_flutter/utility/delay_function.dart';

void main() async {
  initialBeforeStartApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Rx<bool> _isInitialSuccess = Rx(false);

  GetPage<dynamic> _getPageHelper(String page) => GetPage(name: page, page: () => _pageBuilder(page));

  Widget _pageBuilder(String page) => Obx(() {
        if (!_isInitialSuccess.value) return const InitialPage();
        switch (page) {
          case PagePath.applicationForm:
            return const ApplicationFormPage();
          default:
            return const IndexPage();
        }
      });

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await CoverLoadingWidget.show(text: 'กำลังเตรียมความพร้อมของแอป....');
      if (!await delayedFunction<bool>(function: initialBeforeAfterApp)) return await CoverLoadingWidget.showError(text: 'เตรียมความพร้อมของแอปไม่สำเร็จ กรุณาลองใหม่อีกครั้ง');
      _isInitialSuccess.value = true;
      await CoverLoadingWidget.close();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: ScrollSetting(),
      title: 'CU SE form',
      theme: ThemeData(fontFamily: FontFamilyStyle.myFont, scaffoldBackgroundColor: ColorStyle.light, snackBarTheme: const SnackBarThemeData(backgroundColor: ColorStyle.primary, contentTextStyle: TextStyle(fontFamily: FontFamilyStyle.myFont, color: ColorStyle.light, fontSize: FontSizeStyle.basic)), appBarTheme: const AppBarTheme(backgroundColor: ColorStyle.primary, iconTheme: IconThemeData(color: ColorStyle.secondary, size: FontSizeStyle.big), titleTextStyle: TextStyle(color: ColorStyle.light, fontSize: FontSizeStyle.big, fontFamily: FontFamilyStyle.myFont))),
      supportedLocales: const [Locale('en', 'US'), Locale('th', 'TH')],
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
      builder: EasyLoading.init(),
      defaultTransition: Transition.noTransition,
      initialRoute: PagePath.index,
      unknownRoute: _getPageHelper(PagePath.index),
      getPages: [
        _getPageHelper(PagePath.index),
        _getPageHelper(PagePath.applicationForm),
      ],
    );
  }
}
