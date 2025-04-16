import 'package:flutter/material.dart';
import 'package:mediaexplant/features/home/data/providers/berita_provider.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_populer_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita_terkini_item.dart';
import 'package:provider/provider.dart';

class HomeLatestScreen extends StatefulWidget {
  const HomeLatestScreen({super.key});

  @override
  State<HomeLatestScreen> createState() => _HomeLatestScreenState();
}

class _HomeLatestScreenState extends State<HomeLatestScreen> {
  bool _isLoading = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true; // Set loading state saat data di-fetch
      });
      print('Fetching berita data...'); // Debugging: Menandakan mulai fetching data

      Provider.of<BeritaProvider>(context, listen: false)
          .fetchBerita()
          .then((_) {
        print('Berita data fetched successfully'); // Debugging: Menandakan data sudah berhasil di-fetch
        setState(() {
          _isLoading = false; // Data selesai dimuat, hentikan loading
        });
      }).catchError((error) {
        print('Error while fetching berita data: $error'); // Debugging: Menangkap error jika fetching gagal
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final beritaProvider = Provider.of<BeritaProvider>(context);
    final beritaList = beritaProvider.allBerita;

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // **Berita Terkini**
                if (beritaList.isNotEmpty)
                  ChangeNotifierProvider.value(
                    value: beritaList[0],
                    child: const BeritaTerkiniItem(),
                  ),

                // **Berita Populer**
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: beritaList.length,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider.value(
                      value: beritaList[index],
                      child: BeritaPopulerItem(),
                    );
                  },
                ),
              ],
            ),
          );
  }
}
