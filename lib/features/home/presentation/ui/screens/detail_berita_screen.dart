import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mediaexplant/core/utils/app_colors.dart';
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
      SystemUiOverlayStyle(
        statusBarColor:
            Colors.grey.withAlpha(100), // Warna background status bar
        statusBarIconBrightness:
            Brightness.light, // Warna ikon status bar (terang)
      ),
    );

    final beritaProvider = Provider.of<BeritaProvider>(context);
    final beritList = beritaProvider.allBerita;
    return Scaffold(
      backgroundColor: AppColors.background,
      // appBar: AppBar(
      //   iconTheme: const IconThemeData(color: Colors.white),
      //   title: Text(
      //     berita.kategori,
      //     style: const TextStyle(color: Colors.white),
      //   ),
      //   backgroundColor: AppColors.primary,
      // ),
      body: SafeArea(
        // supaya ui tidak tertutup oleh status
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //gambar utama
                Stack(
                  children: [
                    Image.network(
                      widget.berita.gambar,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    // Tombol Back di kiri atas gambar utama
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(100),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
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
                              ? const Icon(Icons.bookmark)
                              : const Icon(Icons.bookmark_outline),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.berita.judul,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.berita.tanggalDibuat,
                            style: const TextStyle(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    NetworkImage(widget.berita.penulis),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                widget.berita.penulis,
                                style: const TextStyle(color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 5),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Divider(),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // konten berita
                          Text(
                            widget.berita.kontenBerita,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black87),
                          ),
                          const SizedBox(height: 10),

                          // like dislike
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
                                icon:
                                    const Icon(Icons.share, color: Colors.blue),
                                onPressed: () {},
                              ),
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
                                    const Icon(Icons.report, color: Colors.red),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:const EdgeInsets.all(10),
                      child: Wrap(
                        spacing: 8.0, // Jarak antar tag secara horizontal
                        runSpacing: 8.0, // Jarak antar baris tag
                        children: widget.berita.tags.map((tag) {
                          return ActionChip(
                            onPressed: () {},
                            label: Text(
                              tag,
                              style: const TextStyle(color: AppColors.primary),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: const BorderSide(color: AppColors.primary),
                            ),
                            backgroundColor: AppColors.background,
                          );
                        }).toList(), // Pastikan hasil map dikonversi ke List
                      ),
                    ),

                    const Divider(),

                    //berita terkait
                    Padding(
                      padding: const EdgeInsets.all(10),
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
                            height: 130,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: beritList.length,
                              itemBuilder: (context, index) {
                                return ChangeNotifierProvider.value(
                                  value: beritList[index],
                                  child: BeritaTerkaitItem(
                                    onTap: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailBeritaScreen(
                                                    berita: beritList[index]),
                                          ),
                                          (route) => route.isFirst);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // berita lainnya
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),

                const Divider(),

                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Berita Lainnya",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: beritList.length,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider.value(
                      value: beritList[index],
                      child: BeritaPopulerItem(
                        // berita: beritList[index],
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailBeritaScreen(berita: beritList[index]),
                            ),
                            (route) => route.isFirst,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Anda mengeklik ${beritList[index].judul}"),
                            duration: const Duration(seconds: 2),
                          ));
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showKomentarScreen(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Agar tinggi modal bisa menyesuaikan
    backgroundColor: Colors.transparent, // Buat background transparan
    builder: (context) {
      return const KomentarScreen();
    },
  );
}
