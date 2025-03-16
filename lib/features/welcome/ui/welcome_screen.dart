import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Layar Welcome untuk aplikasi MediaExplant yang menampilkan animasi, background gradient,
/// elemen dekoratif, dan konten informasi yang menarik.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true; // Indikator loading untuk pengecekan welcome status
  late AnimationController _animationController; // Controller animasi
  late Animation<double> _fadeAnimation; // Animasi fade untuk konten

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller animasi dengan durasi 2 detik
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Konfigurasi animasi fade dari 0 (transparan) ke 1 (opaque)
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Mulai animasi fade
    _animationController.forward();

    // Lakukan pengecekan apakah welcome screen sudah pernah ditampilkan sebelumnya
    _checkWelcomeStatus();
  }

  /// Mengecek status apakah welcome screen sudah pernah ditampilkan.
  Future<void> _checkWelcomeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasSeenWelcome = prefs.getBool('hasSeenWelcome') ?? false;
    if (hasSeenWelcome) {
      // Jika sudah pernah, langsung navigasi ke halaman home
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Jika belum, set loading menjadi false untuk menampilkan welcome screen
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Menandai bahwa welcome screen telah ditampilkan.
  Future<void> _markWelcomeSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenWelcome', true);
  }

  @override
  void dispose() {
    // Hentikan controller animasi saat widget dihancurkan
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Jika masih loading, tampilkan indikator loading
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Tampilan utama welcome screen dengan background gradient dan animasi
    return Scaffold(
      body: Container(
        // Background gradient yang menawan
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4A90E2),
              Color(0xFF50E3C2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Elemen dekoratif background berupa lingkaran transparan
              const Positioned(
                top: -60,
                right: -60,
                child: DecoratedCircle(
                  diameter: 150,
                  color: Colors.white24,
                ),
              ),
              const Positioned(
                bottom: -80,
                left: -80,
                child: DecoratedCircle(
                  diameter: 200,
                  color: Colors.white24,
                ),
              ),
              // Konten utama welcome screen
              Column(
                children: [
                  // Header: Logo aplikasi dengan animasi fade
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: const AnimatedLogo(
                        imagePath: 'assets/logo.png',
                        size: 120,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Konten informasi sambutan dengan animasi fade
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: const WelcomeContent(),
                    ),
                  ),
                  // Tombol "Get Started" di bagian bawah
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Tandai bahwa welcome screen sudah dilihat dan navigasi ke halaman home
                        await _markWelcomeSeen();
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Get Started',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget untuk menampilkan logo aplikasi dengan efek bayangan.
class AnimatedLogo extends StatelessWidget {
  final String imagePath;
  final double size;

  const AnimatedLogo({
    Key? key,
    required this.imagePath,
    this.size = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Pastikan asset logo sudah ditambahkan di pubspec.yaml
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
    );
  }
}

/// Widget dekoratif untuk membuat lingkaran dengan warna dan ukuran yang ditentukan.
class DecoratedCircle extends StatelessWidget {
  final double diameter;
  final Color color;

  const DecoratedCircle({
    Key? key,
    required this.diameter,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Widget untuk menampilkan konten informasi sambutan, termasuk judul, deskripsi,
/// dan tombol "Learn More" yang menampilkan dialog penjelasan.
class WelcomeContent extends StatelessWidget {
  const WelcomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SingleChildScrollView untuk memastikan konten dapat discroll pada perangkat kecil
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Judul sambutan menggunakan headlineMedium
          Text(
            'Welcome to MediaExplant!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // Deskripsi sambutan dengan penjelasan lebih detail
          Text(
            'Discover news and updates tailored just for you. '
            'Stay informed with our personalized news feed and enjoy an innovative experience '
            'that brings the latest information right at your fingertips. '
            'Experience a blend of modern design and intuitive navigation that makes staying updated fun and effortless.',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white70,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          // Tombol "Learn More" sebagai opsi tambahan tanpa mengubah alur navigasi utama
          ElevatedButton(
            onPressed: () {
              // Tampilkan dialog informasi saat tombol ditekan
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: Text(
                    'About MediaExplant',
                    style:
                        Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.blueAccent,
                            ),
                  ),
                  content: Text(
                    'MediaExplant is your personalized gateway to the latest news and trends. '
                    'Our mission is to provide you with a seamless and engaging experience that keeps you informed about the world around you.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Close',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: Text(
              'Learn More',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
