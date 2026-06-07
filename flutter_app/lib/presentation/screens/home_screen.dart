import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/models/product.dart';
import '../../data/api/api_service.dart';
import '../../bloc/auth/auth_notifier.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/product_card.dart';
import '../utils/ui_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = "Всі";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return FutureBuilder<List<Product>>(
      future: ApiService.instance.fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Помилка завантаження товарів'),
                ElevatedButton(onPressed: () => setState(() {}), child: const Text('Спробувати ще раз')),
              ],
            ),
          );
        }
        final allProducts = snapshot.data!;
        final filteredProducts = selectedCategory == "Всі" ? allProducts : allProducts.where((p) => p.category == selectedCategory).toList();
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async => setState(() {}),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 48.0 : 16.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Voltix", style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                            const SizedBox(height: 4),
                            const Text("Сучасна техніка та обладнання", style: TextStyle(color: AppColors.mutedForeground, fontSize: 13)),
                          ],
                        ),
                        AnimatedBuilder(
                          animation: AuthNotifier.instance,
                          builder: (context, _) {
                            final name = AuthNotifier.instance.userName;
                            final email = AuthNotifier.instance.userEmail;
                            return InkWell(
                              borderRadius: BorderRadius.circular(20), onTap: () => context.go('/account'),
                              child: Container(
                                height: 42, width: 42, decoration: BoxDecoration(color: getAvatarColor(email ?? name ?? ""), shape: BoxShape.circle),
                                child: Center(child: Text(getAvatarLetter(name, email), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15))),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    InkWell(
                      borderRadius: BorderRadius.circular(20), onTap: () => context.go('/catalog'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: AppColors.shadowSoft),
                        child: const Row(
                          children: [
                            Icon(LucideIcons.search, color: AppColors.mutedForeground, size: 20),
                            SizedBox(width: 12),
                            Text("Пошук гаджетів та обладнання...", style: TextStyle(color: AppColors.mutedForeground, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity, padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF32353E), Color(0xFF1E2026)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(24), boxShadow: AppColors.shadowCard,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                                  child: const Text("НОВИНКА", style: TextStyle(color: Color(0xFF64B5F6), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                ),
                                const SizedBox(height: 12),
                                const Text("Nova Pro", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                const Text("Titanium body. Pro camera.", style: TextStyle(color: Colors.white70, fontSize: 13)),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => context.push('/product/nova-pro'),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                                  child: const Text("Переглянути", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, spreadRadius: 2, offset: const Offset(0, 4))]),
                                child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset("assets/product-phone.jpg", fit: BoxFit.contain, height: 100)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      borderRadius: BorderRadius.circular(20), onTap: () => context.push('/horeca'),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border), boxShadow: AppColors.shadowSoft),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.1), shape: BoxShape.circle),
                              child: const Icon(LucideIcons.truck, color: AppColors.accent, size: 20),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Послуги", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 2),
                                  Text("Доставка, монтаж, планове ТО обладнання цеху", style: TextStyle(fontSize: 11, color: AppColors.mutedForeground)),
                                ],
                              ),
                            ),
                            const Icon(LucideIcons.chevronRight, color: AppColors.mutedForeground, size: 18),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text("Категорії", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        spacing: 8.0, runSpacing: 8.0, alignment: WrapAlignment.spaceEvenly,
                        children: productCategories.map((cat) {
                          final isActive = cat == selectedCategory;
                          return ChoiceChip(
                            labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            label: Text(cat, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isActive ? Colors.white : AppColors.foreground)),
                            selected: isActive,
                            onSelected: (_) => setState(() { selectedCategory = cat; }),
                            selectedColor: AppColors.primary, backgroundColor: Colors.white, shadowColor: Colors.transparent, surfaceTintColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isActive ? Colors.transparent : AppColors.border)),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: filteredProducts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isDesktop ? 4 : 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.70),
                      itemBuilder: (context, index) => ProductCard(product: filteredProducts[index], index: index),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}