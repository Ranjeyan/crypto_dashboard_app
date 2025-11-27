import 'package:crypto_price_dashboard/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../controllers/crypto_controller.dart';
import 'widgets/crypto_card.dart';

class DashboardScreen extends StatelessWidget {
  final CryptoController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => controller.fetchCryptoData(),
          ),
        ],
      ),
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value && controller.cryptoList.isEmpty) {
              return Center(child: CircularProgressIndicator(color: Colors.blue));
            }

            return RefreshIndicator(
              onRefresh: controller.fetchCryptoData,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: controller.cryptoList.length,
                itemBuilder: (context, index) {
                  final crypto = controller.cryptoList[index];
                  return CryptoCard(crypto: crypto);
                },
              ),
            );
          }),

          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.chatbot),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.4),
                      blurRadius: 15,
                      spreadRadius: 0,
                      offset: Offset(0, 0),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Lottie.asset(
                  'assets/lottie/Chat.json',
                  width: 100,
                  height: 100,
                  repeat: true,
                  animate: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}