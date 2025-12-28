import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/widgets.dart';

class SawahkuScreen extends StatelessWidget {
  const SawahkuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppProvider>(context).userProfile;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Timeline Data Generator
    // Start date = user.plantingDate
    final startDate = user.plantingDate ?? DateTime.now();

    // Calculate dates
    final vegetatifEnd = startDate.add(const Duration(days: 45));
    final generatifEnd = vegetatifEnd.add(const Duration(days: 40));
    final harvestDate = generatifEnd.add(const Duration(days: 30));

    // Days remaining logic (simplified)
    final now = DateTime.now();
    final daysSincePlanting = now.difference(startDate).inDays;
    final daysToHarvest = harvestDate.difference(now).inDays;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Tanam'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.calendar_month), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [AppColors.surfaceDark, Colors.black]
                      : [Colors.white, const Color(0xFFF0FDF4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                ],
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text('Perkiraan Panen Raya', style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.bold)),
                           const SizedBox(height: 4),
                           Text(
                             _formatDate(harvestDate),
                             style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                           ),
                         ],
                       ),
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                         decoration: BoxDecoration(
                           color: AppColors.primary.withOpacity(0.15),
                           borderRadius: BorderRadius.circular(8),
                         ),
                         child: Text(
                           '± $daysToHarvest Hari Lagi',
                           style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 12),
                         ),
                       )
                     ],
                   ),
                   const SizedBox(height: 24),
                   // Status Air (Water Status)
                   Container(
                     padding: const EdgeInsets.all(12),
                     decoration: BoxDecoration(
                       color: isDark ? Colors.black26 : Colors.white,
                       borderRadius: BorderRadius.circular(12),
                       border: Border.all(color: Colors.blue.withOpacity(0.2)),
                     ),
                     child: Row(
                       children: [
                         Container(
                           padding: const EdgeInsets.all(8),
                           decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), shape: BoxShape.circle),
                           child: const Icon(Icons.water_drop, color: Colors.blue, size: 20),
                         ),
                         const SizedBox(width: 12),
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               const Text('Rekomendasi Air', style: TextStyle(fontSize: 10, color: Colors.grey)),
                               Text(
                                 daysSincePlanting < 15 ? 'Macak-macak (Ketinggian 2-3 cm)' : 'Genangi (Ketinggian 5 cm)',
                                 style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                               ),
                             ],
                           ),
                         )
                       ],
                     ),
                   )
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Timeline
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildTimelineTile(
                  isFirst: true,
                  isLast: false,
                  isPast: true,
                  title: 'Fase Vegetatif',
                  subtitle: '${_formatDateShort(startDate)} - ${_formatDateShort(vegetatifEnd)} (45 hari)',
                  color: AppColors.primary,
                  onTap: () => Navigator.pushNamed(context, '/fertilizer'),
                  description: 'Fase pembentukan akar, daun, dan anakan. Butuh banyak Nitrogen (Urea). Klik untuk detail pupuk.',
                  icon: Icons.eco,
                ),
                 _buildTimelineTile(
                  isFirst: false,
                  isLast: false,
                  isPast: daysSincePlanting > 45,
                  title: 'Fase Generatif (Bunting)',
                  subtitle: '${_formatDateShort(vegetatifEnd)} - ${_formatDateShort(generatifEnd)} (40 hari)',
                  color: Colors.amber,
                  description: 'Fase pembungaan dan pengisian bulir. Butuh Kalium (KCl) dan Fosfor (SP-36). Hindari N berlebih.',
                  icon: Icons.grass, // closest to grain
                ),
                 _buildTimelineTile(
                  isFirst: false,
                  isLast: true,
                  isPast: false,
                  title: 'Fase Pemasakan (Panen)',
                  subtitle: '${_formatDateShort(generatifEnd)} - ${_formatDateShort(harvestDate)} (30 hari)',
                  color: Colors.orange,
                  description: 'Pengeringan bulir. Kurangi air menjelang panen (10 hari sebelum panen keringkan total).',
                  icon: Icons.agriculture,
                ),
              ],
            ),

            const SizedBox(height: 20),
            CustomButton(text: 'Ubah Data Tanam', isPrimary: false, onPressed: () {
               // Logic to edit planting date
            }),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Simple formatter
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatDateShort(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${date.day} ${months[date.month - 1]}';
  }

  Widget _buildTimelineTile({
    required bool isFirst,
    required bool isLast,
    required bool isPast,
    required String title,
    required String subtitle,
    required Color color,
    required String description,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(color: isPast ? color : Colors.grey.withOpacity(0.3), thickness: 2),
      afterLineStyle: LineStyle(color: isPast ? color : Colors.grey.withOpacity(0.3), thickness: 2), // Should logic check next step
      indicatorStyle: IndicatorStyle(
        width: 32,
        height: 32,
        indicator: Container(
          decoration: BoxDecoration(
            color: isPast ? color : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Icon(icon, size: 16, color: isPast ? Colors.white : color),
          ),
        ),
      ),
      endChild: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(left: 12, bottom: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
             color: onTap != null ? color.withOpacity(0.05) : Colors.transparent,
             borderRadius: BorderRadius.circular(12),
             border: onTap != null ? Border.all(color: color.withOpacity(0.3)) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 8),
              Text(description, style: const TextStyle(fontSize: 13, height: 1.4)),
              if (onTap != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Text('Lihat Jadwal', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                      Icon(Icons.arrow_forward, size: 14, color: color)
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class FertilizerScheduleScreen extends StatelessWidget {
  const FertilizerScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppProvider>(context).userProfile;
    final landAreaHa = user.landArea / 10000.0; // Convert m2 to Ha

    // Dosage Helper: Calculates based on land area
    String calc(double amountPerHa) {
      final val = amountPerHa * landAreaHa;
      return '${val.toStringAsFixed(1)} kg';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Pemupukan')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Context Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.eco, color: AppColors.primary),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Varietas ${user.variety}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text('Luas Lahan: ${landAreaHa.toStringAsFixed(2)} Hektar', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 24),

          _buildItem(
            context,
            title: 'Pemupukan Dasar',
            range: '0-7 HST',
            isDone: true,
            details: [
              {'name': 'SP-36', 'amount': calc(100)}, // 100kg/Ha default
              {'name': 'Urea', 'amount': calc(50)},   // 50kg/Ha default
            ]
          ),
          _buildItem(
            context,
            title: 'Pemupukan Susulan I',
            range: '14-21 HST',
            isActive: true,
            details: [
              {'name': 'Urea', 'amount': calc(100)},  // 100kg/Ha
            ]
          ),
           _buildItem(
            context,
            title: 'Pemupukan Susulan II',
            range: '35-40 HST',
            details: [
              {'name': 'Urea', 'amount': calc(50)},   // 50kg/Ha
              {'name': 'KCl', 'amount': calc(50)},    // 50kg/Ha
            ]
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, {required String title, required String range, bool isDone = false, bool isActive = false, required List<Map<String, String>> details}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isDone ? Colors.green : (isActive ? AppColors.primary : Colors.grey[300]),
                    shape: BoxShape.circle,
                    border: isActive ? Border.all(color: Colors.green.shade100, width: 4) : null,
                  ),
                  child: isDone ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                ),
                Expanded(child: Container(width: 2, color: Colors.grey[200])),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border(left: BorderSide(color: isDone ? Colors.green : (isActive ? AppColors.primary : Colors.grey), width: 4)),
                boxShadow: [
                  if (!isDark) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isActive ? AppColors.primary : null)),
                      if (isActive)
                         Container(
                           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                           decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(4)),
                           child: const Text('AKTIF', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green)),
                         )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(range, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  const SizedBox(height: 12),
                  const Divider(),
                  ...details.map((d) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.blue[400], shape: BoxShape.circle)),
                            const SizedBox(width: 8),
                            Text(d['name']!),
                          ],
                        ),
                        Text(d['amount']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
                  if (isActive) ...[
                    const SizedBox(height: 16),
                    CustomButton(text: 'Tandai Selesai', onPressed: () {})
                  ]
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
