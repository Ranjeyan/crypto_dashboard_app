import 'package:get/get.dart';
import '../data/models/chat_message.dart';
import '../services/gemini_services.dart';
import 'crypto_controller.dart';

class ChatbotController extends GetxController {
  final RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;
  final RxBool isTyping = false.obs;
  final CryptoController cryptoController = Get.find<CryptoController>();
  late final GeminiService _geminiService;

  @override
  void onInit() {
    super.onInit();
    _geminiService = GeminiService();
    _addBotMessage('Hello! 👋 I\'m your crypto assistant powered by Gemini AI. Ask me about crypto prices, trends, or any crypto-related questions!');
  }

  @override
  void onClose() {
    _geminiService.dispose();
    super.onClose();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _addUserMessage(text);

    isTyping.value = true;

    try {
      String cryptoContext = _generateCryptoContext();

      final response = await _geminiService.sendMessage(
        text,
        cryptoContext: cryptoContext,
      );

      _addBotMessage(response);
    } catch (e) {
      print('Error sending message: $e');
      _addBotMessage('Sorry, I encountered an error. Please try again.');
    } finally {
      isTyping.value = false;
    }
  }

  String _generateCryptoContext() {
    if (cryptoController.cryptoList.isEmpty) {
      return 'No market data currently available.';
    }

    final cryptos = cryptoController.cryptoList.take(10).toList();
    StringBuffer context = StringBuffer();
    context.writeln('Top Cryptocurrencies:');

    for (int i = 0; i < cryptos.length; i++) {
      final crypto = cryptos[i];
      context.writeln(
          '${i + 1}. ${crypto.name} (${crypto.symbol}): \$${crypto.currentPrice.toStringAsFixed(2)} '
              '(${crypto.priceChangePercentage24h >= 0 ? '+' : ''}${crypto.priceChangePercentage24h.toStringAsFixed(2)}%)'
      );
    }

    return context.toString();
  }

  void _addUserMessage(String text) {
    messages.insert(
      0,
      ChatMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _addBotMessage(String text) {
    messages.insert(
      0,
      ChatMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void clearChat() {
    messages.clear();
    _geminiService.resetChat();
    _addBotMessage('Chat cleared! How can I help you?');
  }
}