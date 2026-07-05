import 'package:flutter/material.dart';

class StackedPlaceImages extends StatelessWidget {
  final List<String> images;

  const StackedPlaceImages({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    final List<String?> slots = List.generate(
      3,
      (index) => images.length > index ? images[index] : null,
    );

    return SizedBox(
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _imageCard(slots[0], -0.20, const Offset(-36, 8)),
          _imageCard(slots[1], 0.15, const Offset(36, 10)),
          _imageCard(slots[2], 0.0, Offset.zero, isFront: true),
        ],
      ),
    );
  }

  Widget _imageCard(
    String? imageUrl,
    double angle,
    Offset offset, {
    bool isFront = false,
  }) {
    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: isFront ? 118 : 108,
          height: isFront ? 148 : 138,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
            image: DecorationImage(
              image: imageUrl != null
                  ? NetworkImage(imageUrl)
                  : const AssetImage('assets/images/placeholder.jpg')
                        as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
