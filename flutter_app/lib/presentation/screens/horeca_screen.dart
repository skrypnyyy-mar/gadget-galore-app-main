import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/mock/horeca_data.dart';
import '../../core/theme/app_colors.dart';

class HorecaScreen extends StatefulWidget {
  const HorecaScreen({super.key});

  @override
  State<HorecaScreen> createState() => _HorecaScreenState();
}

class _HorecaScreenState extends State<HorecaScreen> {
  String selectedCategory = "All";
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  final List<String> horecaCategoriesList = [
    "All",
    "Монтаж",
    "Сервісне обслуговування",
    "Консультації",
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    final filteredServices = mockHorecaItems.where((s) {
      final matchesCategory = selectedCategory == "All" || s.category == selectedCategory;
      final matchesSearch = s.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          s.tagline.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Послуги", style: TextStyle(color: AppColors.foreground, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.foreground),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 48.0 : 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search input
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppColors.shadowSoft,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      searchQuery = val;
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(LucideIcons.search, color: AppColors.mutedForeground, size: 20),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(LucideIcons.x, color: AppColors.mutedForeground, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                searchQuery = "";
                              });
                            },
                          )
                        : null,
                    hintText: "Пошук послуг...",
                    hintStyle: const TextStyle(color: AppColors.mutedForeground, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Categories Row Selector
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: horecaCategoriesList.length,
                  itemBuilder: (context, index) {
                    final cat = horecaCategoriesList[index];
                    final isActive = cat == selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        label: Text(
                          cat == "All" ? "Всі послуги" : cat,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isActive ? Colors.white : AppColors.foreground,
                          ),
                        ),
                        selected: isActive,
                        onSelected: (_) {
                          setState(() {
                            selectedCategory = cat;
                          });
                        },
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        surfaceTintColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: isActive ? Colors.transparent : AppColors.border),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Grid list of services (Smaller blocks)
              Expanded(
                child: filteredServices.isEmpty
                    ? const Center(
                        child: Text("Послуг не знайдено", style: TextStyle(color: AppColors.mutedForeground, fontSize: 14)),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: isDesktop ? 600 : 500,
                          mainAxisExtent: isDesktop ? 180 : 160,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filteredServices.length,
                        itemBuilder: (context, index) {
                          final service = filteredServices[index];
                          return InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => context.push('/horeca/${service.id}'),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: AppColors.shadowSoft,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    width: isDesktop ? 130 : 110,
                                    color: Colors.white,
                                    padding: const EdgeInsets.all(12),
                                    child: Image.asset(service.image, fit: BoxFit.contain),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.secondary,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              service.category.toUpperCase(),
                                              style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.mutedForeground),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            service.name,
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6),
                                          Expanded(
                                            child: Text(
                                              service.tagline,
                                              style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                service.price == 0 ? "Безкоштовно" : "${service.price.toInt()} ₴",
                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.accent),
                                              ),
                                              const Icon(LucideIcons.arrowRight, size: 16, color: AppColors.mutedForeground),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
