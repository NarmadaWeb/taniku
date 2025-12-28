import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<AppProvider>(context).userProfile;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Taniku',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'Halo, ${userProfile.name}',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_outlined, size: 28),
                      ),
                      Positioned(
                        right: 12,
                        top: 12,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),

              // NO WEATHER (Removed as per requirement)

              // Status Tanaman (My Plant Status)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Status Tanaman',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                        // Navigate to Sawahku via BottomNav (by changing index in parent) or direct push
                        // Since we are inside a tab view, best to switch tab or push detail.
                        // For simplicity, let's assume Sawahku is tab 2.
                        // But here we can't easily switch the parent tab index without a callback or provider.
                        // Let's just push the Sawahku Screen as a standalone page if needed,
                        // BUT Sawahku is a main tab.
                        // We will rely on the user using the bottom nav for now, or use a global key/provider to switch tab.
                    },
                    child: const Text('Detail', style: TextStyle(color: AppColors.primary)),
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                   // Navigate to Sawahku Tab logic would go here
                },
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/home_plant.jpg'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Varietas ${userProfile.variety}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const Text(
                              'Musim Tanam 2',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Hari ke-45 (Vegetatif)',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '40% Selesai',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            LinearProgressIndicator(
                              value: 0.4,
                              backgroundColor: Colors.white24,
                              color: AppColors.primary,
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Quick Access
              const Text(
                'Akses Cepat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQuickAccessItem(
                    context,
                    icon: Icons.pest_control,
                    label: 'Diagnosa',
                    color: AppColors.primary,
                    onTap: () {
                         Provider.of<AppProvider>(context, listen: false).resetDiagnosis();
                         Navigator.pushNamed(context, '/diagnosis/step1');
                    },
                  ),
                  _buildQuickAccessItem(
                    context,
                    icon: Icons.menu_book,
                    label: 'Pustaka',
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    iconColor: AppColors.primary,
                    onTap: () {
                        // Switch to Pustaka Tab (implemented by parent usually)
                        // Or push Pustaka Screen
                    },
                  ),
                  _buildQuickAccessItem(
                    context,
                    icon: Icons.calculate,
                    label: 'Kalkulator',
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    iconColor: AppColors.primary,
                    onTap: () {
                        Navigator.pushNamed(context, '/calculator');
                    },
                  ),
                  _buildQuickAccessItem(
                    context,
                    icon: Icons.forum,
                    label: 'Forum',
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    iconColor: AppColors.primary,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: isDark ? Border.all(color: Colors.white10) : Border.all(color: Colors.grey.shade100),
            ),
            child: Icon(
              icon,
              size: 30,
              color: iconColor ?? Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
