import 'package:mediaexplant/features/home/data/repositories/news_repository_impl.dart';
import 'package:mediaexplant/features/home/data/models/berita.dart';

abstract class LocalDataSource {
  Future<List<Berita>> getSavedArticles();
}

class LocalDataSourceImpl implements LocalDataSource {
  @override
  Future<List<Berita>> getSavedArticles() async {
    // Menggunakan data dummy
    return Future.value(dummyBerita);
  }
}
