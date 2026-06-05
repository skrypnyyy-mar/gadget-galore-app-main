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
import '../utils/ui_utils.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String id;
  const ProductDetailsScreen({super.key, required this.id});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;
  int selectedColorIndex = 0;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final product = getProduct(widget.id);
    if (product == null) {
      return const Scaffold(
        body: Center(child: Text("Товар не знайдено")),
      );
    }

    final hasColors = product.colors.isNotEmpty;
    final String activeImage = (product.images != null &&
            selectedColorIndex < product.images!.length)
        ? product.images![selectedColorIndex]
        : product.image;

    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.foreground),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64.0 : 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product visual variant (Large image, aligned left, hover zoom)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _isHovering = true),
                      onExit: (_) => setState(() => _isHovering = false),
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            height: isDesktop ? 340 : 260,
                            width: isDesktop ? 340 : 260,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.border, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: AnimatedScale(
                              scale: _isHovering ? 1.25 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Image.asset(
                                  activeImage,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 12,
                            top: 24,
                            child: BlocBuilder<FavoritesBloc, FavoritesState>(
                              builder: (context, state) {
                                final isFav = state.has(product.id);
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.border),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      isFav ? Icons.favorite : Icons.favorite_border,
                                      color: isFav ? Colors.red : AppColors.foreground,
                                    ),
                                    onPressed: () {
                                      context.read<FavoritesBloc>().add(ToggleFavorite(product.id));
                                      ScaffoldMessenger.of(context).clearSnackBars();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(isFav ? "Видалено з обраного" : "Додано до обраного"),
                                          duration: const Duration(seconds: 3),
                                          action: isFav ? null : SnackBarAction(
                                            label: "Перейти до обраного",
                                            onPressed: () => context.go('/favorites'),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            right: 12,
                            bottom: 24,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.8),
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Icon(
                                LucideIcons.search,
                                size: 18,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Category
                  Text(
                    product.category.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.mutedForeground,
                      fontSize: 11,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Title & Tagline
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.tagline,
                    style: const TextStyle(fontSize: 14, color: AppColors.mutedForeground),
                  ),
                  const SizedBox(height: 16),

                  // Ratings
                  Row(
                    children: [
                      const Icon(LucideIcons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${product.rating}",
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "(${product.reviews} відгуків)",
                        style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Price card styled like in services
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        const Text(
                          "Вартість: ",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.mutedForeground,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${product.price.toInt()} ₴",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Color selection container
                  if (hasColors) ...[
                    Text(
                      product.colorNames != null && selectedColorIndex < product.colorNames!.length
                          ? "Колір: ${product.colorNames![selectedColorIndex]}"
                          : "Колір",
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(product.colors.length, (idx) {
                        final hexColor = product.colors[idx];
                        final isSelected = idx == selectedColorIndex;
                        return InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            setState(() {
                              selectedColorIndex = idx;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? AppColors.accent : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: parseHex(hexColor),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Specs / Description tab
                  const Text(
                    "Опис",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.foreground),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Sticky bottom actions bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(top: BorderSide(color: AppColors.border)),
              boxShadow: AppColors.shadowSoft,
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Quantity picker
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(LucideIcons.minus, size: 14),
                          onPressed: () {
                            if (quantity > 1) {
                              setState(() {
                                quantity--;
                              });
                            }
                          },
                        ),
                        Text(
                          "$quantity",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(LucideIcons.plus, size: 14),
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Button CTA
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () {
                        context.read<CartBloc>().add(AddProductToCart(
                              product,
                              quantity: quantity,
                              colorIndex: hasColors ? selectedColorIndex : null,
                            ));
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Додано в кошик: ${product.name}"),
                            duration: const Duration(seconds: 3),
                            action: SnackBarAction(
                              label: "Перейти до кошика",
                              onPressed: () => context.go('/cart'),
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Додати до кошика",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
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
