import '../../bloc/cart/cart_state.dart';
import '../../data/models/product.dart';

/// Calculates the highest delivery cost among items based on their category.
/// Returns 0 if the cart is empty.
double calculateDeliveryCost(List<CartItem> items) {
  double deliveryCost = 0;
  const small = {'Смартфони', 'Аудіо', 'Аксесуари'};
  const medium = {'Ноутбуки', 'Планшети', 'Плити', 'Міксери'};
  const large = {'Кавомашини', 'Печі', 'Холодильники', 'Посудомийки'};

  for (final item in items) {
    final cat = item.product.category;
    double d = 0;
    if (large.contains(cat)) d = 350;
    else if (medium.contains(cat)) d = 119;
    else if (small.contains(cat)) d = 59;
    if (d > deliveryCost) deliveryCost = d;
  }
  return deliveryCost;
}
