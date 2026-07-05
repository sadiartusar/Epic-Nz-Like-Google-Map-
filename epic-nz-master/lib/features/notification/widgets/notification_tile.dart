import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class NotificationTile extends StatelessWidget {
  final IconData? icon;
  final String? avatarUrl;
  final String title;
  final String message;
  final String time;
  final bool isUnread;

  const NotificationTile({
    super.key,
    this.icon,
    this.avatarUrl,
    required this.title,
    required this.message,
    required this.time,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
        border: Border.all(
          color: isUnread ? AppColors.green : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          _leadingIcon(),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.body.copyWith(
                  fontSize: 16
                )),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 14,
                    color: isDark
                        ? Colors.white70
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Text(
            time,
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _leadingIcon() {
    if (avatarUrl != null) {
      return CircleAvatar(
        backgroundImage: NetworkImage(avatarUrl!),
        radius: 22,
      );
    }

    return CircleAvatar(
      radius: 22,
      backgroundColor: AppColors.green.withValues(alpha: 0.15),
      child: Icon(
        icon ?? Icons.notifications,
        color: AppColors.green,
        size: 18,
      ),
    );
  }
}
