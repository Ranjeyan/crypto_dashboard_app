import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/crypto_controller.dart';
import 'widgets/price_chart.dart';
import 'widgets/stat_row.dart';
import 'widgets/trading_view_chart.dart';

class CryptoDetailScreen extends StatelessWidget {
  CryptoDetailScreen({Key? key}) : super(key: key);

  final CryptoController controller = Get.find<CryptoController>();

  void _showTradingViewChart(BuildContext context, String symbol) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TradingViewChart(symbol: symbol),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.selectedCrypto.value?.name ?? 'Details')),
      ),
      body: Obx(() {
        final crypto = controller.selectedCrypto.value;
        if (crypto == null) {
          return const Center(child: Text('No cryptocurrency selected'));
        }

        final isPositive = crypto.priceChangePercentage24h >= 0;
        final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
        final compactFormatter = NumberFormat.compact();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.currency_bitcoin, size: 100),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      crypto.name,
                      style: const TextStyle(
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
                    const SizedBox(height: 16),
                    Text(
                      formatter.format(crypto.currentPrice),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isPositive
                            ? Colors.green.withValues(alpha: 0.2)
                            : Colors.red.withValues(alpha: 0.2),
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
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '7 Day Price Chart',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.isLoading.value && controller.chartData.isEmpty) {
                  return Container(
                    height: 250,
                    child: const Center(child: CircularProgressIndicator(color: Colors.blue)),
                  );
                }

                if (controller.chartData.isEmpty) {
                  return Container(
                    height: 250,
                    child: const Center(child: Text('No chart data available')),
                  );
                }

                return GestureDetector(
                  onTap: () => _showTradingViewChart(context, crypto.symbol),
                  child: Container(
                    height: 250,
                    child: Stack(
                      children: [
                        PriceChart(data: controller.chartData, isPositive: isPositive),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.open_in_full, color: Colors.white, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'Expand',
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 32),
              const Text(
                'Statistics',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
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
