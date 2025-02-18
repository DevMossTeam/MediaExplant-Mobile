import '../models/article_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<ArticleModel>> getPopularNews();
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  @override
  Future<List<ArticleModel>> getPopularNews() async {
    // Simulasi delay API
    await Future.delayed(const Duration(seconds: 2));
    // Simulasi data dummy
    return [
      ArticleModel(
        id: "1",
        title: "Popular News 1",
        content: "This is the content of popular news 1.",
        imageUrl: "https://via.placeholder.com/150",
      ),
      ArticleModel(
        id: "2",
        title: "Popular News 2",
        content: "This is the content of popular news 2.",
        imageUrl: "https://via.placeholder.com/150",
      ),
      // Tambahkan data dummy lainnya jika diperlukan
    ];
  }
}
