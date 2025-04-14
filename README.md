

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
│   │
│   │   ├── notifications/                // Fitur Pemberitahuan
│   │   ├── profile/                      // Fitur Profil Pengguna
│   │   ├── report/                       // Fitur Pelaporan
│   │   ├── search/                       // Fitur Pencarian
│   │   ├── settings/                     // Fitur Pengaturan
│   │   └── welcome/                      // Fitur Penyambutan
│   │
│   ├── main.dart                        // Entry Point Aplikasi (MainActivity)
└── pubspec.yaml                         // Konfigurasi Proyek
