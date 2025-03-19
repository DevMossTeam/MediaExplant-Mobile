import 'package:mediaexplant/features/home/data/models/berita.dart';

import '../repositories/news_repository.dart';

class GetPopularNews {
  final NewsRepository repository;

  GetPopularNews(this.repository);

  Future<List<Berita>> call() {
    return repository.getPopularNews();
  }
}
