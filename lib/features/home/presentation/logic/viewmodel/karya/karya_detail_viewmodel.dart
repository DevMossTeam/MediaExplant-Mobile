import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/home/models/karya/detail_karya.dart';
import 'package:mediaexplant/features/home/presentation/logic/repository/karya/karya_detail_repository.dart';

class KaryaDetailViewmodel with ChangeNotifier {
  final KaryaDetailRepository _repository = KaryaDetailRepository();

  DetailKarya? _detailKarya;
  bool isLoading = false;

  DetailKarya? get detailKarya => _detailKarya;

  Future<void> fetchKaryaDetail(String? userId, String idKarya) async {
    if (isLoading) return;
    isLoading = true;

    try {
      final response = await _repository.fetchKaryaDetail(userId, idKarya);
      _detailKarya = response;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error fetchKaryaDetail: ${e.toString()}");
    } finally {
      isLoading = false;
    }
  }

  Future<void> refresh(String? userId, String idKarya) async {
    _detailKarya = null;
    await fetchKaryaDetail(userId, idKarya);
  }
}
