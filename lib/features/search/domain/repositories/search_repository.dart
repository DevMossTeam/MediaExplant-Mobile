import '../entities/searh.dart';

abstract class SearchRepository {
  Future<List<Search>> performSearch(String query);
}
