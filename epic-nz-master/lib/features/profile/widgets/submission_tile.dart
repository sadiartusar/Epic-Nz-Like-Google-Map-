import 'package:epic_nz/core/theme/app_colors.dart';
import 'package:epic_nz/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class SubmissionTile extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isSelected;

  const SubmissionTile({
    super.key,
    required this.data,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String title = data['name'] ?? "Unknown Track";
    String status = data['status'] ?? "PENDING";
    String imageUrl = (data['imageUrl'] != null && data['imageUrl'].isNotEmpty)
        ? data['imageUrl'][0]
        : 'https://placehold.jp/150x150.png';

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.green.withValues(alpha: 0.1)
            : (isDark
                  ? AppColors.greenDark.withValues(alpha: 0.15)
                  : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? Colors.green
              : AppColors.green.withValues(alpha: 0.1),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? Colors.green.withValues(alpha: 0.25)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: isSelected ? 10 : 5,
            spreadRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 48,
                        height: 48,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 26,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        child: const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (isSelected)
                const Positioned.fill(
                  child: Center(
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 26,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.h2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  status == "PENDING" ? "Submitted recently" : "Approved",
                  // style: AppTextStyles.micro,
                  style: TextStyle(
                    fontSize: 14
                  ),

                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: status == "APPROVED"
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status == "APPROVED" ? 'Live' : 'Pending',
              style: AppTextStyles.micro.copyWith(
                color: status == "APPROVED" ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 14
              ),
            ),
          ),
        ],
      ),
    );
  }
}
