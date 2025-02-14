```
MediaExplant/
├── android/
├── ios/
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_routes.dart
│   ├── errors/
│   │   └── exceptions.dart
│   ├── network/
│   │   ├── api_client.dart
│   │   └── network_info.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── text_styles.dart
│   ├── utils/
│   │   ├── date_utils.dart         // Menyesuaikan DateUtils.kt
│   │   └── email_sender.dart       // Menyesuaikan EmailSender.kt
│   └── widgets/
│       └── common_widgets.dart
│
├── features/
│   ├── auth/                          // Autentikasi & Manajemen Akun
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
│   │       ├── screens/
│   │       │   ├── sign_in_screen.dart              // Menyesuaikan SignInFragment.kt
│   │       │   ├── sign_up_screen.dart              // Menyesuaikan SignUpFragment.kt
│   │       │   ├── sign_up_input_screen.dart        // Menyesuaikan SignUpInputFragment.kt
│   │       │   └── reset_password_screen.dart        // Menyesuaikan ResetPasswordFragment.kt
│   │       ├── dialogs/
│   │       │   ├── change_password_dialog.dart       // ChangePasswordDialog.kt
│   │       │   ├── confirm_change_email_dialog.dart  // KonfirmasiUbahEmail.kt
│   │       │   ├── forgot_password_confirm_email_dialog.dart  
│   │       │   │   // LupaPasswordKonfirmasiEmailDialog.kt
│   │       │   ├── forgot_password_verify_email_dialog.dart  
│   │       │   │   // LupaPasswordVerifEmailDialog.kt
│   │       │   └── sign_up_verify_email_dialog.dart  // SignUpVerifikasiEmailDialog.kt
│   │       └── viewmodels/                          // Mengganti ViewModel Kotlin dengan state management (BLoC, Provider, dll)
│   │           ├── lupa_password_viewmodel.dart     // LupaPasswordViewModel.kt
│   │           ├── reset_password_viewmodel.dart    // ResetPasswordViewModel.kt
│   │           ├── sign_in_viewmodel.dart           // SignInViewModel.kt
│   │           ├── sign_up_input_viewmodel.dart     // SignUpInputViewModel.kt
│   │           └── sign_up_viewmodel.dart           // SignUpViewModel.kt
│   │
│   ├── home/                          // Beranda & Tampilan Berita
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
│   │   │       ├── get_popular_news.dart           // BeritaPopuler
│   │   │       ├── get_recommended_news.dart         // BeritaRekomendasi
│   │   │       ├── get_latest_news.dart              // BeritaTerkini
│   │   │       ├── get_related_news.dart             // BeritaTerkait
│   │   │       ├── get_most_commented_news.dart      // KomentarTerbanyak
│   │   │       └── get_popular_tags.dart             // TagPopuler
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── home_screen.dart                 // HomeFragment.kt
│   │       │   ├── home_popular_screen.dart         // HomePopulerFragment.kt
│   │       │   ├── home_latest_screen.dart          // HomeTerbaruFragment.kt
│   │       │   └── detail_article_screen.dart       // DetailArtikelFragment.kt
│   │       ├── widgets/
│   │       │   ├── berita_terkait_item.dart         // BeritaTerkaitAdapter.kt
│   │       │   ├── berita_populer_item.dart          // BeritaPopulerAdapter.kt
│   │       │   ├── berita_rekomendasi_item.dart      // BeritaRekomendasiAdapter.kt
│   │       │   ├── komentar_terbanyak_item.dart       // KomentarTerbanyakAdapter.kt
│   │       │   ├── tag_populer_item.dart             // TagPopulerAdapter.kt
│   │       │   └── berita_terkini_item.dart           // BeritaTerkiniAdapater.kt
│   │       └── viewmodels/
│   │           ├── berita_terkait_viewmodel.dart      // BeritaTerkaitViewModel.kt
│   │           ├── berita_populer_viewmodel.dart      // BeritaPopulerViewModel.kt
│   │           ├── berita_rekomendasi_viewmodel.dart  // BeritaRekomendasiViewModel.kt
│   │           ├── komentar_terbanyak_viewmodel.dart   // KomentarTerbanyakViewModel.kt
│   │           ├── tag_populer_viewmodel.dart         // TagPopulerViewModel.kt
│   │           └── berita_terkini_viewmodel.dart        // BeritaTerkiniViewModel.kt
│   │
│   ├── comments/                      // Komentar Artikel
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
│   │       ├── screens/
│   │       │   └── comments_screen.dart           // KomentarArtikelFragment.kt
│   │       ├── dialogs/
│   │       │   └── comment_dialog.dart             // KomentarDialogFragment.kt
│   │       ├── widgets/
│   │       │   └── comment_item.dart               // KomentarArtikelAdapter.kt (item)
│   │       └── viewmodels/
│   │           └── komentar_viewmodel.dart         // KomentarViewModel.kt
│   │
│   ├── license/                       // Lisensi
│   │   └── presentation/
│   │       └── license_screen.dart                // LicenseFragment.kt
│   │
│   ├── article_management/            // Manajemen Artikel (Penulis)
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── article_remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── article_management_model.dart
│   │   │   └── repositories/
│   │   │       └── article_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── article_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── article_repository.dart
│   │   │   └── usecases/
│   │   │       ├── create_article.dart           // BuatArtikelFragment.kt
│   │   │       ├── get_draft_articles.dart         // DrafPenulisFragment.kt
│   │   │       ├── get_under_review_articles.dart   // DalamPeninjauanFragment.kt
│   │   │       ├── confirm_publication.dart         // KonfirmasiPublikasiFragment.kt
│   │   │       └── get_published_articles.dart      // PublishedArtikelFragment.kt
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── create_article_screen.dart       // BuatArtikelFragment.dart
│   │       │   ├── draft_articles_screen.dart       // DrafPenulisFragment.dart
│   │       │   ├── under_review_screen.dart         // DalamPeninjauanFragment.dart
│   │       │   ├── confirm_publication_screen.dart    // KonfirmasiPublikasiFragment.dart
│   │       │   ├── manage_articles_screen.dart      // ManajemenArtikelFragment.dart
│   │       │   └── published_articles_screen.dart   // PublishedArtikelFragment.dart
│   │       ├── widgets/
│   │       │   ├── dalam_peninjauan_item.dart       // Adapter untuk DalamPeninjauan
│   │       │   ├── draft_article_item.dart          // DrafPenulisAdapter.kt
│   │       │   └── published_article_item.dart      // PublishedArtikelAdapter.kt
│   │       └── viewmodels/
│   │           ├── dalam_peninjauan_viewmodel.dart   // DalamPeninjauanViewModel.kt
│   │           ├── draft_articles_viewmodel.dart     // DrafPenulisViewModel.kt
│   │           └── published_article_viewmodel.dart  // PublishedArtikelViewModel.kt
│   │
│   ├── reviewer_management/           // Manajemen Reviewer
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── reviewer_remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── reviewer_model.dart
│   │   │   └── repositories/
│   │   │       └── reviewer_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── reviewer.dart
│   │   │   ├── repositories/
│   │   │   │   └── reviewer_repository.dart
│   │   │   └── usecases/
│   │   │       └── get_under_review_reviewer.dart  // Mengambil data reviewer dalam peninjauan
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── under_review_reviewer_screen.dart  // DalamPeninjauanReviewerFragment.kt
│   │       │   └── reviewer_management_screen.dart    // ManajemenReviewerFragment.kt
│   │       ├── widgets/
│   │       │   ├── reviewer_item.dart                 // Adapter: DalamPeninjauanReviewerAdapter.kt
│   │       │   └── reviewer_pager.dart                // ViewPagerAdapterReviewer.kt
│   │       └── viewmodels/
│   │           └── under_review_reviewer_viewmodel.dart  // DalamPeninjauanReviewerViewModel.kt
│   │
│   ├── notifications/                 // Notifikasi
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
│   │       ├── screens/
│   │       │   └── notifications_screen.dart        // NotifikasiFragment.kt
│   │       ├── widgets/
│   │       │   └── notification_item.dart           // NotifikasiAdapter.kt (item)
│   │       └── viewmodels/
│   │           └── notifications_viewmodel.dart     // NotifikasiViewModel.kt
│   │
│   ├── profile/                       // Profil & Pengaturan Akun
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
│   │   │       ├── get_profile.dart
│   │   │       └── update_profile.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── profile_screen.dart             // ProfileFragment.kt
│   │       │   ├── settings_screen.dart            // Menggabungkan PengaturanAkunFragment.kt, KeamananFragment.kt, PusatBantuanFragment.kt, SettingNotifikasiFragment.kt, TentangFragment.kt, UmumFragment.kt, HubungiFragment.kt
│   │       │   └── contact_us_screen.dart          // HubungiFragment.kt (jika dipisah)
│   │       ├── dialogs/
│   │       │   └── logout_confirmation_dialog.dart // KonfirmasiKeluarDialog.kt
│   │       └── viewmodels/
│   │           └── profile_viewmodel.dart           // ProfileViewModel.kt
│   │
│   ├── reaksi/                        // Reaksi & Bookmark
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
│   │   │       ├── get_bookmarked_news.dart         // Bookmark
│   │   │       ├── get_liked_news.dart              // Like
│   │   │       └── get_view_count.dart              // ViewCount
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── bookmarked_news_screen.dart      // DaftarBeritaBookmarkFragment.kt
│   │       ├── widgets/
│   │       │   ├── bookmark_item.dart               // DaftarBeritaBookmarkAdapter.dart
│   │       │   └── like_item.dart                   // DaftarBeritaLikeAdapter.dart
│   │       └── viewmodels/
│   │           ├── bookmark_viewmodel.dart           // BookmarkViewModel.kt
│   │           ├── daftar_berita_bookmark_viewmodel.dart  // DaftarBeritaBookmarkViewModel.kt
│   │           ├── daftar_berita_like_viewmodel.dart       // DaftarBeritaLikeViewModel.kt
│   │           └── view_count_viewmodel.dart          // ViewCountViewModel.kt
│   │
│   ├── report/                        // Report / Pelaporan
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
│   │       ├── dialogs/
│   │       │   └── report_dialog.dart               // ReportDialogFragment.kt
│   │       └── viewmodels/
│   │           └── report_viewmodel.dart            // ReportViewModel.kt
│   │
│   ├── search/                        // Pencarian
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
│   │       ├── screens/
│   │       │   ├── search_screen.dart             // SearchFragment.kt
│   │       │   └── search_results_screen.dart       // SearchResultsFragment.kt
│   │       ├── widgets/
│   │       │   └── search_result_item.dart          // Item Search Result
│   │       └── viewmodels/
│   │           └── search_viewmodel.dart            // SearchViewModel.kt
│   │
│   ├── welcome/                       // Onboarding & Welcome Page
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── welcome_screen.dart            // WelcomeFragment.kt
│   │       │   ├── welcome_page1.dart             // WelcomePage1Fragment.kt
│   │       │   ├── welcome_page2.dart             // WelcomePage2Fragment.kt
│   │       │   └── welcome_page3.dart             // WelcomePage3Fragment.kt
│   │       └── viewmodels/
│   │           └── welcome_viewmodel.dart         // WelcomeViewModel.kt
│   │
│   └── navigation/                    // Navigasi & Routing
│       └── app_router.dart
│
└── main.dart                           // Entry point aplikasi
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
