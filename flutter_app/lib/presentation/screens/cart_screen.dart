import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/cart/cart_event.dart';
import '../../bloc/cart/cart_state.dart';
import '../../core/theme/app_colors.dart';
import '../utils/ui_utils.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Кошик", style: TextStyle(color: AppColors.foreground, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.foreground),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.shoppingBag, color: AppColors.mutedForeground, size: 48),
                  const SizedBox(height: 16),
                  const Text("Кошик порожній", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text("Додайте товари з каталогу, щоб зробити замовлення.", style: TextStyle(color: AppColors.mutedForeground, fontSize: 12)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.go('/catalog'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text("Перейти до каталогу"),
                  ),
                ],
              ),
            );
          }

          final double subtotal = state.subtotal;

          // Delivery cost calculation based on product categories
          double deliveryCost = 0;
          const smallCategories = {'Смартфони', 'Аудіо', 'Аксесуари'};
          const mediumCategories = {'Ноутбуки', 'Планшети', 'Плити', 'Міксери'};
          const largeCategories = {'Кавомашини', 'Печі', 'Холодильники', 'Посудомийки'};
          for (final item in state.items) {
            final cat = item.product.category;
            double itemDelivery = 0;
            if (largeCategories.contains(cat)) {
              itemDelivery = 350;
            } else if (mediumCategories.contains(cat)) {
              itemDelivery = 119;
            } else if (smallCategories.contains(cat)) {
              itemDelivery = 59;
            }
            if (itemDelivery > deliveryCost) deliveryCost = itemDelivery;
          }
          final double total = subtotal + deliveryCost;

          final cartList = ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 16.0 : 16.0, vertical: 16.0),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppColors.shadowSoft,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 72,
                      width: 72,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset(item.image, fit: BoxFit.contain),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.category.toUpperCase(),
                            style: const TextStyle(fontSize: 9, color: AppColors.mutedForeground, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.product.name,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          if (item.colorName != null) ...[
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                CircleAvatar(radius: 4, backgroundColor: parseHex(item.color!)),
                                const SizedBox(width: 6),
                                Text(item.colorName!, style: const TextStyle(fontSize: 11, color: AppColors.mutedForeground)),
                              ],
                            ),
                          ],
                          const SizedBox(height: 6),
                          Text("${item.product.price.toInt()} ₴", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 28,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                side: const BorderSide(color: AppColors.border),
                              ),
                              onPressed: () => context.push('/product/${item.product.id}'),
                              child: const Text(
                                "Переглянути",
                                style: TextStyle(fontSize: 11, color: AppColors.foreground, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(LucideIcons.trash2, color: AppColors.mutedForeground, size: 16),
                          onPressed: () {
                            context.read<CartBloc>().add(RemoveProductFromCart(item.key));
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(LucideIcons.minus, size: 12),
                                onPressed: () {
                                  context.read<CartBloc>().add(UpdateProductQuantity(item.key, item.quantity - 1));
                                },
                              ),
                              Text("${item.quantity}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(LucideIcons.plus, size: 12),
                                onPressed: () {
                                  context.read<CartBloc>().add(UpdateProductQuantity(item.key, item.quantity + 1));
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );

          final summaryCard = Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: isDesktop
                  ? Border.all(color: AppColors.border)
                  : const Border(top: BorderSide(color: AppColors.border)),
              borderRadius: isDesktop ? BorderRadius.circular(16) : null,
              boxShadow: isDesktop ? AppColors.shadowSoft : null,
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Сума", style: TextStyle(color: AppColors.mutedForeground, fontSize: 13)),
                      Text("${subtotal.toInt()} ₴", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Доставка", style: TextStyle(color: AppColors.mutedForeground, fontSize: 13)),
                      Text("${deliveryCost.toInt()} ₴", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Загалом", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      Text("${total.toInt()} ₴", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.accent)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () => context.push('/checkout'),
                      child: const Text("Оформити замовлення", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          );

          if (isDesktop) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: cartList,
                  ),
                  Expanded(
                    flex: 2,
                    child: summaryCard,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: cartList,
              ),
              summaryCard,
            ],
          );
        },
      ),
    );
  }
}