import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/produk/buletin_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/produk/majalah_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/produk_selengkapnya.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/produk/produk_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/title_header_widget.dart';
import 'package:provider/provider.dart';

class HomeProdukScreen extends StatefulWidget {
  const HomeProdukScreen({super.key});

  @override
  State<HomeProdukScreen> createState() => _HomeProdukScreenState();
}

class _HomeProdukScreenState extends State<HomeProdukScreen>
    with AutomaticKeepAliveClientMixin<HomeProdukScreen> {
  var _isInit = true;
  final Map<String, bool> _isLoading = {
    'produk': false,
  };

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _fetchProdukSecaraBerurutan() async {
    final majalahVM = Provider.of<MajalahViewmodel>(context, listen: false);
    final buletinVM = Provider.of<BuletinViewmodel>(context, listen: false);

    try {
      // produk
      setState(() => _isLoading['produk'] = true);
      await majalahVM.refresh(userLogin);
      setState(() => _isLoading['produk'] = false);

      // produk
      setState(() => _isLoading['produk'] = true);
      await buletinVM.refresh(userLogin);
      setState(() => _isLoading['produk'] = false);
    } catch (e) {
      debugPrint('Error saat refresh: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final majalahVM = Provider.of<MajalahViewmodel>(context);
    final buletinVM = Provider.of<BuletinViewmodel>(context);

    final majalahList = majalahVM.allMajalah;
    final buletinList = buletinVM.allBuletin;

    // Jika ada data yang sedang dimuat, tampilkan loading indicator
    if (_isLoading.values.contains(true)) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
       onRefresh: () async {
        await _fetchProdukSecaraBerurutan();
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                top: 10,
              ),
              child: Column(
                children: [
                  titleHeader("Majalah", "Terbaru untuk anda"),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 240,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: majalahList.length.clamp(0, 5),
                        itemBuilder: (contex, index) {
                          return ChangeNotifierProvider.value(
                            value: majalahList[index],
                            child: ProdukItem(),
                          );
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          final viewModel = ProdukSelengkapnyaViewModel();
                          if (!mounted) return;
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider.value(
                              value: viewModel,
                              child: const ProdukSelengkapnya(
                                kategori: KategoriProduk.majalah,
                              ),
                            ),
                          ));
                          Future.microtask(() async {
                            await viewModel.setKategori(KategoriProduk.majalah);
                          });
                        },
                        child: const Text(
                          "Selengkapnya >>",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  titleHeader("Buletin", "Terbaru untuk anda"),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 240,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: buletinList.length.clamp(0, 5),
                        itemBuilder: (contex, index) {
                          return ChangeNotifierProvider.value(
                            value: buletinList[index],
                            child: ProdukItem(),
                          );
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          final viewModel = ProdukSelengkapnyaViewModel();
                          if (!mounted) return;
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider.value(
                              value: viewModel,
                              child: const ProdukSelengkapnya(
                                kategori: KategoriProduk.buletin,
                              ),
                            ),
                          ));
                          Future.microtask(() async {
                            await viewModel.setKategori(KategoriProduk.buletin);
                          });
                        },
                        child: const Text(
                          "Selengkapnya >>",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
