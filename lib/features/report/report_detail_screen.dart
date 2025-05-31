import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:mediaexplant/core/utils/userID.dart';
import 'package:mediaexplant/features/report/report_viewmodel.dart';

class ReportDetailContent extends StatefulWidget {
  final String itemId;
  final String pesan;
  final String pesanType;
  final VoidCallback? onBack;

  const ReportDetailContent({
    Key? key,
    required this.itemId,
    required this.pesan,
    required this.pesanType,
    this.onBack,
  }) : super(key: key);

  @override
  State<ReportDetailContent> createState() => _ReportDetailContentState();
}

class _ReportDetailContentState extends State<ReportDetailContent> {
  final TextEditingController _detailController = TextEditingController();

  void sendReport() async {
    final detailText = _detailController.text.trim();
    final reportViewModel =
        Provider.of<ReportViewModel>(context, listen: false);

    await reportViewModel.sendReport(
      userId: userLogin,
      pesan: widget.pesan,
      statusRead: "belum",
      status: "laporan",
      detailPesan: detailText,
      pesanType: widget.pesanType,
      itemId: widget.itemId,
    );

    if (reportViewModel.errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Laporan berhasil dikirim")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(reportViewModel.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Tambahkan Detail (Opsional)",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Bagikan beberapa detail kepada kami untuk membantu memahami masalahnya. "
              "Harap jangan menyertakan informasi pribadi.",
              style: TextStyle(
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _detailController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Jelaskan lebih detail...",
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onBack,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Batal",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: sendReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Laporkan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
