import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/crypto_data.dart';
import '../models/chart_data.dart';
import '../../core/constants/api_constants.dart';

class CryptoApiProvider {
  Future<List<CryptoData>> fetchCryptoList() async {
    final response = await http.get(Uri.parse(ApiConstants.getMarketsUrl()));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CryptoData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load crypto data');
    }
  }

  Future<List<ChartData>> fetchChartData(String coinId) async {
    final response = await http.get(Uri.parse(ApiConstants.getChartUrl(coinId)));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> prices = data['prices'];
      return prices
          .map((item) => ChartData(
        DateTime.fromMillisecondsSinceEpoch(item[0]),
        item[1].toDouble(),
      ))
          .toList();
    } else {
      throw Exception('Failed to load chart data');
    }
  }
}