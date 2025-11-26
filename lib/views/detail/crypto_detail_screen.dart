import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/crypto_controller.dart';
import 'widgets/price_chart.dart';
import 'widgets/stat_row.dart';

class CryptoDetailScreen extends StatelessWidget {
  final CryptoController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.selectedCrypto.value?.name ?? 'Details')),
      ),
      body: Obx(() {
        final crypto = controller.selectedCrypto.value;
        if (crypto == null) {
          return Center(child: Text('No cryptocurrency selected'));
        }

        final isPositive = crypto.priceChangePercentage24h >= 0;
        final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
        final compactFormatter = NumberFormat.compact();

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        crypto.image,
                        width: 100,
                        height: 100,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      crypto.name,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      crypto.symbol,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[400],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      formatter.format(crypto.currentPrice),
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isPositive
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${isPositive ? '+' : ''}${crypto.priceChangePercentage24h.toStringAsFixed(2)}% (${formatter.format(crypto.priceChange24h)})',
                        style: TextStyle(
                          fontSize: 16,
                          color: isPositive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'TradingView Chart',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              // TradingView Chart
              PriceChart(symbol: crypto.symbol),
              SizedBox(height: 32),
              Text(
                'Statistics',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              StatRow(label: '24h High', value: formatter.format(crypto.high24h)),
              StatRow(label: '24h Low', value: formatter.format(crypto.low24h)),
              StatRow(
                label: 'Market Cap',
                value: '\$${compactFormatter.format(crypto.marketCap)}',
              ),
            ],
          ),
        );
      }),
    );
  }
}