import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/utils/time_ago_util.dart';
import 'package:mediaexplant/features/home/models/produk/produk.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_produk_screen.dart';
import 'package:provider/provider.dart';

class ProdukSelengkapnyaItem extends StatelessWidget {
  const ProdukSelengkapnyaItem({super.key});

  @override
  Widget build(BuildContext context) {
    final produk = Provider.of<Produk>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider.value(
                value: produk,
                child: DetailProdukScreen(
                  idProduk: produk.idproduk,
                  kategori: produk.kategori,
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar
              AspectRatio(
                aspectRatio: 3 / 4,
                child: produk.cover.isNotEmpty
                    ? Image.memory(
                        produk.gambar(),
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
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          produk.kategori,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        // Tanggal rilis
                        Text(
                          timeAgoFormat(DateTime.parse(produk.release_date)),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    // Judul produk
                    Text(
                      produk.judul,
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
