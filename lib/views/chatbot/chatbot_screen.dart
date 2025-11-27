import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/chatbot_controller.dart';
import '../../core/utils/responsive.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final ChatbotController controller = Get.find<ChatbotController>();
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = textController.text.trim();
    if (text.isNotEmpty) {
      controller.sendMessage(text);
      textController.clear();

      Future.delayed(const Duration(milliseconds: 100), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: Responsive.fontSize(context, 24),
          ),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            Container(
              width: Responsive.responsiveValue(
                context,
                mobile: 40.0,
                tablet: 45.0,
                desktop: 50.0,
              ),
              height: Responsive.responsiveValue(
                context,
                mobile: 40.0,
                tablet: 45.0,
                desktop: 50.0,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(
                  Responsive.responsiveValue(
                    context,
                    mobile: 20.0,
                    tablet: 22.5,
                    desktop: 25.0,
                  ),
                ),
              ),
              child: Icon(
                Icons.smart_toy,
                color: Colors.blue,
                size: Responsive.fontSize(context, 20),
              ),
            ),
            SizedBox(width: Responsive.spacing(context, 12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Crypto AI Assistant',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 16),
                    ),
                  ),
                  Text(
                    'Always here to help',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 12),
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              size: Responsive.fontSize(context, 24),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: Responsive.fontSize(context, 20),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Clear Chat',
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 14),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Future.delayed(
                    Duration.zero,
                        () => controller.clearChat(),
                  );
                },
              ),
            ],
          ),
          SizedBox(width: Responsive.spacing(context, 8)),
        ],
      ),
      body: ResponsiveBuilder(
        mobile: _buildChatLayout(context),
        tablet: _buildChatLayout(context),
        desktop: _buildDesktopChatLayout(context),
      ),
    );
  }

  Widget _buildChatLayout(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _buildMessagesList(context)),
        _buildInputArea(context),
      ],
    );
  }

  Widget _buildDesktopChatLayout(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: Responsive.maxContentWidth(context),
        ),
        child: Column(
          children: [
            Expanded(child: _buildMessagesList(context)),
            _buildInputArea(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesList(BuildContext context) {
    return Obx(() {
      if (controller.messages.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: Responsive.responsiveValue(
                  context,
                  mobile: 80.0,
                  tablet: 100.0,
                  desktop: 120.0,
                ),
                color: Colors.grey[600],
              ),
              SizedBox(height: Responsive.spacing(context, 16)),
              Text(
                'Start a conversation!',
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 18),
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        controller: scrollController,
        reverse: true,
        padding: Responsive.padding(context),
        itemCount: controller.messages.length +
            (controller.isTyping.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == 0 && controller.isTyping.value) {
            return _buildTypingIndicator(context);
          }

          final messageIndex = controller.isTyping.value ? index - 1 : index;
          final message = controller.messages[messageIndex];
          return _buildMessage(context, message);
        },
      );
    });
  }

  Widget _buildMessage(BuildContext context, message) {
    final isUser = message.isUser;
    final timeFormat = DateFormat('HH:mm');

    return Padding(
      padding: EdgeInsets.only(
        bottom: Responsive.spacing(context, 16),
      ),
      child: Row(
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: Responsive.responsiveValue(
                context,
                mobile: 36.0,
                tablet: 40.0,
                desktop: 44.0,
              ),
              height: Responsive.responsiveValue(
                context,
                mobile: 36.0,
                tablet: 40.0,
                desktop: 44.0,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(
                  Responsive.responsiveValue(
                    context,
                    mobile: 18.0,
                    tablet: 20.0,
                    desktop: 22.0,
                  ),
                ),
              ),
              child: Icon(
                Icons.smart_toy,
                color: Colors.blue,
                size: Responsive.fontSize(context, 20),
              ),
            ),
            SizedBox(width: Responsive.spacing(context, 8)),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: Responsive.responsiveValue(
                      context,
                      mobile: Responsive.width(context) * 0.75,
                      tablet: Responsive.width(context) * 0.6,
                      desktop: 600.0,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.spacing(context, 16),
                    vertical: Responsive.spacing(context, 12),
                  ),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blue : const Color(0xFF16213e),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.fontSize(context, 15),
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  timeFormat.format(message.timestamp),
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 11),
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            SizedBox(width: Responsive.spacing(context, 8)),
            Container(
              width: Responsive.responsiveValue(
                context,
                mobile: 36.0,
                tablet: 40.0,
                desktop: 44.0,
              ),
              height: Responsive.responsiveValue(
                context,
                mobile: 36.0,
                tablet: 40.0,
                desktop: 44.0,
              ),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(
                  Responsive.responsiveValue(
                    context,
                    mobile: 18.0,
                    tablet: 20.0,
                    desktop: 22.0,
                  ),
                ),
              ),
              child: Icon(
                Icons.person,
                color: Colors.green,
                size: Responsive.fontSize(context, 20),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: Responsive.spacing(context, 16),
      ),
      child: Row(
        children: [
          Container(
            width: Responsive.responsiveValue(
              context,
              mobile: 36.0,
              tablet: 40.0,
              desktop: 44.0,
            ),
            height: Responsive.responsiveValue(
              context,
              mobile: 36.0,
              tablet: 40.0,
              desktop: 44.0,
            ),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(
                Responsive.responsiveValue(
                  context,
                  mobile: 18.0,
                  tablet: 20.0,
                  desktop: 22.0,
                ),
              ),
            ),
            child: Icon(
              Icons.smart_toy,
              color: Colors.blue,
              size: Responsive.fontSize(context, 20),
            ),
          ),
          SizedBox(width: Responsive.spacing(context, 8)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.spacing(context, 16),
              vertical: Responsive.spacing(context, 12),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF16213e),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                SizedBox(width: 4),
                _buildDot(1),
                SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Opacity(
          opacity: (value + index * 0.3) % 1.0,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
      onEnd: () {
        if (mounted) setState(() {});
      },
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: Responsive.padding(context),
      decoration: BoxDecoration(
        color: const Color(0xFF16213e),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'Ask about crypto...',
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: Responsive.fontSize(context, 14),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1a1a2e),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Responsive.spacing(context, 20),
                    vertical: Responsive.spacing(context, 12),
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Responsive.fontSize(context, 15),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            SizedBox(width: Responsive.spacing(context, 8)),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(24),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: Responsive.fontSize(context, 20),
                ),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}