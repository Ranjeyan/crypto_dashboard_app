import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      body: Obx(() {
        if (controller.isLoading.value && controller.cryptoList.isEmpty) {
          return Center(child: CircularProgressIndicator());
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
    );
  }
}