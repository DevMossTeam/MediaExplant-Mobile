import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/utils/time_ago_util.dart';
import 'package:mediaexplant/features/home/models/produk/produk.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_produk_screen.dart';

import 'package:provider/provider.dart';

class ProdukItem extends StatefulWidget {
  const ProdukItem({super.key});

  @override
  _ProdukItemState createState() => _ProdukItemState();
}

class _ProdukItemState extends State<ProdukItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final produk = Provider.of<Produk>(context);

    return Container(
      width: 105,
      height: 150,
      margin: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: produk.cover.isNotEmpty
                        ? Image.memory(
                            produk.gambar(),
                            fit: BoxFit.cover,
                          )
                        : const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                produk.kategori,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppColors.primary),
              ),
              Text(
                timeAgoFormat(DateTime.parse(produk.release_date)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                produk.judul,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Future.delayed(const Duration(milliseconds: 200), () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider.value(
                          value: produk,
                          child: DetailProdukScreen(
                            idProduk: produk.idproduk,
                            kategori: produk.kategori,
                          ),
                        ),
                      ),
                      (route) => route.isFirst,
                    );
                  });
                },
                splashColor: Colors.black.withAlpha(50),
                highlightColor: Colors.white.withAlpha(100),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
