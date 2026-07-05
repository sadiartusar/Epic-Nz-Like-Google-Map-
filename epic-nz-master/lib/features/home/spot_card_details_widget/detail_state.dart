import 'package:flutter/material.dart';

class DetailStats extends StatelessWidget {
  final String distance;
  final String driveTime;
  final String walkTime;
  final String rating;

  const DetailStats({
    super.key,
    required this.distance,
    required this.driveTime,
    required this.walkTime,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 9),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("Distance", distance),
          _buildDivider(isDark),
          _buildStatItem("Drive", driveTime),
          _buildDivider(isDark),
          _buildStatItem("Walk", walkTime),
          _buildDivider(isDark),
          _buildStatItem("Avg. Rating", "$rating ⭐"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      height: 25,
      width: 1,
      color: isDark ? Colors.white10 : Colors.grey[200],
    );
  }
}
