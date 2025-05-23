import 'package:flutter/material.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/desain_grafis_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/fotografi_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/puisi_terbaru_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/karya/syair_terbaru_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/karya/desain_grafis_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/karya/fotografi_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/karya/puisi_item.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/title_header_widget.dart';
import 'package:provider/provider.dart';

class HomeKaryaScreen extends StatefulWidget {
  const HomeKaryaScreen({super.key});

  @override
  State<HomeKaryaScreen> createState() => _HomeKaryaScreenState();
}

class _HomeKaryaScreenState extends State<HomeKaryaScreen>
    with AutomaticKeepAliveClientMixin<HomeKaryaScreen> {
  var _isInit = true;
  final Map<String, bool> _isLoading = {
    'puisi': false,
    'syair': false,
    'desain_grafis': false,
    'fotografi': false,
  };

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final puisiVM =
          Provider.of<PuisiTerbaruViewmodel>(context, listen: false);
      final syairVM =
          Provider.of<SyairTerbaruViewmodel>(context, listen: false);
      final desainGrafisVM =
          Provider.of<DesainGrafisViewmodel>(context, listen: false);
      final fotografiVM =
          Provider.of<FotografiViewmodel>(context, listen: false);
      setState(() {
        _isLoading['puisi'] = true;
        _isLoading['syair'] = true;
        _isLoading['desain_grafis'] = true;
        _isLoading['fotografi'] = true;
      });

      Future.wait([
        puisiVM.fetchPuisiTerbaru(userLogin),
        syairVM.fetchSyairTerbaru(userLogin),
        desainGrafisVM.fetchDesainGrafis(userLogin),
        fotografiVM.fetchFotografi(userLogin),
      ]).then((_) {
        setState(() {
          _isLoading['puisi'] = false;
          _isLoading['syair'] = false;
          _isLoading['desain_grafis'] = false;
          _isLoading['fotografi'] = false;
        });
      }).catchError((error) {
        setState(() {
          _isLoading['puisi'] = false;
          _isLoading['syair'] = false;
          _isLoading['desain_grafis'] = false;
          _isLoading['fotografi'] = false;
        });
      });

      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final puisiList = Provider.of<PuisiTerbaruViewmodel>(context).allPuisi;
    final syairList = Provider.of<SyairTerbaruViewmodel>(context).allSyair;
    final desainGrafisList =
        Provider.of<DesainGrafisViewmodel>(context).allDesainGrafis;
    final fotografiList = Provider.of<FotografiViewmodel>(context).allFotografi;

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
                titleHeader("Puisi", "Terbaru untuk anda"),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: puisiList.length.clamp(0, 5),
                      itemBuilder: (contex, index) {
                        return ChangeNotifierProvider.value(
                          value: puisiList[index],
                          child: PuisiItem(),
                        );
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                titleHeader("Syair", "Terbaru untuk anda"),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: syairList.length.clamp(0, 5),
                      itemBuilder: (contex, index) {
                        return ChangeNotifierProvider.value(
                          value: syairList[index],
                          child: PuisiItem(),
                        );
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                titleHeader("Desain Grafis", "Terbaru untuk anda"),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: desainGrafisList.length.clamp(0, 5),
                      itemBuilder: (contex, index) {
                        return ChangeNotifierProvider.value(
                          value: desainGrafisList[index],
                          child: DesainGrafisItem(),
                        );
                      }),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.grey.withAlpha(50),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, top: 20, bottom: 20),
              child: Column(
                children: [
                  // berita terbaru
                  titleHeader("Fotografi", "Terbaru untuk anda"),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 200,
                    child: GridView.builder(
                        itemCount: fotografiList.length.clamp(0, 10),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.27,
                                crossAxisCount: 2),
                        itemBuilder: (contex, index) {
                          return ChangeNotifierProvider.value(
                            value: fotografiList[index],
                            child: FotografiItem(),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
