```
MediaExplant/
├── android/
├── ios/
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart           // Warna & design token (menggantikan file XML)
│   │   ├── app_strings.dart          // String/label aplikasi
│   │   └── app_routes.dart           // Definisi route/navigasi
│   ├── errors/
│   │   └── exceptions.dart
│   ├── network/
│   │   ├── api_client.dart
│   │   └── network_info.dart
│   ├── theme/
│   │   ├── app_theme.dart            // Tema global aplikasi
│   │   └── text_styles.dart          // Gaya teks khusus
│   ├── utils/
│   │   ├── date_utils.dart           // Adaptasi DateUtils.kt
│   │   └── email_sender.dart         // Adaptasi EmailSender.kt
│   └── widgets/
│       └── common_widgets.dart       // Widget umum (misal: button, card, dsb.)
│
├── features/
│   ├── auth/                         // Fitur autentikasi & manajemen akun
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── sign_in.dart
│   │   │       ├── sign_up.dart
│   │   │       ├── reset_password.dart
│   │   │       └── forgot_password.dart
│   │   └── presentation/
│   │       ├── ui/                   // Tampilan (mirip file XML Android)
│   │       │   ├── screens/
│   │       │   │   ├── sign_in_screen.dart           // (fragment_sign_in.xml)
│   │       │   │   ├── sign_up_screen.dart           // (fragment_sign_up.xml)
│   │       │   │   ├── sign_up_input_screen.dart     // (fragment_sign_up_input.xml)
│   │       │   │   └── reset_password_screen.dart     // (fragment_input_password.xml)
│   │       │   └── dialogs/
│   │       │       ├── change_password_dialog.dart           // (dialog_change_password.xml)
│   │       │       ├── confirm_change_email_dialog.dart        // (dialog_konfirmasi_ubah_email.xml)
│   │       │       ├── forgot_password_confirm_email_dialog.dart // (dialog_lupa_password_konfirmasi_email.xml)
│   │       │       ├── forgot_password_verify_email_dialog.dart  // (dialog_lupa_password_verif_email.xml)
│   │       │       └── sign_up_verify_email_dialog.dart        // (dialog_sign_up_verifikasi_email.xml)
│   │       └── logic/                // Logika bisnis (ViewModels/BLoC/Provider)
│   │           ├── lupa_password_viewmodel.dart      // (LupaPasswordViewModel.kt)
│   │           ├── reset_password_viewmodel.dart     // (ResetPasswordViewModel.kt)
│   │           ├── sign_in_viewmodel.dart            // (SignInViewModel.kt)
│   │           ├── sign_up_input_viewmodel.dart      // (SignUpInputViewModel.kt)
│   │           └── sign_up_viewmodel.dart            // (SignUpViewModel.kt)
│   │
│   ├── home/                         // Fitur Beranda & Berita
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── news_remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   ├── article_model.dart
│   │   │   │   └── berita_model.dart
│   │   │   └── repositories/
│   │   │       └── news_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── article.dart
│   │   │   ├── repositories/
│   │   │   │   └── news_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_popular_news.dart        // (BeritaPopuler)
│   │   │       ├── get_recommended_news.dart      // (BeritaRekomendasi)
│   │   │       ├── get_latest_news.dart           // (BeritaTerkini)
│   │   │       ├── get_related_news.dart          // (BeritaTerkait)
│   │   │       ├── get_most_commented_news.dart   // (KomentarTerbanyak)
│   │   │       └── get_popular_tags.dart          // (TagPopuler)
│   │   └── presentation/
│   │       ├── ui/                   // Tampilan UI
│   │       │   ├── screens/
│   │       │   │   ├── home_screen.dart           // (fragment_home.xml)
│   │       │   │   ├── home_popular_screen.dart    // (fragment_home_populer.xml)
│   │       │   │   ├── home_latest_screen.dart     // (fragment_home_terbaru.xml)
│   │       │   │   └── detail_article_screen.dart  // (fragment_detail_artikel.xml)
│   │       │   └── widgets/
│   │       │       ├── berita_terkait_item.dart    // (item_berita_terkait.xml)
│   │       │       ├── berita_populer_item.dart     // (item_berita_populer.xml)
│   │       │       ├── berita_rekomendasi_item.dart // (item_berita_rekomendasi.xml)
│   │       │       ├── komentar_terbanyak_item.dart  // (item_komentar_terbanyak.xml)
│   │       │       ├── tag_populer_item.dart        // (item_tag_populer.xml)
│   │       │       └── berita_terkini_item.dart      // (item_berita_terkini.xml)
│   │       └── logic/                // Logika Beranda
│   │           ├── berita_terkait_viewmodel.dart
│   │           ├── berita_populer_viewmodel.dart
│   │           ├── berita_rekomendasi_viewmodel.dart
│   │           ├── komentar_terbanyak_viewmodel.dart
│   │           ├── tag_populer_viewmodel.dart
│   │           └── berita_terkini_viewmodel.dart
│   │
│   ├── comments/                     // Fitur Komentar Artikel
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── comments_remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── comment_model.dart
│   │   │   └── repositories/
│   │   │       └── comments_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── comment.dart
│   │   │   ├── repositories/
│   │   │   │   └── comments_repository.dart
│   │   │   └── usecases/
│   │   │       └── get_comments.dart
│   │   └── presentation/
│   │       ├── ui/                   // Tampilan komentar
│   │       │   ├── screens/
│   │       │   │   └── comments_screen.dart      // (fragment_komentar_dialog.xml)
│   │       │   ├── dialogs/
│   │       │   │   └── comment_dialog.dart         // (item_dialog_komentar_artikel.xml)
│   │       │   └── widgets/
│   │       │       └── comment_item.dart           // Item tampilan komentar
│   │       └── logic/                // Logika komentar
│   │           └── komentar_viewmodel.dart        // (KomentarViewModel.kt)
│   │
│   ├── license/                      // Fitur Lisensi
│   │   └── presentation/
│   │       └── ui/
│   │           └── license_screen.dart           // (fragment_license.xml)
│   │
│   ├── notifications/                // Fitur Notifikasi
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── notification_remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── notification_model.dart
│   │   │   └── repositories/
│   │   │       └── notification_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── notification.dart
│   │   │   ├── repositories/
│   │   │   │   └── notification_repository.dart
│   │   │   └── usecases/
│   │   │       └── get_notifications.dart
│   │   └── presentation/
│   │       ├── ui/                   // Tampilan notifikasi
│   │       │   └── screens/
│   │       │       └── notifications_screen.dart // (fragment_notifikasi.xml)
│   │       ├── widgets/
│   │       │   └── notification_item.dart        // (item_notifikasi.xml)
│   │       └── logic/                // Logika notifikasi
│   │           └── notifications_viewmodel.dart
│   │
│   ├── profile/                      // Fitur Profil
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── profile_remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── profile_model.dart
│   │   │   └── repositories/
│   │   │       └── profile_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── profile.dart
│   │   │   ├── repositories/
│   │   │   │   └── profile_repository.dart
│   │   │   └── usecases/
│   │   │       └── get_profile.dart
│   │   └── presentation/
│   │       ├── ui/                   // Tampilan profil
│   │       │   ├── screens/
│   │       │   │   └── profile_screen.dart      // (fragment_profile.xml)
│   │       └── logic/
│   │           └── profile_viewmodel.dart
│   │
│   ├── reaksi/                       // Fitur Reaksi & Bookmark
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── reaksi_remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── reaksi_model.dart
│   │   │   └── repositories/
│   │   │       └── reaksi_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── reaksi.dart
│   │   │   ├── repositories/
│   │   │   │   └── reaksi_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_bookmarked_news.dart      // Bookmark
│   │   │       ├── get_liked_news.dart           // Like
│   │   │       └── get_view_count.dart           // ViewCount
│   │   └── presentation/
│   │       ├── ui/                   // Tampilan reaksi/bookmark
│   │       │   └── screens/
│   │       │       └── bookmarked_news_screen.dart // (fragment_daftar_berita_bookmark.xml)
│   │       ├── widgets/
│   │       │   ├── bookmark_item.dart           // (item_berita_bookmark.xml)
│   │       │   └── like_item.dart               // (item_berita_like.xml)
│   │       └── logic/                // Logika reaksi/bookmark
│   │           ├── bookmark_viewmodel.dart
│   │           ├── daftar_berita_bookmark_viewmodel.dart
│   │           ├── daftar_berita_like_viewmodel.dart
│   │           └── view_count_viewmodel.dart
│   │
│   ├── report/                       // Fitur Pelaporan
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── report_remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── report_model.dart
│   │   │   └── repositories/
│   │   │       └── report_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── report.dart
│   │   │   ├── repositories/
│   │   │   │   └── report_repository.dart
│   │   │   └── usecases/
│   │   │       └── submit_report.dart
│   │   └── presentation/
│   │       ├── ui/                   // Tampilan dialog pelaporan
│   │       │   └── dialogs/
│   │       │       └── report_dialog.dart       // (fragment_report_dialog.xml)
│   │       └── logic/                // Logika pelaporan
│   │           └── report_viewmodel.dart
│   │
│   ├── search/                       // Fitur Pencarian
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── search_remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── search_model.dart
│   │   │   └── repositories/
│   │   │       └── search_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── search.dart
│   │   │   ├── repositories/
│   │   │   │   └── search_repository.dart
│   │   │   └── usecases/
│   │   │       └── perform_search.dart
│   │   └── presentation/
│   │       ├── ui/                   // Tampilan pencarian
│   │       │   ├── screens/
│   │       │   │   ├── search_screen.dart        // (fragment_search.xml)
│   │       │   │   └── search_results_screen.dart  // (fragment_search_results.xml)
│   │       │   └── widgets/
│   │       │       └── search_result_item.dart     // (item_riwayat_search.xml, dsb.)
│   │       └── logic/                // Logika pencarian
│   │           └── search_viewmodel.dart
│   │
│   ├── welcome/                      // Fitur Onboarding & Welcome Page
│   │   └── presentation/
│   │       ├── ui/
│   │       │   ├── screens/
│   │       │   │   ├── welcome_screen.dart       // (fragment_welcome.xml)
│   │       │   │   ├── welcome_page1.dart        // (fragment_welcome_page_1.xml)
│   │       │   │   ├── welcome_page2.dart        // (fragment_welcome_page_2.xml)
│   │       │   │   └── welcome_page3.dart        // (fragment_welcome_page_3.xml)
│   │       └── logic/
│   │           └── welcome_viewmodel.dart
│   │
│   └── settings/                     // Fitur Settings (terpisah dari profil)
│       └── presentation/
│           ├── ui/
│           │   ├── screens/
│           │   │   ├── hubungi_screen.dart             // (HubungiFragment.kt)
│           │   │   ├── keamanan_screen.dart            // (KeamananFragment.kt)
│           │   │   ├── pengaturan_akun_screen.dart       // (PengaturanAkunFragment.kt)
│           │   │   ├── pusat_bantuan_screen.dart         // (PusatBantuanFragment.kt)
│           │   │   ├── setting_notifikasi_screen.dart    // (SettingNotifikasiFragment.kt)
│           │   │   ├── tentang_screen.dart               // (TentangFragment.kt)
│           │   │   └── umum_screen.dart                  // (UmumFragment.kt)
│           │   └── dialogs/                              // Jika ada dialog terkait settings
│           └── logic/
│               ├── hubungi_viewmodel.dart             // (HubungiViewModel.kt)
│               ├── keamanan_viewmodel.dart            // (KeamananViewModel.kt)
│               ├── pengaturan_akun_viewmodel.dart       // (PengaturanAkunViewModel.kt)
│               └── umum_viewmodel.dart                // (UmumViewModel.kt)
│
├── navigation/
│   └── app_router.dart               // Konfigurasi routing/navigasi aplikasi
│
└── main.dart                         // Entry point aplikasi
│
├── assets/                              // Asset seperti gambar, font, dll.
│   ├── images/
│   ├── fonts/
│   └── translations/
│
├── test/                                // Unit & widget test
│   ├── core/
│   ├── features/
│   └── widget_tests/
│
├── pubspec.yaml                         // Dependency dan asset config
└── README.md

```
