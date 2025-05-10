```
MediaExplant/
├── android/
├── ios/
├── assets/                              // Asset seperti gambar, font, dll.
│   ├── images/
│   ├── fonts/
│   └── translations/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_config.dart           // Definisi route/navigasi
│   │   ├── errors/
│   │   │   └── exceptions.dart
│   │   ├── network/
│   │   │   ├── api_client.dart
│   │   ├── utils/
│   │   │   ├── date_utils.dart           // Adaptasi DateUtils.kt
│   │   │   └── email_sender.dart         // Adaptasi EmailSender.kt
│   │
│   ├── features/
│   │   ├── auth/                         // Fitur autentikasi & manajemen akun
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── auth_remote_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── user_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── user.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── sign_in.dart
│   │   │   │       ├── sign_up.dart
│   │   │   │       ├── reset_password.dart
│   │   │   │       └── forgot_password.dart
│   │   │   └── presentation/
│   │   │       ├── ui/                   // Tampilan (mirip file XML Android)
│   │   │       │   ├── screens/
│   │   │       │   │   ├── sign_in_screen.dart           // (fragment_sign_in.xml)
│   │   │       │   │   ├── sign_up_screen.dart           // (fragment_sign_up.xml)
│   │   │       │   │   ├── sign_up_input_screen.dart     // (fragment_sign_up_input.xml)
│   │   │       │   │   └── reset_password_screen.dart     // (fragment_input_password.xml)
│   │   │       │   └── dialogs/
│   │   │       │       ├── change_password_dialog.dart           // (dialog_change_password.xml)
│   │   │       │       ├── confirm_change_email_dialog.dart        // (dialog_konfirmasi_ubah_email.xml)
│   │   │       │       ├── forgot_password_confirm_email_dialog.dart // (dialog_lupa_password_konfirmasi_email.xml)
│   │   │       │       ├── forgot_password_verify_email_dialog.dart  // (dialog_lupa_password_verif_email.xml)
│   │   │       │       └── sign_up_verify_email_dialog.dart        // (dialog_sign_up_verifikasi_email.xml)
│   │   │       └── logic/                // Logika bisnis (ViewModels/BLoC/Provider)
│   │   │           ├── lupa_password_viewmodel.dart      // (LupaPasswordViewModel.kt)
│   │   │           ├── reset_password_viewmodel.dart     // (ResetPasswordViewModel.kt)
│   │   │           ├── sign_in_viewmodel.dart            // (SignInViewModel.kt)
│   │   │           ├── sign_up_input_viewmodel.dart      // (SignUpInputViewModel.kt)
│   │   │           └── sign_up_viewmodel.dart            // (SignUpViewModel.kt)
│   │   │
│   │   ├── home/                         // Fitur Beranda & Berita
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── news_remote_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── berita.dart
│   │   │   │   │   └── berita.g.dart
│   │   │   │   └── repositories/
│   │   │   │       └── news_repository_impl.dart
│   │   │   │   └── provider/              // Menambahkan folder provider di dalam data
│   │   │   │       └── berita_provider.dart          // File provider untuk berita
│   │   │   ├── domain/
│   │   │   │   │   
│   │   │   │   ├── repositories/
│   │   │   │   │   └── news_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_popular_news.dart        // (BeritaPopuler)
│   │   │   │       ├── get_recommended_news.dart      // (BeritaRekomendasi)
│   │   │   │       ├── get_latest_news.dart           // (BeritaTerkini)
│   │   │   │       ├── get_related_news.dart          // (BeritaTerkait)
│   │   │   │       ├── get_most_commented_news.dart   // (KomentarTerbanyak)
│   │   │   │       └── get_popular_tags.dart          // (TagPopuler)
│   │   │   └── presentation/
│   │   │       ├── ui/                   // Tampilan UI
│   │   │       │   ├── screens/
│   │   │       │   │   ├── home_screen.dart           // (fragment_home.xml)
│   │   │       │   │   ├── home_popular_screen.dart    // (fragment_home_populer.xml)
│   │   │       │   │   ├── home_latest_screen.dart     // (fragment_home_terbaru.xml)
│   │   │       │   │   └── detail_article_screen.dart  // (fragment_detail_artikel.xml)
│   │   │       │   └── widgets/
│   │   │       │       ├── berita_terkait_item.dart    // (item_berita_terkait.xml)
│   │   │       │       ├── berita_populer_item.dart     // (item_berita_populer.xml)
│   │   │       │       ├── berita_rekomendasi_item.dart // (item_berita_rekomendasi.xml)
│   │   │       │       ├── komentar_terbanyak_item.dart  // (item_komentar_terbanyak.xml)
│   │   │       │       ├── tag_populer_item.dart        // (item_tag_populer.xml)
│   │   │       │       └── berita_terkini_item.dart      // (item_berita_terkini.xml)
│   │   │       └── logic/                // Logika Beranda
│   │   │           ├── berita_terkait_viewmodel.dart
│   │   │           ├── berita_populer_viewmodel.dart
│   │   │           ├── berita_rekomendasi_viewmodel.dart
│   │   │           ├── komentar_terbanyak_viewmodel.dart
│   │   │           ├── tag_populer_viewmodel.dart
│   │   │           └── berita_terkini_viewmodel.dart
│   │
│   │   ├── comments/                     // Fitur Komentar Artikel
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── comments_remote_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── comment_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── comments_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── comment.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── comments_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       └── get_comments.dart
│   │   │   └── presentation/
│   │   │       ├── ui/                   // Tampilan komentar
│   │   │       │   ├── screens/
│   │   │       │   │   └── comments_screen.dart      // (fragment_komentar.xml)
│   │   │       │   └── widgets/
│   │   │       │       └── comment_item.dart         // (item_komentar.xml)
│   │   │       └── logic/                // Logika komentar
│   │   │           └── comments_viewmodel.dart
│   │   ├── notifications/                // Fitur Notifikasi
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── notification_remote_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── notification_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── notification_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── notification.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── notification_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       └── get_notifications.dart
│   │   │   └── presentation/
│   │   │       ├── ui/                   // Tampilan notifikasi
│   │   │       │   └── screens/
│   │   │       │       └── notifications_screen.dart // (fragment_notifikasi.xml)
│   │   │       ├── widgets/
│   │   │       │   └── notification_item.dart        // (item_notifikasi.xml)
│   │   │       └── logic/
│   │   │           └── notifications_viewmodel.dart
│   │   │
│   │   ├── profile/                      // Fitur Profil
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── profile_remote_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── profile_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── profile_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── profile.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── profile_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       └── get_profile.dart
│   │   │   └── presentation/
│   │   │       ├── ui/                   // Tampilan profil
│   │   │       │   └── screens/
│   │   │       │       └── profile_screen.dart      // (fragment_profile.xml)
│   │   │       └── logic/
│   │   │           └── profile_viewmodel.dart
│   │   │
│   │   ├── reaksi/                       // Fitur Reaksi & Bookmark
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── reaksi_remote_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── reaksi_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── reaksi_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── reaksi.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── reaksi_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_bookmarked_news.dart      // Bookmark
│   │   │   │       ├── get_liked_news.dart             // Like
│   │   │   │       └── get_view_count.dart             // ViewCount
│   │   │   └── presentation/
│   │   │       ├── ui/                   // Tampilan reaksi/bookmark
│   │   │       │   └── screens/
│   │   │       │       └── bookmarked_news_screen.dart // (fragment_daftar_berita_bookmark.xml)
│   │   │       ├── widgets/
│   │   │       │   ├── bookmark_item.dart           // (item_berita_bookmark.xml)
│   │   │       │   └── like_item.dart               // (item_berita_like.xml)
│   │   │       └── logic/
│   │   │           ├── bookmark_viewmodel.dart
│   │   │           ├── daftar_berita_bookmark_viewmodel.dart
│   │   │           ├── daftar_berita_like_viewmodel.dart
│   │   │           └── view_count_viewmodel.dart
│   │   │
│   │   ├── report/                       // Fitur Pelaporan
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── report_remote_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── report_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── report_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── report.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── report_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       └── submit_report.dart
│   │   │   └── presentation/
│   │   │       ├── ui/                   // Tampilan dialog pelaporan
│   │   │       │   └── dialogs/
│   │   │       │       └── report_dialog.dart       // (fragment_report_dialog.xml)
│   │   │       └── logic/
│   │   │           └── report_viewmodel.dart
│   │   │
│   │   ├── search/                       // Fitur Pencarian
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── search_remote_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── search_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── search_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── search.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── search_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       └── perform_search.dart
│   │   │   └── presentation/
│   │   │       ├── ui/                   // Tampilan pencarian
│   │   │       │   ├── screens/
│   │   │       │   │   ├── search_screen.dart        // (fragment_search.xml)
│   │   │       │   │   └── search_results_screen.dart  // (fragment_search_results.xml)
│   │   │       │   └── widgets/
│   │   │       │       └── search_result_item.dart     // (item_riwayat_search.xml, dsb.)
│   │   │       └── logic/
│   │   │           └── search_viewmodel.dart
│   │   │
│   │   ├── welcome/                      // Fitur Onboarding & Welcome Page
│   │   │   └── presentation/
│   │   │       ├── ui/
│   │   │       │   ├── screens/
│   │   │       │   │   ├── splash_screen.dart        // Splash screen (baru)
│   │   │       │   │   ├── welcome_screen.dart         // (fragment_welcome.xml)
│   │   │       │   │   ├── welcome_page1.dart          // (fragment_welcome_page_1.xml)
│   │   │       │   │   ├── welcome_page2.dart          // (fragment_welcome_page_2.xml)
│   │   │       │   │   └── welcome_page3.dart          // (fragment_welcome_page_3.xml)
│   │   │       └── logic/
│   │   │           ├── splash_viewmodel.dart         // ViewModel untuk Splash Screen
│   │   │           └── welcome_viewmodel.dart
│   │   │
│   │   └── settings/                     // Fitur Settings (setara dengan fitur lainnya)
│   │       └── presentation/
│   │           ├── ui/
│   │           │   ├── screens/
│   │           │   │   ├── settings_screen.dart             // Layar utama Settings
│   │           │   │   ├── hubungi_screen.dart               // (HubungiFragment.kt)
│   │           │   │   ├── keamanan_screen.dart              // (KeamananFragment.kt)
│   │           │   │   ├── pusat_bantuan_screen.dart           // (PusatBantuanFragment.kt)
│   │           │   │   ├── setting_notifikasi_screen.dart      // (SettingNotifikasiFragment.kt)
│   │           │   │   ├── tentang_screen.dart                 // (TentangFragment.kt)
│   │           │   │   └── umum_screen.dart                    // (UmumFragment.kt)
│   │           │   └── dialogs/                               // Jika ada dialog khusus Settings
│   │           └── logic/
│   │               ├── hubungi_viewmodel.dart              // (HubungiViewModel.kt)
│   │               ├── keamanan_viewmodel.dart             // (KeamananViewModel.kt)
│   │               ├── settings_viewmodel.dart        // (PengaturanAkunViewModel.kt)
│   │               ├── pusat_bantuan_viewmodel.dart          // (opsional)
│   │               ├── setting_notifikasi_viewmodel.dart     // (opsional)
│   │               ├── tentang_viewmodel.dart                // (opsional)
│   │               └── umum_viewmodel.dart                  // (UmumViewModel.kt)
│   │
│   └── navigation/
│       └── app_router.dart               // Konfigurasi routing/navigasi aplikasi
├── main.dart                             // Entry point aplikasi
├── pubspec.yaml                          // Dependency dan asset config
└── README.md
│   │
│   ├── main.dart                        // Entry Point Aplikasi (MainActivity)
└── pubspec.yaml                         // Konfigurasi Proyek
```
