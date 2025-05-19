import 'package:flutter/material.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/produk/produk_view_model.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/home_screen.dart';
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

    if (_isInit) {
      final produkVM = Provider.of<ProdukViewModel>(context, listen: false);

      setState(() {
        _isLoading['produk'] = true;
      });

      Future.wait([
        produkVM.fetchMajalah(userLogin),
        produkVM.fetchBuletin(userLogin),
      ]).then((_) {
        setState(() {
          _isLoading['produk'] = false;
        });
      }).catchError((error) {
        setState(() {
          _isLoading['produk'] = false;
        });
      });

      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final majalahList = Provider.of<ProdukViewModel>(context).allMajalah;
    final buletinList = Provider.of<ProdukViewModel>(context).allBuletin;

    // Jika ada data yang sedang dimuat, tampilkan loading indicator
    if (_isLoading.values.contains(true)) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
