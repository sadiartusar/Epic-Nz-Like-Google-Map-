import 'package:epic_nz/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DetailFacilities extends StatelessWidget {
  final String? watererType;
  final String? animalClearance;
  final String? networkQuality;

  const DetailFacilities({
    super.key,
    this.watererType,
    this.animalClearance,
    this.networkQuality,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [];

    if (watererType != null && watererType!.isNotEmpty) {
      items.add(_facilityItem(Icons.wb_sunny_outlined, watererType!));
    }

    if (animalClearance != null && animalClearance!.isNotEmpty) {
      items.add(_facilityItem(Icons.pets_outlined, animalClearance!));
    }

    if (networkQuality != null && networkQuality!.isNotEmpty) {
      items.add(_facilityItem(Icons.network_cell_outlined, networkQuality!));
    }

    if (items.isEmpty) return const SizedBox();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: items),
    );
  }

  Widget _facilityItem(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.green),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
