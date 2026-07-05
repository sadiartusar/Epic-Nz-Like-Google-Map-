import 'package:flutter/material.dart';

class DetailReviews extends StatelessWidget {
  final List ratings;

  const DetailReviews({super.key, required this.ratings});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    int totalCount = ratings.length;
    double averageRating = 0.0;
    Map<int, int> starCounts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

    if (totalCount > 0) {
      double sum = 0;
      for (var r in ratings) {
        int val = int.tryParse(r['rating'].toString()) ?? 0;
        sum += val;
        if (starCounts.containsKey(val)) {
          starCounts[val] = starCounts[val]! + 1;
        }
      }
      averageRating = sum / totalCount;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Reviews",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < averageRating.floor()
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$totalCount Reviews",
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(width: 30),

            Expanded(
              child: Column(
                children: [5, 4, 3, 2, 1].map((star) {
                  double percent = totalCount > 0
                      ? (starCounts[star]! / totalCount)
                      : 0.0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Text(
                          "$star",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: percent,
                              minHeight: 6,
                              color: Colors.green,
                              backgroundColor: isDark
                                  ? Colors.white10
                                  : Colors.grey[200],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
