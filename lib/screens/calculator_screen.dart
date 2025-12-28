import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/widgets.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _landAreaController = TextEditingController();
  final _priceController = TextEditingController();

  // Advanced details
  final _seedPriceController = TextEditingController();
  final _fertilizerCostController = TextEditingController();
  final _laborCostController = TextEditingController();
  final _pestControlCostController = TextEditingController();

  String _areaUnit = 'm²';
  bool _showAdvanced = false;

  double? _estimatedRevenue;
  double? _estimatedCost;
  double? _estimatedProfit;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Tani'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  if (!isDark) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Data Lahan & Harga', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  // Land Area
                  _buildInputLabel('Luas Tanah'),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _landAreaController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration('0'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _areaUnit,
                            items: ['m²', 'Ha', 'Rante', 'Bata'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                            onChanged: (val) => setState(() => _areaUnit = val!),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price
                  _buildInputLabel('Harga Gabah per Kg (Rp)'),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration('Contoh: 5500'),
                  ),

                  const SizedBox(height: 16),

                  // Toggle Advanced
                  GestureDetector(
                    onTap: () => setState(() => _showAdvanced = !_showAdvanced),
                    child: Row(
                      children: [
                        Text(
                          _showAdvanced ? 'Sembunyikan Detail Biaya' : 'Tampilkan Detail Biaya (Opsional)',
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                        Icon(_showAdvanced ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.primary),
                      ],
                    ),
                  ),

                  if (_showAdvanced) ...[
                    const SizedBox(height: 16),
                    _buildInputLabel('Biaya Benih'),
                    TextField(controller: _seedPriceController, keyboardType: TextInputType.number, decoration: _inputDecoration('0')),
                    const SizedBox(height: 12),
                    _buildInputLabel('Biaya Pupuk Total'),
                    TextField(controller: _fertilizerCostController, keyboardType: TextInputType.number, decoration: _inputDecoration('0')),
                    const SizedBox(height: 12),
                    _buildInputLabel('Biaya Tenaga Kerja'),
                    TextField(controller: _laborCostController, keyboardType: TextInputType.number, decoration: _inputDecoration('0')),
                    const SizedBox(height: 12),
                    _buildInputLabel('Biaya Pestisida'),
                    TextField(controller: _pestControlCostController, keyboardType: TextInputType.number, decoration: _inputDecoration('0')),
                  ],

                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Hitung Estimasi',
                    icon: Icons.calculate,
                    onPressed: _calculate,
                  ),
                ],
              ),
            ),

            if (_estimatedRevenue != null) ...[
              const SizedBox(height: 24),
              const Text('Hasil Perhitungan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              // Result Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF136a35), Color(0xFF0F5132)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF136a35).withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 8)),
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Potensi Pendapatan Kotor', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 4),
                    Text(
                      _formatCurrency(_estimatedRevenue!),
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               const Text('Estimasi Biaya', style: TextStyle(color: Colors.white70, fontSize: 12)),
                               Text(_formatCurrency(_estimatedCost ?? 0), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                             ],
                           ),
                         ),
                         Container(width: 1, height: 30, color: Colors.white24),
                         const SizedBox(width: 16),
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               const Text('Potensi Laba', style: TextStyle(color: Colors.white70, fontSize: 12)),
                               Text(_formatCurrency(_estimatedProfit ?? 0), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                             ],
                           ),
                         ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
                      child: const Text(
                        '*Estimasi berdasarkan rata-rata produktivitas 6 ton/Ha GKP. Hasil aktual dapat bervariasi.',
                        style: TextStyle(color: Colors.white60, fontSize: 10, fontStyle: FontStyle.italic),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.black26 : Colors.grey[50],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  void _calculate() {
    FocusScope.of(context).unfocus();

    double area = double.tryParse(_landAreaController.text) ?? 0;
    double price = double.tryParse(_priceController.text) ?? 0;

    // Convert to Ha
    double areaInHa = 0;
    if (_areaUnit == 'm²') areaInHa = area / 10000;
    else if (_areaUnit == 'Ha') areaInHa = area;
    else if (_areaUnit == 'Rante') areaInHa = (area * 400) / 10000; // Assumption 1 Rante = 400m2
    else if (_areaUnit == 'Bata') areaInHa = (area * 14) / 10000; // Assumption 1 Bata = 14m2

    if (areaInHa <= 0) return;

    // Average Yield: 6 Ton / Ha = 6000 kg / Ha
    double estimatedYield = areaInHa * 6000;

    double revenue = estimatedYield * price;

    // Costs
    double seed = double.tryParse(_seedPriceController.text) ?? 0;
    double fert = double.tryParse(_fertilizerCostController.text) ?? 0;
    double labor = double.tryParse(_laborCostController.text) ?? 0;
    double pest = double.tryParse(_pestControlCostController.text) ?? 0;

    // Simple default cost estimation if advanced not filled (approx 6-8jt per Ha)
    double totalCost = 0;
    if (seed == 0 && fert == 0 && labor == 0 && pest == 0) {
      // Auto estimate
      totalCost = areaInHa * 7000000; // 7 million per Ha
    } else {
      totalCost = seed + fert + labor + pest;
    }

    setState(() {
      _estimatedRevenue = revenue;
      _estimatedCost = totalCost;
      _estimatedProfit = revenue - totalCost;
    });
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);
  }
}
