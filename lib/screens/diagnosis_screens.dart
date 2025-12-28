import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../data/data_source.dart';
import '../widgets/widgets.dart';

// --- Diagnosis Base Screen ---
class DiagnosisBaseScreen extends StatelessWidget {
  final int step;
  final String title;
  final String description;
  final String category;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final bool isLastStep;

  const DiagnosisBaseScreen({
    Key? key,
    required this.step,
    required this.title,
    required this.description,
    required this.category,
    required this.onNext,
    required this.onBack,
    this.isLastStep = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final symptoms = DataSource.symptoms.where((s) => s.category == category).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        title: const Text('Diagnosa Padi', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
               appProvider.resetDiagnosis();
               Navigator.popUntil(context, ModalRoute.withName('/home'));
            },
            child: const Text('Batal', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Langkah $step dari 3', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(category == 'leaf' ? 'Gejala Daun' : category == 'stem' ? 'Gejala Batang' : 'Gejala Buah',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: step / 3,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  color: AppColors.primary,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(fontSize: 15, color: isDark ? Colors.grey[400] : Colors.grey[600]),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: symptoms.length,
              separatorBuilder: (c, i) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final symptom = symptoms[index];
                final isSelected = appProvider.selectedSymptoms.containsKey(symptom.id);

                return GestureDetector(
                  onTap: () => appProvider.toggleSymptom(symptom.id),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : (isDark ? Colors.white10 : Colors.grey.shade200),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: Row(
                      children: [
                        if (symptom.imageUrl != null)
                           Container(
                              width: 60,
                              height: 60,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: AssetImage(symptom.imageUrl!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                           )
                        else
                          Container(
                            width: 60,
                            height: 60,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              category == 'leaf' ? Icons.eco : category == 'stem' ? Icons.opacity : Icons.grain,
                              color: AppColors.primary,
                            ),
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                symptom.description,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              if (symptom.imageUrl != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text('Lihat gambar', style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                                )
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Checkbox(
                          value: isSelected,
                          activeColor: AppColors.primary,
                          onChanged: (val) => appProvider.toggleSymptom(symptom.id),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: CustomButton(
                text: isLastStep ? 'Lihat Hasil' : 'Lanjut',
                icon: Icons.arrow_forward,
                onPressed: onNext,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Steps ---

class DiagnosisStep1Screen extends StatelessWidget {
  const DiagnosisStep1Screen({super.key});
  @override
  Widget build(BuildContext context) {
    return DiagnosisBaseScreen(
      step: 1,
      category: 'leaf',
      title: 'Pilih Gejala pada Daun',
      description: 'Silakan centang semua gejala yang terlihat pada daun tanaman padi Anda.',
      onNext: () => Navigator.pushNamed(context, '/diagnosis/step2'),
      onBack: () => Navigator.pop(context),
    );
  }
}

class DiagnosisStep2Screen extends StatelessWidget {
  const DiagnosisStep2Screen({super.key});
  @override
  Widget build(BuildContext context) {
    return DiagnosisBaseScreen(
      step: 2,
      category: 'stem',
      title: 'Apa gejala pada batang?',
      description: 'Perhatikan kondisi fisik batang padi Anda dengan seksama.',
      onNext: () => Navigator.pushNamed(context, '/diagnosis/step3'),
      onBack: () => Navigator.pop(context),
    );
  }
}

class DiagnosisStep3Screen extends StatelessWidget {
  const DiagnosisStep3Screen({super.key});
  @override
  Widget build(BuildContext context) {
    return DiagnosisBaseScreen(
      step: 3,
      category: 'fruit',
      title: 'Gejala pada Buah/Bulir',
      description: 'Amati bulir padi Anda. Pilih semua gejala yang terlihat.',
      isLastStep: true,
      onNext: () {
        Provider.of<AppProvider>(context, listen: false).runDiagnosis();
        Navigator.pushNamed(context, '/diagnosis/result');
      },
      onBack: () => Navigator.pop(context),
    );
  }
}

class DiagnosisResultScreen extends StatelessWidget {
  const DiagnosisResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final disease = appProvider.diagnosisResult;
    final confidence = appProvider.diagnosisConfidence;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (disease == null || confidence == 0) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hasil Diagnosa')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, size: 80, color: AppColors.primary),
              const SizedBox(height: 20),
              const Text('Tanaman Anda Sehat!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Berdasarkan gejala yang dipilih, tidak ditemukan penyakit yang cocok. Tetap pantau kondisi tanaman anda.', textAlign: TextAlign.center),
              ),
              ElevatedButton(
                onPressed: () {
                  appProvider.resetDiagnosis();
                  Navigator.popUntil(context, ModalRoute.withName('/home'));
                },
                child: const Text('Kembali ke Beranda'),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            appProvider.resetDiagnosis();
            Navigator.popUntil(context, ModalRoute.withName('/home'));
          },
        ),
        title: const Text('Hasil Diagnosa', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
             Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(disease.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.warning, color: Colors.white, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  'Tingkat ${disease.severity}',
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            disease.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
             ),
             Padding(
               padding: const EdgeInsets.all(20),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   // Confidence
                   Container(
                     padding: const EdgeInsets.all(16),
                     decoration: BoxDecoration(
                       color: isDark ? AppColors.surfaceDark : Colors.white,
                       borderRadius: BorderRadius.circular(16),
                       border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                       boxShadow: [
                         if (!isDark) BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
                       ]
                     ),
                     child: Column(
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text('Tingkat Kecocokan', style: TextStyle(fontWeight: FontWeight.w600)),
                             Text('${(confidence * 100).toInt()}%', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
                           ],
                         ),
                         const SizedBox(height: 8),
                         LinearProgressIndicator(
                           value: confidence,
                           backgroundColor: Colors.grey.withOpacity(0.2),
                           color: AppColors.primary,
                           minHeight: 10,
                           borderRadius: BorderRadius.circular(5),
                         )
                       ],
                     ),
                   ),
                   const SizedBox(height: 24),

                   // Description
                   const SectionHeader(icon: Icons.info, title: 'Tentang Penyakit'),
                   const SizedBox(height: 8),
                   Text(
                     disease.description,
                     style: const TextStyle(height: 1.6),
                   ),
                   const SizedBox(height: 24),

                   // Prevention
                   const SectionHeader(icon: Icons.shield, title: 'Pencegahan'),
                   const SizedBox(height: 12),
                   ...disease.prevention.map((e) => BulletPoint(text: e)),
                   const SizedBox(height: 24),

                   // Treatment
                   const SectionHeader(icon: Icons.medical_services, title: 'Penanganan'),
                   const SizedBox(height: 12),
                   ...disease.treatment.map((e) => BulletPoint(text: e)),

                   const SizedBox(height: 40),
                   CustomButton(
                     text: 'Selesai',
                     onPressed: () {
                       appProvider.resetDiagnosis();
                       Navigator.popUntil(context, ModalRoute.withName('/home'));
                     },
                   )
                 ],
               ),
             ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const SectionHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 12),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.grey[800],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
