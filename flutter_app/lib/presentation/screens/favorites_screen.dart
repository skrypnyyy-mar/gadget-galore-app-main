import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/mock/products_data.dart';
import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/cart/cart_event.dart';
import '../../bloc/favorites/favorites_bloc.dart';
import '../../bloc/favorites/favorites_event.dart';
import '../../bloc/favorites/favorites_state.dart';
import '../../core/theme/app_colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Обране", style: TextStyle(color: AppColors.foreground, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.foreground),
          onPressed: () => context.go('/'),
        ),
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          final favProducts = mockProducts.where((p) => state.has(p.id)).toList();

          return Column(
            children: [
              // Always visible catalog navigation button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => context.go('/catalog'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text("Перейти до каталогу"),
                  ),
                ),
              ),
              Expanded(
                child: favProducts.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(LucideIcons.heart, color: AppColors.mutedForeground, size: 48),
                            SizedBox(height: 16),
                            Text("Обраних товарів немає", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 6),
                            Text("Додавайте гаджети, натискаючи серце на деталях товару.", style: TextStyle(color: AppColors.mutedForeground, fontSize: 11)),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64.0 : 16.0, vertical: 16.0),
                        itemCount: favProducts.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isDesktop ? 4 : 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.58,
                        ),
                        itemBuilder: (context, index) {
                          final product = favProducts[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: AppColors.shadowSoft,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image with Favorite toggle heart on top
                                Stack(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1,
                                      child: Container(
                                        color: Colors.white,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          product.image,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white.withValues(alpha: 0.8),
                                        radius: 18,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(Icons.favorite, color: Colors.red, size: 20),
                                          onPressed: () {
                                            context.read<FavoritesBloc>().add(ToggleFavorite(product.id));
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.category.toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 9,
                                                letterSpacing: 1.1,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.mutedForeground,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              product.name,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "${product.price.toInt()} ₴",
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.accent,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // CTA buttons
                                        Column(
                                          children: [
                                            SizedBox(
                                              width: double.infinity,
                                              height: 32,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: AppColors.primary,
                                                  foregroundColor: Colors.white,
                                                  padding: EdgeInsets.zero,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                ),
                                                onPressed: () {
                                                  context.read<CartBloc>().add(AddProductToCart(product));
                                                  ScaffoldMessenger.of(context).clearSnackBars();
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text("Додано в кошик: ${product.name}"),
                                                      action: SnackBarAction(
                                                        label: "Перейти до кошика",
                                                        onPressed: () => context.go('/cart'),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: const Text("До кошика", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            SizedBox(
                                              width: double.infinity,
                                              height: 32,
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                  side: const BorderSide(color: AppColors.border),
                                                ),
                                                onPressed: () => context.push('/product/${product.id}'),
                                                child: const Text("Переглянути", style: TextStyle(fontSize: 11, color: AppColors.foreground, fontWeight: FontWeight.bold)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
