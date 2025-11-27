import 'package:get/get.dart';
import '../views/chatbot/chatbot_screen.dart';
import '../views/dashboard/dashboard_screen.dart';
import '../views/detail/crypto_detail_screen.dart';

class AppRoutes {
  static const String dashboard = '/';
  static const String detail = '/details';
  static const String chatbot = '/chatbot';

  static final  routes = [
    GetPage(
        name: dashboard,
        page: () => DashboardScreen()
    ),
    GetPage(
        name: detail,
        page: () => CryptoDetailScreen()
    ),
    GetPage(name: chatbot, page: () => ChatbotScreen()),
  ];
}