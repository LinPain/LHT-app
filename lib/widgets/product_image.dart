
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.imageUrl,
    this.width = 120,
    this.height = 120,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final url = imageUrl.trim();

    if (url.isEmpty) {
      return _placeholder();
    }

    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return _placeholder();
      },
    );
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF5F0E8),
      alignment: Alignment.center,
      child: const Icon(
        Icons.local_cafe_outlined,
        size: 40,
        color: Color(0xFF8B6248),
      ),
    );
  }
}