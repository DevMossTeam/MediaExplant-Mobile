import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetPopularNews {
  final NewsRepository repository;

  GetPopularNews(this.repository);

  Future<List<Article>> call() {
    return repository.getPopularNews();
  }
}
