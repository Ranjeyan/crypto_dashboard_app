class CryptoData {
  final String id;
  final String name;
  final String symbol;
  final double currentPrice;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final String image;
  final double high24h;
  final double low24h;
  final double marketCap;

  CryptoData({
    required this.id,
    required this.name,
    required this.symbol,
    required this.currentPrice,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.image,
    required this.high24h,
    required this.low24h,
    required this.marketCap,
  });

  factory CryptoData.fromJson(Map<String, dynamic> json) {
    return CryptoData(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'].toString().toUpperCase(),
      currentPrice: json['current_price'].toDouble(),
      priceChange24h: json['price_change_24h']?.toDouble() ?? 0.0,
      priceChangePercentage24h: json['price_change_percentage_24h']?.toDouble() ?? 0.0,
      image: json['image'],
      high24h: json['high_24h']?.toDouble() ?? 0.0,
      low24h: json['low_24h']?.toDouble() ?? 0.0,
      marketCap: json['market_cap']?.toDouble() ?? 0.0,
    );
  }
}