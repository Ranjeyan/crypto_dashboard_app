import 'package:crypto_price_dashboard/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/crypto_controller.dart';
import 'core/themes/app_theme.dart';

void main() {
  runApp( MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crypto Dashboard',
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.dashboard,
      getPages: AppRoutes.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(CryptoController());
      }),
    );
  }
}


