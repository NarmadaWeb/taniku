import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/data_source.dart';
import '../widgets/widgets.dart';

class PustakaScreen extends StatefulWidget {
  const PustakaScreen({super.key});

  @override
  State<PustakaScreen> createState() => _PustakaScreenState();
}

class _PustakaScreenState extends State<PustakaScreen> {
  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  final List<String> _categories = ['Semua', 'Budidaya', 'Hama', 'Penyakit', 'Pupuk', 'Varietas'];

  @override
  Widget build(BuildContext context) {
    List<LibraryItem> items = DataSource.libraryItems;

    // Filter by Category
    if (_selectedCategory != 'Semua') {
      items = items.where((i) => i.category == _selectedCategory).toList();
    }

    // Filter by Search
    if (_searchQuery.isNotEmpty) {
      items = items.where((i) =>
        i.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        i.summary.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text('Pustaka', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
            foregroundColor: isDark ? Colors.white : Colors.black,
            actions: [
              IconButton(icon: const Icon(Icons.bookmark_outline), onPressed: () {}),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(110), // Search + Tabs
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Cari artikel, hama, atau penyakit...',
                        prefixIcon: const Icon(Icons.search),
                        fillColor: isDark ? Colors.black26 : Colors.grey[100],
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSelected = cat == _selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (val) => setState(() => _selectedCategory = cat),
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.black : (isDark ? Colors.white : Colors.black54),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            backgroundColor: isDark ? Colors.transparent : Colors.white,
                            side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.withOpacity(0.3)),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_searchQuery.isEmpty && _selectedCategory == 'Semua') ...[
                    const Text('Unggulan Minggu Ini', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildHeroCard(items.isNotEmpty ? items[0] : null),
                    const SizedBox(height: 24),
                    const Text('Terbaru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                  ],

                  if (items.isEmpty)
                     const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("Tidak ada data ditemukan"))),

                  ...items.map((item) => _buildListItem(item, context)).toList(),

                  const SizedBox(height: 80), // Bottom padding for nav bar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(LibraryItem? item) {
    if (item == null) return const SizedBox();
    return GestureDetector(
      onTap: () => _openDetail(item),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(item.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.category.toUpperCase(),
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(LibraryItem item, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => _openDetail(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 100,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(12),
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
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                image: DecorationImage(
                  image: AssetImage(item.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.category,
                          style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.date,
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(LibraryItem item) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => LibraryDetailScreen(item: item)));
  }
}

class LibraryDetailScreen extends StatelessWidget {
  final LibraryItem item;
  const LibraryDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(item.imageUrl, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                           color: AppColors.primary.withOpacity(0.1),
                           borderRadius: BorderRadius.circular(8),
                           border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                        ),
                        child: Text(item.category, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
                      ),
                      const Spacer(),
                      Text(item.date, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.3),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  Text(
                    item.content,
                    style: const TextStyle(fontSize: 16, height: 1.8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
