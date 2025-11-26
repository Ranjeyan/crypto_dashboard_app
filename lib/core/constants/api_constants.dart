class ApiConstants {
  static const String baseUrl = 'https://api.coingecko.com/api/v3';
  static const String marketsEndpoint = '/coins/markets';
  static const String chartEndpoint = '/coins/{id}/market_chart';

  static String getMarketsUrl() {
    return '$baseUrl$marketsEndpoint?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=false';
  }

  static String getChartUrl(String coinId) {
    return '$baseUrl${chartEndpoint.replaceAll('{id}', coinId)}?vs_currency=usd&days=7';
  }
}