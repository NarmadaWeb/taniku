import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/widgets.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = Provider.of<AppProvider>(context).diagnosisHistory;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Analisis'),
        centerTitle: true,
      ),
      body: history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('Belum ada riwayat', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: history.length,
              separatorBuilder: (c, i) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = history[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade100),
                    boxShadow: [
                       if (!isDark) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: item.imageUrl != null
                              ? DecorationImage(
                                  image: AssetImage(item.imageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: item.imageUrl == null
                              ? AppColors.primary.withOpacity(0.1)
                              : null,
                        ),
                        child: item.imageUrl == null
                            ? const Icon(Icons.image_not_supported, color: AppColors.primary)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Hari ini • 14:30', // Mock date
                              style: TextStyle(color: Colors.grey[500], fontSize: 12),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Tingkat ${item.severity}',
                                style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
