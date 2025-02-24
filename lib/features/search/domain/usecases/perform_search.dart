import '../../domain/entities/searh.dart';
import '../repositories/search_repository.dart';

class PerformSearch {
  final SearchRepository repository;

  PerformSearch({required this.repository});

  Future<List<Search>> call(String query) async {
    return await repository.performSearch(query);
  }
}
