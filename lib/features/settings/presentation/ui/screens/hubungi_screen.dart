import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mediaexplant/core/utils/app_colors.dart'; // Pastikan path sudah sesuai

/// Entry point of the application.
void main() {
  runApp(const MyApp());
}

/// The main application widget that sets up the MaterialApp.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  title: 'Hubungi Kami',
  theme: ThemeData(
    primaryColor: AppColors.primary,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      iconTheme: const IconThemeData(color: Colors.white), // Ubah warna ikon di AppBar
    ),
  ),
  home: const HubungiScreen(),
);
  }
}

/// The HubungiScreen widget represents the main contact screen.
/// It uses a [DefaultTabController] to separate the contact form and contact info
/// into two distinct tabs for a cleaner, more user-friendly design.
class HubungiScreen extends StatelessWidget {
  const HubungiScreen({super.key});

  /// Helper method that launches a given [uri] using the url_launcher package.
  /// If launching fails, it shows a SnackBar with an error message.
  Future<void> _launchUrl(BuildContext context, Uri uri) async {
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch ${uri.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: one for the message form and one for contact info.
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hubungi Kami'),
          backgroundColor: AppColors.primary,
          // TabBar added at the bottom of the AppBar.
bottom: TabBar(
  labelColor: Colors.white,
  unselectedLabelColor: Colors.white70,
  indicatorColor: Colors.white,
  tabs: const [
    Tab(
      icon: Icon(Icons.message),
      text: 'Kirim Pesan',
    ),
    Tab(
      icon: Icon(Icons.info),
      text: 'Informasi Kontak',
    ),
  ],
),

        ),
        body: TabBarView(
          children: [
            // First tab: Contact form without a Card wrapper.
            const ContactFormTab(),
            // Second tab: Contact information.
            ContactInfoTab(launchUrl: _launchUrl),
          ],
        ),
      ),
    );
  }
}

/// The ContactFormTab widget displays the "Kirim Pesan" form without a Card.
/// It is wrapped in a [SingleChildScrollView] with padding for a clean design.
class ContactFormTab extends StatelessWidget {
  const ContactFormTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Header icon for the contact form.
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            child: Icon(
              Icons.contact_mail,
              size: 120,
              color: AppColors.primary,
            ),
          ),
          // The contact form is now displayed directly without a Card.
          const _ContactForm(),
          // Additional spacing for aesthetics.
          const SizedBox(height: 16),
          // A small footer note (optional).
          Text(
            'Kami akan segera merespons pesan Anda.',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

/// The ContactInfoTab widget displays a list of contact information cards.
/// Each card is tappable to perform an action, such as launching the phone dialer,
/// opening the email client with a prefilled subject, or opening the maps app.
class ContactInfoTab extends StatelessWidget {
  /// Function to launch external URLs.
  final Future<void> Function(BuildContext, Uri) launchUrl;

  const ContactInfoTab({super.key, required this.launchUrl});

  /// Builds a reusable contact card widget with an icon, title, subtitle, and an optional tap handler.
  Widget _buildContactCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 30),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: AppColors.text.withOpacity(0.8),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Header icon for the contact info section.
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            child: Icon(
              Icons.info_outline,
              size: 120,
              color: AppColors.primary,
            ),
          ),
          // Phone card: tapping launches the phone dialer.
          _buildContactCard(
            context: context,
            icon: Icons.phone,
            iconColor: AppColors.primary,
            title: 'Telepon',
            subtitle: '+62 812 3456 7890',
            onTap: () async {
              final Uri phoneUri = Uri(
                scheme: 'tel',
                path: '+6281234567890',
              );
              await launchUrl(context, phoneUri);
            },
          ),
          // Email card: tapping opens the email client with a prefilled subject.
          _buildContactCard(
            context: context,
            icon: Icons.email,
            iconColor: Colors.red,
            title: 'Email',
            subtitle: 'persmaexplant@gmail.com',
            onTap: () async {
              final Uri emailUri = Uri(
                scheme: 'mailto',
                path: 'persmaexplant@gmail.com',
                queryParameters: {
                  'subject': 'Hubungi Kami',
                },
              );
              await launchUrl(context, emailUri);
            },
          ),
          // Address card: tapping opens the maps application with the provided URL.
          _buildContactCard(
            context: context,
            icon: Icons.location_on,
            iconColor: Colors.green,
            title: 'Alamat',
            subtitle: 'Student Activity Center Polije (Omah Explant), Jember',
            onTap: () async {
              const String mapsUrl = 'https://maps.app.goo.gl/axfMA8MdvTCC6cNj7';
              final Uri mapsUri = Uri.parse(mapsUrl);
              await launchUrl(context, mapsUri);
            },
          ),
          // Extra spacing for a polished look.
          const SizedBox(height: 16),
          // Optional footer text.
          Text(
            'Kami tersedia selama 08:00 - 17:00 WIB',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

/// Stateful widget representing the contact form where users can send a message.
/// This widget handles input validation and simulates sending the message.
class _ContactForm extends StatefulWidget {
  const _ContactForm({super.key});

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

/// State class for [_ContactForm] that manages form inputs and submission logic.
class _ContactFormState extends State<_ContactForm> {
  // Global key for the form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for the text fields.
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pesanController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when no longer needed.
    _namaController.dispose();
    _emailController.dispose();
    _pesanController.dispose();
    super.dispose();
  }

  /// Simulates sending a message. If the form is valid, displays a SnackBar and clears the fields.
  void _sendMessage() {
    if (_formKey.currentState!.validate()) {
      // Simulate a delay for sending a message (e.g., API call).
      Future.delayed(const Duration(milliseconds: 500), () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesan telah terkirim!')),
        );
        // Clear the fields after sending.
        _namaController.clear();
        _emailController.clear();
        _pesanController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build the contact form.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form header text.
          Text(
            'Kirim Pesan',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 16),
          // Input field for name.
          TextFormField(
            controller: _namaController,
            decoration: const InputDecoration(
              labelText: 'Nama',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Mohon masukkan nama Anda';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Input field for email.
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Mohon masukkan email Anda';
              }
              // Simple email validation.
              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                return 'Email tidak valid';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Input field for the message.
          TextFormField(
            controller: _pesanController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Pesan',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Mohon masukkan pesan Anda';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          // Button to submit the form.
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _sendMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Kirim Pesan',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
