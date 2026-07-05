import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/controller/theme_controller.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';


class EpicNzApp extends StatelessWidget {
  final String initialRoute;
  const EpicNzApp({super.key, required this.initialRoute});



  @override
  Widget build(BuildContext context) {

    final themeController = Get.find<ThemeController>();

    return Obx(
          () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Epic Nz',

        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode.value,


        locale: const Locale('en', 'NZ'),
        fallbackLocale: const Locale('en', 'NZ'),

        initialRoute: initialRoute,
        getPages: AppPages.pages,
      ),
    );
  }
}