import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBeritaItem extends StatelessWidget {
  const ShimmerBeritaItem({super.key});

  Widget shimmerBox(
      {double width = double.infinity,
      double height = 20,
      BorderRadius? radius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: radius ?? BorderRadius.circular(5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Gambar besar (berita utama)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: shimmerBox(height: 200, radius: BorderRadius.circular(12)),
        ),

        const SizedBox(height: 15),

        // Judul dan tab
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              shimmerBox(width: 100, height: 20),
              const SizedBox(width: 10),
              shimmerBox(width: 80, height: 20),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // List berita horizontal (2 item contoh)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: List.generate(2, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerBox(width: 140, height: 70),
                    const SizedBox(height: 5),
                    shimmerBox(width: 100, height: 5),
                    const SizedBox(height: 5),
                    shimmerBox(width: 140, height: 5),
                    const SizedBox(height: 5),
                    shimmerBox(width: 140, height: 5),
                  ],
                ),
              );
            }),
          ),
        ),

        const SizedBox(height: 15),

        // Judul rekomendasi dan tab
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              shimmerBox(width: 100, height: 20),
              const SizedBox(width: 10),
              shimmerBox(width: 80, height: 20),
            ],
          ),
        ),

        const SizedBox(height: 15),

        // List berita vertikal
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    shimmerBox(width: 140, height: 70),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmerBox(width: 50, height: 5),
                        const SizedBox(height: 5),
                        shimmerBox(width: 200, height: 5),
                        const SizedBox(height: 5),
                        shimmerBox(width: 200, height: 5),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
