import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final user = appProvider.userProfile;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade100),
                boxShadow: [
                  if (!isDark) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
                ]
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(user.location, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showEditProfile(context, appProvider),
                    child: const Text('Edit', style: TextStyle(color: AppColors.primary)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader(context, 'Umum'),
            _buildSettingItem(
              context,
              icon: Icons.history,
              title: 'Riwayat Analisis',
              onTap: () => Navigator.pushNamed(context, '/history'),
            ),
            _buildSettingItem(
              context,
              icon: Icons.dark_mode,
              title: 'Mode Gelap',
              trailing: Switch(
                value: appProvider.isDarkMode,
                activeColor: AppColors.primary,
                onChanged: (val) => appProvider.toggleDarkMode(),
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Lainnya'),
            _buildSettingItem(
              context,
              icon: Icons.help_outline,
              title: 'Bantuan & FAQ',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen())),
            ),
             _buildSettingItem(
              context,
              icon: Icons.info_outline,
              title: 'Tentang Taniku',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen())),
            ),
             _buildSettingItem(
              context,
              icon: Icons.bug_report,
              title: 'Lapor Bug',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BugReportScreen())),
            ),

             const SizedBox(height: 32),
             SizedBox(
               width: double.infinity,
               child: OutlinedButton.icon(
                 onPressed: () => Navigator.pushReplacementNamed(context, '/welcome'),
                 icon: const Icon(Icons.logout, color: Colors.red),
                 label: const Text('Keluar', style: TextStyle(color: Colors.red)),
                 style: OutlinedButton.styleFrom(
                   padding: const EdgeInsets.symmetric(vertical: 16),
                   side: const BorderSide(color: Colors.red, width: 1),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                 ),
               ),
             )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, {required IconData icon, required String title, VoidCallback? onTap, Widget? trailing}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade100),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.primary.withOpacity(0.2) : const Color(0xFFE7F3EB),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: isDark ? AppColors.primary : const Color(0xFF166534)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  void _showEditProfile(BuildContext context, AppProvider provider) {
    final nameController = TextEditingController(text: provider.userProfile.name);
    final locController = TextEditingController(text: provider.userProfile.location);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, top: 20, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Edit Profil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: locController,
              decoration: const InputDecoration(labelText: 'Lokasi', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Simpan',
              onPressed: () {
                // Keep other fields same for now
                final current = provider.userProfile;
                provider.updateProfile(UserProfile(
                  name: nameController.text,
                  location: locController.text,
                  landArea: current.landArea,
                  variety: current.variety,
                  plantingDate: current.plantingDate
                ));
                Navigator.pop(ctx);
              }
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bantuan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Contact Expert
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                 color: Theme.of(context).brightness == Brightness.dark ? AppColors.surfaceDark : Colors.white,
                 borderRadius: BorderRadius.circular(12),
                 border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Butuh bantuan ahli?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Hubungi tim pakar Taniku langsung untuk konsultasi masalah tanaman Anda.'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {}, // Launch WA
                    icon: const Icon(Icons.chat),
                    label: const Text('Hubungi via WhatsApp'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.black),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Align(alignment: Alignment.centerLeft, child: Text('Pertanyaan Populer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(height: 12),
            _buildFaqItem('Bagaimana cara mendeteksi hama wereng?', 'Anda dapat melakukan pengamatan rutin setiap pagi hari di pangkal batang padi. Jika terlihat nimfa atau serangga dewasa melompat saat tanaman ditepuk, segera lakukan tindakan.'),
            _buildFaqItem('Kapan waktu terbaik memupuk?', 'Pemupukan dasar dilakukan 0-7 HST. Susulan pertama 14-21 HST.'),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String q, String a) {
    return ExpansionTile(
      title: Text(q, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(a),
        )
      ],
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset('assets/images/welcome_hero.jpg', fit: BoxFit.cover),
            ),
            leading: IconButton(
              icon: const CircleAvatar(backgroundColor: Colors.black26, child: Icon(Icons.arrow_back, color: Colors.white)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: const [
                  Icon(Icons.grass, size: 80, color: AppColors.primary),
                  SizedBox(height: 16),
                  Text('Taniku', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('v1.0.0'),
                  SizedBox(height: 24),
                  Text('Taniku adalah aplikasi sistem pakar yang dirancang untuk membantu petani padi dalam mendiagnosa penyakit, memberikan solusi penanganan hama, serta menyediakan panduan budidaya modern untuk hasil yang optimal.', textAlign: TextAlign.center),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BugReportScreen extends StatelessWidget {
  const BugReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lapor Bug')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12)
              ),
              child: Row(
                children: const [
                  Icon(Icons.bug_report, color: Colors.orange),
                  SizedBox(width: 12),
                  Expanded(child: Text('Temukan Bug? Bantu kami meningkatkan Taniku.'))
                ],
              ),
            ),
            const SizedBox(height: 24),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Judul Masalah',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
             const TextField(
              decoration: InputDecoration(
                labelText: 'Deskripsi Lengkap',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
            ),
            const Spacer(),
            CustomButton(text: 'Kirim Laporan', onPressed: () => Navigator.pop(context), icon: Icons.send),
          ],
        ),
      ),
    );
  }
}
