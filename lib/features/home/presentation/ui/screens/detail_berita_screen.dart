import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/home/data/models/berita.dart';
import 'package:mediaexplant/features/home/data/providers/berita_provider.dart';
import 'package:mediaexplant/features/comments/presentation/ui/screens/komentar_screen.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_populer_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_terkait_item.dart';
import 'package:provider/provider.dart';

class DetailBeritaScreen extends StatefulWidget {
  final Berita berita;
  const DetailBeritaScreen({super.key, required this.berita});

  @override
  State<DetailBeritaScreen> createState() => _DetailBeritaScreenState();
}

class _DetailBeritaScreenState extends State<DetailBeritaScreen> {
  @override
  Widget build(BuildContext context) {
    // Mengubah warna status bar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final beritaProvider = Provider.of<BeritaProvider>(context);
    final beritaList = beritaProvider.allBerita;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Gambar utama dengan efek SliverAppBar
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: Colors.black.withAlpha(100),
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: CachedNetworkImage(
                  imageUrl: widget.berita.gambar,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(), // Indikator loading
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child:
                        Icon(Icons.broken_image, size: 50, color: Colors.red),
                  ),
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(100),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        widget.berita.statusBookmark();
                      });
                    },
                    icon: (widget.berita.isBookmark ?? false)
                        ? const Icon(Icons.bookmark, color: Colors.white)
                        : const Icon(Icons.bookmark_outline,
                            color: Colors.white),
                  ),
                ),
              ],
            ),

            // Konten Berita
            SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "mediaExplant",
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.berita.judul,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.grey, thickness: 0.5),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Konten berita
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    NetworkImage(widget.berita.penulis),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  widget.berita.penulis,
                                  style: const TextStyle(color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.berita.tanggalDibuat,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            widget.berita.kontenBerita,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black87),
                          ),
                          const SizedBox(height: 20),

                          // Tombol interaksi
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.thumb_up,
                                    color: Colors.blue),
                                onPressed: () {},
                              ),
                              const Text('0',
                                  style: TextStyle(color: Colors.blue)),
                              const SizedBox(width: 10),
                              IconButton(
                                icon: const Icon(Icons.thumb_down,
                                    color: Colors.red),
                                onPressed: () {},
                              ),
                              const Text('2',
                                  style: TextStyle(color: Colors.red)),
                              const SizedBox(width: 10),
                              IconButton(
                                icon: const Icon(Icons.comment,
                                    color: Colors.blue),
                                onPressed: () {
                                  showKomentarScreen(context);
                                },
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                icon:
                                    const Icon(Icons.share, color: Colors.blue),
                                onPressed: () {},
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                icon:
                                    const Icon(Icons.report, color: Colors.red),
                                onPressed: () {},
                              ),
                            ],
                          ),

                          // Tag berita
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: widget.berita.tags.map((tag) {
                              return ActionChip(
                                onPressed: () {},
                                label: Text(
                                  tag,
                                  style:
                                      const TextStyle(color: AppColors.primary),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: const BorderSide(
                                      color: AppColors.primary),
                                ),
                                backgroundColor: AppColors.background,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.grey, thickness: 0.5),
                  ],
                ),
              ]),
            ),

            // Berita Terkait
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Berita Terkait',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: beritaList.length,
                          itemBuilder: (context, index) {
                            return ChangeNotifierProvider.value(
                              value: beritaList[index],
                              child: BeritaTerkaitItem(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailBeritaScreen(
                                          berita: beritaList[index]),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.grey, thickness: 0.5),
              ]),
            ),

            // Berita Lainnya
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const Text(
                    'Berita Lainnya',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                ]),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ChangeNotifierProvider.value(
                    value: beritaList[index],
                    child: BeritaPopulerItem(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailBeritaScreen(berita: beritaList[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
                childCount: beritaList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Fungsi untuk menampilkan komentar
void showKomentarScreen(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return const KomentarScreen();
    },
  );
}
