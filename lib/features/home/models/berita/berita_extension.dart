import 'package:mediaexplant/features/home/models/berita/berita.dart';

extension BeritaLinkExtension on Berita {
  get kategori => null;

  String getLinkBerita() {
    // Ubah kategori ke lowercase dan ganti spasi dengan strip (opsional)
    final kategoriSlug = kategori.toLowerCase().replaceAll(' ', '-');
    return 'http://mediaexplant.com/kategori/$kategoriSlug/read?a=$idBerita';
  }
}
