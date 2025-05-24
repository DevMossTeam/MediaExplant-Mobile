// ignore_for_file: public_member_api_docs, sort_constructors_first
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                "Ingin memberitahu kami selengkapnya? ini bersifat opsional.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            const Text(
                "Bagikan beberapa detail kepada kami untuk membantu kami memahami masalahnya.jangan sertakan pertanyaan atau info pribadi"),
            const SizedBox(height: 20),
            TextField(
              controller: _detailController,
              maxLines: 5,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: "Jelaskan lebih detail...~",
                enabledBorder: OutlineInputBorder(
                  // Border saat tidak fokus
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  // Border saat fokus
                  borderRadius: BorderRadius.circular(5),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      if (widget.onBack != null) {
                        widget.onBack!();
                      }
                    },
                    child: const Text("Batal"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: sendReport,
                    child: const Text("Laporkan"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
