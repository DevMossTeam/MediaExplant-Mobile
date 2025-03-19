import 'package:flutter/material.dart';
import 'package:mediaexplant/features/home/data/models/berita.dart';
import 'package:mediaexplant/features/home/data/repositories/news_repository_impl.dart';
import 'package:mediaexplant/features/comments/presentation/ui/screens/komentar_screen.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_populer_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_terkait_item.dart';
import 'package:mediaexplant/core/utils/app_colors.dart'; // Import dummyBerita

class DetailBeritaScreen extends StatelessWidget {
  final Berita berita;
  const DetailBeritaScreen({super.key, required this.berita});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          berita.kategori,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //gambar utama
                Image.network(
                  berita.gambar,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
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
                            berita.judul,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            berita.tanggalDibuat,
                            style: const TextStyle(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(berita.penulis),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                berita.penulis,
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
                            berita.kontenBerita,
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

                    // // shere button ,report
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //   children: [
                    //     IconButton(
                    //       icon: const Icon(Icons.comment, color: Colors.blue),
                    //       onPressed: () {
                    //         showKomentarScreen(context);
                    //       },
                    //     ),
                    //     IconButton(
                    //       icon: const Icon(Icons.report, color: Colors.red),
                    //       onPressed: () {},
                    //     ),
                    //   ],
                    // ),

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
                              itemCount: dummyBerita.length,
                              itemBuilder: (context, index) {
                                return BeritaTerkaitItem(
                                  berita: dummyBerita[index],
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailBeritaScreen(
                                                  berita: dummyBerita[index]),
                                        ),
                                        (route) => route.isFirst);
                                  },
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
                  itemCount: dummyBerita.length,
                  itemBuilder: (context, index) {
                    return BeritaPopulerItem(
                      berita: dummyBerita[index],
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailBeritaScreen(berita: dummyBerita[index]),
                          ),
                          (route) => route.isFirst,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Anda mengeklik ${dummyBerita[index].judul}"),
                          duration: const Duration(seconds: 2),
                        ));
                      },
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
