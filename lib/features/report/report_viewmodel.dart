import 'package:flutter/foundation.dart';
import 'package:mediaexplant/features/report/report_model.dart';
import 'package:mediaexplant/features/report/report_repository.dart';

class ReportViewModel extends ChangeNotifier {
  final ReportRepository _repository;

  ReportViewModel(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ReportModel? _report;
  ReportModel? get report => _report;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> sendReport({
    required String? userId,
    required String pesan,
    required String statusRead,
    required String status,
    required String detailPesan,
    required String pesanType,
    required String itemId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _report = await _repository.sendReport(
        userId: userId,
        pesan: pesan,
        statusRead: statusRead,
        status: status,
        detailPesan: detailPesan,
        pesanType: pesanType,
        itemId: itemId,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
