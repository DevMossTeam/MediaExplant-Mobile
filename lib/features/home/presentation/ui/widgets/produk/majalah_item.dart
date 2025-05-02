import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/home/models/majalah.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_produk_screen.dart';
import 'package:provider/provider.dart';
import 'package:pdfx/pdfx.dart';

class MajalahItem extends StatefulWidget {
  const MajalahItem({super.key});

  @override
  _MajalahItemState createState() => _MajalahItemState();
}

class _MajalahItemState extends State<MajalahItem> {
  Uint8List? _thumbnailBytes;

  @override
  void initState() {
    super.initState();
    final majalah = Provider.of<Majalah>(context, listen: false);
    if (majalah.media_url.isNotEmpty) {
      _loadPdfThumbnail(majalah.media_url);
    }
  }

  Future<void> _loadPdfThumbnail(String pdfUrl) async {
    try {
      final data = await NetworkAssetBundle(Uri.parse(pdfUrl)).load(pdfUrl);
      final bytes = data.buffer.asUint8List();

      final doc = await PdfDocument.openData(bytes);
      final page = await doc.getPage(1);

      final pageImage = await page.render(
        width: 300,
        height: 400,
        format: PdfPageImageFormat.png,
      );

      await page.close();

      if (mounted && pageImage != null) {
        final majalah = Provider.of<Majalah>(context, listen: false);
        majalah.thumbnail = pageImage.bytes;
      }
    } catch (e) {
      debugPrint("Gagal memuat thumbnail PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final majalah = Provider.of<Majalah>(context);

    return Container(
      width: 105,
      height: 150,
      margin: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: majalah.thumbnail == null
                      ? const Center(child: CircularProgressIndicator())
                      : Image.memory(majalah.thumbnail!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                majalah.kategori,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppColors.primary),
              ),
              Text(
                majalah.release_date,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                majalah.judul,
                maxLines: 3,
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
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 1000),
                        reverseTransitionDuration:
                            const Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ChangeNotifierProvider.value(
                                value: majalah,
                                child: const DetailProdukScreen()),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOutCubic,
                            )),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
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
