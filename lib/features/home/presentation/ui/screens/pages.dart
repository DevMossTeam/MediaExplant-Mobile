import 'package:flutter/material.dart';
import 'package:mediaexplant/features/home/presentation/logic/viewmodel/berita/berita_dari_kami_viewmodel.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/home_screen.dart';
import 'package:mediaexplant/features/home/presentation/ui/widgets/berita/berita_populer_item.dart';
import 'package:provider/provider.dart';

class Pages extends StatefulWidget {
  const Pages({super.key});

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  final ScrollController _scrollController = ScrollController();

  void onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if (currentScroll == maxScroll &&
        context.read<BeritaDariKamiViewmodel>().hasMore) {
      context.read<BeritaDariKamiViewmodel>().fetchBeritaDariKami(userLogin);
    }
  }

  @override
  void initState() {
    context.read<BeritaDariKamiViewmodel>().fetchBeritaDariKami(userLogin);
    super.initState();
    _scrollController.addListener(onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Consumer<BeritaDariKamiViewmodel>(builder: (_, State, __) {
          return ListView.builder(
              controller: _scrollController,
              itemCount: State.hasMore
                  ? State.allBerita.length + 1
                  : State.allBerita.length,
              itemBuilder: (context, index) {
                if (index < State.allBerita.length) {
                  return ChangeNotifierProvider.value(
                    value: State.allBerita[index],
                    child: const BeritaPopulerItem(),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    ),
                  );
                }
              });
        }));
  }
}
