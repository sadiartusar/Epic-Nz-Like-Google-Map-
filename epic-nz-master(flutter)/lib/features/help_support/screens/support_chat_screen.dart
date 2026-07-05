import 'package:epic_nz/core/theme/app_colors.dart';
import 'package:epic_nz/features/help_support/contact_controller/support_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/app_back_button.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_input_bar.dart';

class SupportChatScreen extends StatelessWidget {
  const SupportChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SupportChatController());

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const AppBackButton(),
                  const SizedBox(width: 12),
                  Text('Support Chat', style: AppTextStyles.h2),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: Obx(() {
                if (c.isHistoryLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.green),
                  );
                }

                if (c.messages.isEmpty) {
                  return const Center(
                    child: Text("No conversation yet. Start chatting!"),
                  );
                }

                return ListView.builder(
                  controller: c.scrollCtrl,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: c.messages.length,
                  itemBuilder: (context, index) {
                    final m = c.messages[index];
                    final isMe = (c.userId != null && m.senderId == c.userId);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ChatMessageBubble(message: m.text, isMe: isMe),
                    );
                  },
                );
              }),
            ),

            const ChatInputBar(),
          ],
        ),
      ),
    );
  }
}
