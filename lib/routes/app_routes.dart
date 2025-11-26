import 'package:get/get.dart';
import '../views/dashboard/dashboard_screen.dart';
import '../views/detail/crypto_detail_screen.dart';

class AppRoutes {
  static const String dashboard = '/';
  static const String detail = '/details';

  static final  routes = [
    GetPage(
        name: dashboard,
        page: () => DashboardScreen()
    ),
    GetPage(
        name: detail,
        page: () => CryptoDetailScreen()
    )
  ];
}