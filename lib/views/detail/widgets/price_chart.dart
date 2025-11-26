import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../data/models/chart_data.dart';

class PriceChart extends StatefulWidget {
  final String symbol;

  PriceChart({required this.symbol});

  @override
  State<PriceChart> createState() => _PriceChartState();
}

class _PriceChartState extends State<PriceChart> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    // TradingView HTML content
    final String tradingViewHtml = '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <style>
          * { margin: 0; padding: 0; box-sizing: border-box; }
          html, body { 
            height: 100%; 
            width: 100%; 
            overflow: hidden;
            background-color: #16213e; 
          }
          #tradingview_widget { 
            height: 100vh !important; 
            width: 100vw !important; 
          }
          .tradingview-widget-container {
            height: 100% !important;
            width: 100% !important;
          }
        </style>
      </head>
      <body>
        <div class="tradingview-widget-container">
          <div id="tradingview_widget"></div>
        </div>
        
        <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
        <script type="text/javascript">
          new TradingView.widget({
            "width": "100%",
            "height": "100%",
            "autosize": true,
            "symbol": "${widget.symbol.toUpperCase()}USD",
            "interval": "D",
            "timezone": "Etc/UTC",
            "theme": "dark",
            "style": "1",
            "locale": "en",
            "toolbar_bg": "#16213e",
            "enable_publishing": false,
            "hide_top_toolbar": false,
            "hide_legend": false,
            "save_image": false,
            "container_id": "tradingview_widget"
          });
        </script>
      </body>
      </html>
    ''';

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF16213e))
      ..loadHtmlString(tradingViewHtml);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF16213e),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.hardEdge,
      child: WebViewWidget(controller: controller),
    );
  }
}