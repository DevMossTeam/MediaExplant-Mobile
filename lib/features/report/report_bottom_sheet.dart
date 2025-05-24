import 'package:flutter/material.dart';
import 'package:mediaexplant/core/constants/app_colors.dart';
import 'package:mediaexplant/features/report/report_detail_screen.dart';

class ReportBottomSheet extends StatefulWidget {
  final String itemId;
  final String pesanType;

  const ReportBottomSheet({
    Key? key,
    required this.itemId,
    required this.pesanType,
  }) : super(key: key);

  @override
  State<ReportBottomSheet> createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {
  String? selectedCategory;
  String? pilihPesan;
  bool isDetailShown = false;

  final Map<String, List<String>> reportOptions = {
    'konten seksual': ['pornografi', 'eksploitasi anak', 'pelecehan seksual'],
    'konten kekerasan atau menjijikkan': [
      'kekerasan fisik',
      'kekerasan verbal',
      'kekerasan psikologis'
    ],
    'konten kebencian atau pelecehan': [
      'pelecehan rasial',
      'pelecehan agama',
      'pelecehan seksual'
    ],
    'tindakan berbahaya': [
      'penggunaan narkoba',
      'penyalahgunaan senjata',
      'tindakan berbahaya lainnya'
    ],
    'spam atau misinformasi': ['berita palsu', 'iklan tidak sah', 'penipuan'],
    'masalah hukum': [
      'pelanggaran hak cipta',
      'pelanggaran privasi',
      'masalah hukum lainnya'
    ],
    'teks bermasalah': [
      'kata kata kasar',
      'teks diskriminasi',
      'teks mengandung kekerasan'
    ],
  };

  void goToDetailPage() {
    if (selectedCategory != null && pilihPesan != null) {
      setState(() {
        isDetailShown = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Harap pilih kategori dan alasan terlebih dahulu"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      builder: (_, controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle Sheet
              Center(
                child: Container(
                  width: 50,
                  height: 4,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Judul
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  isDetailShown ? "Detail Pesan" : "Laporkan Konten",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Divider(thickness: 1),

              // Konten kategori & alasan
              if (!isDetailShown) ...[
                ...reportOptions.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RadioListTile<String>(
                        title: Text(entry.key),
                        value: entry.key,
                        groupValue: selectedCategory,
                        fillColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColors.primary;
                            }
                            return Colors.grey;
                          },
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                            pilihPesan = null;
                          });
                        },
                      ),
                      if (selectedCategory == entry.key)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: DropdownButtonFormField<String>(
                            value: pilihPesan,
                            dropdownColor: AppColors.background,
                            decoration: InputDecoration(
                              labelText: "Pilih alasan",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: AppColors.primary),
                              ),
                            ),
                            items: entry.value
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                pilihPesan = val;
                              });
                            },
                          ),
                        ),
                    ],
                  );
                }),
                const SizedBox(height: 20),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            pilihPesan != null
                                ? AppColors.primary
                                : Colors.grey,
                          ),
                        ),
                        onPressed: pilihPesan != null ? goToDetailPage : null,
                        child: const Text(
                          "Berikutnya",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],

              // Tampilan Form Detail
              if (isDetailShown)
                ReportDetailContent(
                  itemId: widget.itemId,
                  pesanType: widget.pesanType,
                  pesan: pilihPesan!,
                  onBack: () {
                    setState(() {
                      isDetailShown = false;
                    });
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
