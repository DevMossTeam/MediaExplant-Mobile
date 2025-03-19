import 'package:mediaexplant/features/home/data/models/berita.dart';


abstract class NewsRepository {
  Future<List<Berita>> getPopularNews();
}
