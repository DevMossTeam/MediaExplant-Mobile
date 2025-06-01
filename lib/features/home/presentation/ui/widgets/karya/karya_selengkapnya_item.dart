import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/utils/time_ago_util.dart';
import 'package:mediaexplant/features/home/models/karya/karya.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_karya_screen.dart';
import 'package:provider/provider.dart';

class KaryaSelengkapnyaItem extends StatelessWidget {
  const KaryaSelengkapnyaItem({super.key});

  @override
  Widget build(BuildContext context) {
    final karya = Provider.of<Karya>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider.value(
                value: karya,
                child: DetailKaryaScreen(
                  idKarya: karya.idKarya,
                  kategori: karya.kategori,
                ),
              ),
            ),
          );
        },
        child: Card(
          color: AppColors.background,
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar
              AspectRatio(
                aspectRatio: 3 / 4,
                child: karya.media.isNotEmpty
                    ? Image.memory(
                        karya.gambar(),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                          child: Icon(Icons.broken_image,
                              size: 40, color: Colors.grey),
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),

              // Konten bawah
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Kategori
                        Text(
                          karya.kategoriFormatted,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 5),
                        // Tanggal rilis
                        Text(
                          timeAgoFormat(DateTime.parse(karya.release)),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),

                    // Judul karya
                    Text(
                      karya.judul,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
