import 'package:flutter/material.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_berita_screen.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_karya_screen.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_produk_screen.dart';
import 'package:mediaexplant/features/search/models/search.dart';

class SearchItem extends StatelessWidget {
  final Search hasil;

  const SearchItem({super.key, required this.hasil});

  @override
  Widget build(BuildContext context) {
    print('kategori: ${hasil.kategori}');

    return ListTile(
      leading: Icon(
        _iconForTipe(hasil.tipe, kategori: hasil.kategori),
        color: _colorForTipe(hasil.tipe),
      ),
      title: Text(
        hasil.judul,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "${hasil.kategori} • ${hasil.tanggal}",
        style: const TextStyle(fontSize: 12),
      ),
      onTap: () {
        Future.delayed(const Duration(milliseconds: 200), () {
          Widget screen;
          switch (hasil.tipe.toLowerCase().trim()) {
            case 'berita':
              screen = DetailBeritaScreen(
                idBerita: hasil.id,
                kategori: hasil.kategori,
              );
              break;
            case 'karya':
              screen = DetailKaryaScreen(
                idKarya: hasil.id,
                kategori: hasil.kategori,
              );
              break;
            case 'produk':
              screen = DetailProdukScreen(
                idProduk: hasil.id,
                kategori: hasil.kategori,
              );
              break;
            default:
              return;
          }

          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => screen),
          );
        });
      },
    );
  }

  IconData _iconForTipe(String tipe, {String? kategori}) {
    final tipeLower = tipe.toLowerCase().trim();
    final kategoriLower = kategori?.toLowerCase().trim();

    switch (tipeLower) {
      case 'berita':
        return Icons.article;

      case 'karya':
        switch (kategoriLower) {
          case 'syair':
            return Icons.music_note;
          case 'pantun':
            return Icons.format_quote;
          case 'desain grafis':
            return Icons.brush;
          case 'puisi':
            return Icons.menu_book;
          case 'fotografi':
            return Icons.photo_camera;
          default:
            return Icons.palette;
        }

      case 'produk':
        switch (kategoriLower) {
          case 'buletin':
            return Icons.description;
          case 'majalah':
            return Icons.menu_book;
          default:
            return Icons.shopping_bag;
        }

      default:
        return Icons.help_outline;
    }
  }

  Color _colorForTipe(String tipe) {
    switch (tipe) {
      case 'berita':
        return Colors.blue;
      case 'karya':
        return Colors.deepPurple;
      case 'produk':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}
