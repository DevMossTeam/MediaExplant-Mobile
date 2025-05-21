import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/home/models/karya/karya.dart';
import 'package:mediaexplant/features/home/presentation/ui/screens/detail_karya_screen.dart';

import 'package:provider/provider.dart';

class PuisiItem extends StatefulWidget {
  const PuisiItem({super.key});

  @override
  _PuisiItemState createState() => _PuisiItemState();
}

class _PuisiItemState extends State<PuisiItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final karya = Provider.of<Karya>(context);

    return Container(
      width: 105,
      height: 150,
      margin: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: karya.media.isNotEmpty
                      ? Image.memory(
                          karya.gambar(),
                          fit: BoxFit.cover,
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                karya.kategori,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppColors.primary),
              ),
              Text(
                karya.release,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                karya.judul,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Future.delayed(const Duration(milliseconds: 200), () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider.value(
                          value: karya,
                          child: DetailKaryaScreen(),
                        ),
                      ),
                      (route) => route.isFirst,
                    );
                  });
                },
                splashColor: Colors.black.withAlpha(50),
                highlightColor: Colors.white.withAlpha(100),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
