import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/models/product.dart';
import '../../data/mock/products_data.dart';
import '../../data/mock/horeca_data.dart';
import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/cart/cart_event.dart';
import '../../bloc/cart/cart_state.dart';
import '../../bloc/favorites/favorites_bloc.dart';
import '../../bloc/favorites/favorites_event.dart';
import '../../bloc/favorites/favorites_state.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/product_card.dart';
import '../../data/mock/ukraine_locations.dart';


// Helper for parsing Hex colors (e.g. #ffffff)
Color parseHex(String hex) {
  try {
    return Color(int.parse(hex.replaceFirst('#', '0xff')));
  } catch (_) {
    return Colors.grey;
  }
}

// ----------------------------------------------------
// 1. HOME SCREEN
// ----------------------------------------------------
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // GlassLoading could be styled later
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Помилка завантаження товарів'),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Спробувати ще раз'),
                ),
              ],
            ),
          );
        }
        final allProducts = snapshot.data!;
        final filteredProducts = selectedCategory == "Всі"
            ? allProducts
            : allProducts.where((p) => p.category == selectedCategory).toList();
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 48.0 : 16.0,
                  vertical: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Voltix",
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Сучасна техніка та обладнання",
                        style: TextStyle(color: AppColors.mutedForeground, fontSize: 13),
                      ),
                    ],
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => context.go('/account'),
                    child: Container(
                      height: 42,
                      width: 42,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          "М",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Search Bar
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => context.go('/catalog'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: AppColors.shadowSoft,
                  ),
                  child: const Row(
                    children: [
                      Icon(LucideIcons.search, color: AppColors.mutedForeground, size: 20),
                      SizedBox(width: 12),
                      Text(
                        "Пошук гаджетів та обладнання...",
                        style: TextStyle(color: AppColors.mutedForeground, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Featured Product Banner (Hero Carousel Banner)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF32353E), Color(0xFF1E2026)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppColors.shadowCard,
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
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "НОВИНКА",
                              style: TextStyle(
                                color: Color(0xFF64B5F6),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Nova Pro",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Titanium body. Pro camera.",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.push('/product/nova-pro'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
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
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              "assets/product-phone.jpg",
                              fit: BoxFit.contain,
                              height: 100,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // HoReCa Shortcut Banner
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => context.push('/horeca'),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppColors.shadowSoft,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.truck, color: AppColors.accent, size: 20),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Послуги",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Доставка, монтаж, планове ТО обладнання цеху",
                              style: TextStyle(fontSize: 11, color: AppColors.mutedForeground),
                            ),
                          ],
                        ),
                      ),
                      const Icon(LucideIcons.chevronRight, color: AppColors.mutedForeground, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Horizontal Category Scroll Row
              const Text(
                "Категорії",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.spaceEvenly,
                  children: productCategories.map((cat) {
                    final isActive = cat == selectedCategory;
                    return ChoiceChip(
                      labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      label: Text(
                        cat,
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
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Product Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredProducts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isDesktop ? 4 : 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.70,
                ),
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: filteredProducts[index],
                    index: index,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// 2. CATALOG SCREEN
// ----------------------------------------------------
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String selectedCategory = "Всі";
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    // Filter matching products
    final filtered = mockProducts.where((p) {
      final matchesCategory = selectedCategory == "Всі" || p.category == selectedCategory;
      final matchesSearch = p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.tagline.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 48.0 : 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Каталог",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Search input text field
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
                    hintText: "Пошук товарів за назвою...",
                    hintStyle: const TextStyle(color: AppColors.mutedForeground, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Categories Selector Row
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.spaceEvenly,
                  children: productCategories.map((cat) {
                    final isActive = cat == selectedCategory;
                    return ChoiceChip(
                      labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      label: Text(
                        cat,
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
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Grid list of products
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(LucideIcons.alertCircle, color: AppColors.mutedForeground, size: 40),
                            SizedBox(height: 12),
                            Text("Нічого не знайдено", style: TextStyle(color: AppColors.mutedForeground, fontSize: 14)),
                          ],
                        ),
                      )
                    : GridView.builder(
                        itemCount: filtered.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isDesktop ? 4 : 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.70,
                        ),
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: filtered[index],
                            index: index,
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

// ----------------------------------------------------
// 3. PRODUCT DETAILS SCREEN
// ----------------------------------------------------
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

class FormValidators {
  static const String universalError = "Невірно введені дані. Перевірте правильність заповнення поля.";

  static final RegExp _nameRegex = RegExp(r"^[A-ZА-ЯІЄЇҐ][a-zа-яієїґ'\u2019`\x27\-]+$");
  static final RegExp _phoneRegex = RegExp(r'^0\d{9}$');
  static final RegExp _cardRegex = RegExp(r'^\d{16}$');
  static final RegExp _expiryRegex = RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$');
  static final RegExp _cvcRegex = RegExp(r'^\d{3}$');
  static final RegExp _companyRegex = RegExp(r'^[А-ЯІЄЇЄа-яіїє\s]+$');
  static final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final RegExp _dateRegex = RegExp(r'^(0[1-9]|[12][0-9]|3[01])\.(0[1-9]|1[0-2])\.\d{4}$');

  static bool isValidName(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));
    return parts.length == 2 && _nameRegex.hasMatch(parts[0]) && _nameRegex.hasMatch(parts[1]);
  }

  static bool isValidPhone(String value) => _phoneRegex.hasMatch(value.trim());

  static bool isValidCardNumber(String value) => _cardRegex.hasMatch(value.trim());

  static bool isValidExpiry(String value) => _expiryRegex.hasMatch(value.trim());

  static bool isValidCvc(String value) => _cvcRegex.hasMatch(value.trim());

  static bool isValidCompany(String value) {
    final val = value.trim();
    return val.isEmpty || _companyRegex.hasMatch(val);
  }

  static bool isValidEmail(String value) {
    final val = value.trim();
    return val.isEmpty || _emailRegex.hasMatch(val);
  }

  static bool isValidDate(String value) {
    final val = value.trim();
    return val.isEmpty || _dateRegex.hasMatch(val);
  }

  static bool isValidCity(String value) => ukraineLocations.contains(value.trim());
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String payMethod = "card"; // card or apple
  bool isLoading = false;
  bool _isFormValid = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  String _lastCity = "";

  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();

  final Map<String, List<String>> cityAddresses = {
    'Київ': ['Відділення №1: вул. Пирогівський шлях, 135', 'Відділення №5: вул. Федорова, 32', 'Відділення №10: вул. Валерія Лобановського, 119'],
    'Львів': ['Відділення №1: вул. Городоцька, 355', 'Відділення №8: вул. Героїв УПА, 73'],
    'Одеса': ['Відділення №1: вул. Дальницька, 23/4', 'Відділення №15: вул. Тираспольська, 16'],
    'Харків': ['Відділення №1: вул. Польова, 67', 'Відділення №20: пр-т Гагаріна, 41/2'],
    'Дніпро': ['Відділення №1: вул. Маршала Малиновського, 114', 'Відділення №4: вул. Князя Ярослава Мудрого, 56'],
    'Запоріжжя': ['Відділення №1: вул. Аварійна, 11а', 'Відділення №3: вул. Айвазовського, 9'],
    'Івано-Франківськ': ['Відділення №1: вул. Мазепи, 175б', 'Відділення №5: вул. Галицька, 34б'],
    'Тернопіль': ['Відділення №1: вул. Подільська, 21', 'Відділення №7: вул. Медова, 3'],
  };

  List<String> getAddressesForCity(String city) {
    if (cityAddresses.containsKey(city)) {
      return cityAddresses[city]!;
    }
    return [
      'Відділення №1: вул. Центральна, 1',
      'Відділення №2: вул. Соборна, 15',
      'Відділення №3: пр-т Перемоги, 24',
    ];
  }

  void _checkFormValidity() {
    final nameOk = FormValidators.isValidName(_nameController.text);
    final phoneOk = FormValidators.isValidPhone(_phoneController.text);
    final cityOk = FormValidators.isValidCity(_cityController.text);
    final addressOk = _addressController.text.trim().isNotEmpty &&
        getAddressesForCity(_cityController.text.trim()).contains(_addressController.text.trim());

    bool cardOk = true;
    if (payMethod == "card") {
      cardOk = FormValidators.isValidCardNumber(_cardNumberController.text) &&
               FormValidators.isValidExpiry(_expiryController.text) &&
               FormValidators.isValidCvc(_cvcController.text);
    }

    final valid = nameOk && phoneOk && cityOk && addressOk && cardOk;
    if (valid != _isFormValid) {
      setState(() { _isFormValid = valid; });
    }
  }

  @override
  void initState() {
    super.initState();
    _cityController.addListener(() {
      if (_cityController.text != _lastCity) {
        _lastCity = _cityController.text;
        _addressController.clear();
      }
    });
    _nameController.addListener(_checkFormValidity);
    _phoneController.addListener(_checkFormValidity);
    _cityController.addListener(_checkFormValidity);
    _addressController.addListener(_checkFormValidity);
    _cardNumberController.addListener(_checkFormValidity);
    _expiryController.addListener(_checkFormValidity);
    _cvcController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  void autofillData() {
    setState(() {
      _nameController.text = "Марія Скрипник";
      _phoneController.text = "0951234567";
      _cityController.text = "Київ";
      _addressController.text = "Відділення №1: вул. Пирогівський шлях, 135";
      _cardNumberController.text = "4242424242424242";
      _expiryController.text = "12/27";
      _cvcController.text = "123";
    });
    _checkFormValidity();
  }

  void _submit() {
    // Simulated server-side validation check
    final nameOk = FormValidators.isValidName(_nameController.text);
    final phoneOk = FormValidators.isValidPhone(_phoneController.text);
    final cityOk = FormValidators.isValidCity(_cityController.text);
    final addressOk = _addressController.text.trim().isNotEmpty &&
        getAddressesForCity(_cityController.text.trim()).contains(_addressController.text.trim());

    bool cardOk = true;
    if (payMethod == "card") {
      cardOk = FormValidators.isValidCardNumber(_cardNumberController.text) &&
               FormValidators.isValidExpiry(_expiryController.text) &&
               FormValidators.isValidCvc(_cvcController.text);
    }

    final isServerValid = nameOk && phoneOk && cityOk && addressOk && cardOk;
    if (!isServerValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(FormValidators.universalError)),
      );
      return;
    }

    if (payMethod == "apple") {
      setState(() {
        isLoading = true;
      });

      final cartBloc = context.read<CartBloc>();
      final router = GoRouter.of(context);

      Future.delayed(const Duration(milliseconds: 1100), () {
        cartBloc.add(ClearCart());
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          router.go('/success');
        }
      });
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final cartBloc = context.read<CartBloc>();
      final router = GoRouter.of(context);

      Future.delayed(const Duration(milliseconds: 1100), () {
        cartBloc.add(ClearCart());
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          router.go('/success');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Оформлення", style: TextStyle(color: AppColors.foreground, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.foreground),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64.0 : 20.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(LucideIcons.truck, color: AppColors.foreground, size: 18),
                                SizedBox(width: 8),
                                Text("Доставка", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            TextButton.icon(
                              onPressed: autofillData,
                              icon: const Icon(LucideIcons.copy, size: 16),
                              label: const Text("Збережені дані (Автозаповнення)"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildField(
                          "Ім'я та прізвище *", 
                          _nameController, 
                          "Марія Скрипник",
                          validator: (value) => FormValidators.isValidName(value ?? "")
                              ? null
                              : FormValidators.universalError,
                        ),
                        _buildField(
                          "Телефон *", 
                          _phoneController, 
                          "0951234567", 
                          isPhone: true,
                          validator: (value) => FormValidators.isValidPhone(value ?? "")
                              ? null
                              : FormValidators.universalError,
                        ),
                        
                        SearchableDropdown(
                          label: "Місто *",
                          placeholder: "Введіть та оберіть місто",
                          items: ukraineLocations,
                          controller: _cityController,
                          validator: (value) => FormValidators.isValidCity(value ?? "")
                              ? null
                              : FormValidators.universalError,
                        ),
                        
                        SearchableDropdown(
                          label: "Адреса відділення *",
                          placeholder: "Введіть та оберіть відділення Нової Пошти",
                          items: getAddressesForCity(_cityController.text),
                          controller: _addressController,
                          validator: (value) {
                            final cityVal = _cityController.text.trim();
                            final val = value?.trim() ?? "";
                            if (FormValidators.isValidCity(cityVal) &&
                                getAddressesForCity(cityVal).contains(val)) {
                              return null;
                            }
                            return FormValidators.universalError;
                          },
                        ),
                        const SizedBox(height: 24),

                        const Row(
                          children: [
                            Icon(LucideIcons.creditCard, color: AppColors.foreground, size: 18),
                            SizedBox(width: 8),
                            Text("Оплата", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => setState(() {
                                  payMethod = "card";
                                  _checkFormValidity();
                                }),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: payMethod == "card" ? AppColors.secondary : Colors.white,
                                    border: Border.all(color: payMethod == "card" ? AppColors.primary : AppColors.border, width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(LucideIcons.creditCard, size: 16),
                                      SizedBox(width: 8),
                                      Text("Картка", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => setState(() {
                                  payMethod = "apple";
                                  _checkFormValidity();
                                }),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: payMethod == "apple" ? AppColors.secondary : Colors.white,
                                    border: Border.all(color: payMethod == "apple" ? AppColors.primary : AppColors.border, width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(LucideIcons.apple, size: 16),
                                      SizedBox(width: 8),
                                      Text("Apple Pay", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (payMethod == "card") ...[
                          const SizedBox(height: 16),
                          _buildField(
                            "Номер картки", 
                            _cardNumberController, 
                            "4242 4242 4242 4242", 
                            isNum: true,
                            validator: (value) => FormValidators.isValidCardNumber(value ?? "")
                                ? null
                                : FormValidators.universalError,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildField(
                                  "MM / YY", 
                                  _expiryController, 
                                  "12 / 27",
                                  validator: (value) => FormValidators.isValidExpiry(value ?? "")
                                      ? null
                                      : FormValidators.universalError,
                                )
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildField(
                                  "CVC", 
                                  _cvcController, 
                                  "123", 
                                  isNum: true,
                                  validator: (value) => FormValidators.isValidCvc(value ?? "")
                                      ? null
                                      : FormValidators.universalError,
                                )
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                
                // Sticky footer button
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    // Delivery cost calculation
                    double deliveryCost = 0;
                    const smallCats = {'Смартфони', 'Аудіо', 'Аксесуари'};
                    const medCats = {'Ноутбуки', 'Планшети', 'Плити', 'Міксери'};
                    const largeCats = {'Кавомашини', 'Печі', 'Холодильники', 'Посудомийки'};
                    for (final item in state.items) {
                      final cat = item.product.category;
                      double d = 0;
                      if (largeCats.contains(cat)) {
                        d = 350;
                      } else if (medCats.contains(cat)) {
                        d = 119;
                      } else if (smallCats.contains(cat)) {
                        d = 59;
                      }
                      if (d > deliveryCost) deliveryCost = d;
                    }
                    final total = state.subtotal + deliveryCost;
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: SafeArea(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text("До сплати", style: TextStyle(fontSize: 11, color: AppColors.mutedForeground)),
                                const SizedBox(height: 4),
                                Text("${total.toInt()} ₴", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.accent)),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isFormValid ? AppColors.accent : AppColors.mutedForeground,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              onPressed: _isFormValid ? _submit : null,
                              child: Text(payMethod == "apple" ? "Сплатити Apple Pay" : "Сплатити", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, String placeholder, {bool isPhone = false, bool isNum = false, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.mutedForeground)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: isPhone ? TextInputType.phone : (isNum ? TextInputType.number : TextInputType.text),
            validator: validator ?? (value) {
              if (value == null || value.trim().isEmpty) {
                return "Будь ласка, заповніть це поле";
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(color: AppColors.mutedForeground, fontSize: 13),
              filled: true,
              fillColor: AppColors.secondary,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    final menu = [
  {"icon": LucideIcons.package, "label": "Мої замовлення"},
  {"icon": LucideIcons.mapPin, "label": "Адреси доставки"},
  {"icon": LucideIcons.creditCard, "label": "Способи оплати"},
  {"icon": LucideIcons.settings, "label": "Налаштування"},
  {"icon": LucideIcons.logOut, "label": "Вихід"},
];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Акаунт", style: TextStyle(color: AppColors.foreground, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.foreground),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64.0 : 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile details card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.shadowSoft,
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primary,
                      child: Text("М", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Марія Скрипник", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text("maria@voltix.app", style: TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Menu list
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.shadowSoft,
                ),
                clipBehavior: Clip.antiAlias,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: menu.length,
                  separatorBuilder: (context, idx) => const Divider(height: 1, color: AppColors.border),
                  itemBuilder: (context, idx) {
                    final item = menu[idx];
                    return ListTile(
                      leading: Icon(item["icon"] as IconData, color: AppColors.mutedForeground, size: 20),
                      title: Text(item["label"] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      trailing: const Icon(LucideIcons.chevronRight, color: AppColors.mutedForeground, size: 16),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Сервіс '${item["label"]}' незабаром з'явиться!")),
                        );
                      },
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

// ----------------------------------------------------
// 8. HORECA SERVICES SCREEN
// ----------------------------------------------------
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

class HorecaDetailsScreen extends StatelessWidget {
  final String id;
  const HorecaDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final s = getHorecaItem(id);
    if (s == null) {
      return const Scaffold(body: Center(child: Text("Послугу не знайдено")));
    }

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
        title: Text(
          s.category,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.foreground,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64.0 : 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(12),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(s.image, fit: BoxFit.contain),
                    ),
                  ),
                  const Text("ПОСЛУГА", style: TextStyle(color: AppColors.mutedForeground, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(s.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(s.tagline, style: const TextStyle(fontSize: 14, color: AppColors.mutedForeground)),
                  const SizedBox(height: 20),

                  // Price card
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Row(
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
                              s.price == 0 ? "Безкоштовно" : "${s.price.toInt()} ₴",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          s.unit,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.mutedForeground,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Duration/Warranty stats row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            children: [
                              const Icon(LucideIcons.clock, color: AppColors.mutedForeground, size: 18),
                              const SizedBox(height: 6),
                              const Text("Тривалість", style: TextStyle(fontSize: 10, color: AppColors.mutedForeground)),
                              const SizedBox(height: 2),
                              Text(s.duration, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            children: [
                              const Icon(LucideIcons.shieldCheck, color: AppColors.mutedForeground, size: 18),
                              const SizedBox(height: 6),
                              const Text("Гарантія", style: TextStyle(fontSize: 10, color: AppColors.mutedForeground)),
                              const SizedBox(height: 2),
                              Text(s.warranty, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Text("Опис", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(s.description, style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.foreground)),
                  const SizedBox(height: 24),

                  const Text("Що входить", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Column(
                    children: s.includes.map((inc) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                              child: const Icon(LucideIcons.check, color: Colors.white, size: 10),
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: Text(inc, style: const TextStyle(fontSize: 13, color: AppColors.foreground))),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Bottom sticky container with order triggers (Only Order Service button, full width)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.shadowSoft,
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () => context.push('/checkout_service/${s.id}'),
                  child: const Text("Оформити послугу", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CheckoutServiceScreen extends StatefulWidget {
  final String id;
  const CheckoutServiceScreen({super.key, required this.id});

  @override
  State<CheckoutServiceScreen> createState() => _CheckoutServiceScreenState();
}

class _CheckoutServiceScreenState extends State<CheckoutServiceScreen> {
  bool isCompleted = false;
  bool _isFormValid = false;
  String payMethod = "card"; // card or apple

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();
  
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();
  
  String _lastCity = "";

  final Map<String, List<String>> cityAddresses = {
    'Київ': ['Відділення №1: вул. Пирогівський шлях, 135', 'Відділення №5: вул. Федорова, 32', 'Відділення №10: вул. Валерія Лобановського, 119'],
    'Львів': ['Відділення №1: вул. Городоцька, 355', 'Відділення №8: вул. Героїв УПА, 73'],
    'Одеса': ['Відділення №1: вул. Дальницька, 23/4', 'Відділення №15: вул. Тираспольська, 16'],
    'Харків': ['Відділення №1: вул. Польова, 67', 'Відділення №20: пр-т Гагаріна, 41/2'],
    'Дніпро': ['Відділення №1: вул. Маршала Малиновського, 114', 'Відділення №4: вул. Князя Ярослава Мудрого, 56'],
    'Запоріжжя': ['Відділення №1: вул. Аварійна, 11а', 'Відділення №3: вул. Айвазовського, 9'],
    'Івано-Франківськ': ['Відділення №1: вул. Мазепи, 175б', 'Відділення №5: вул. Галицька, 34б'],
    'Тернопіль': ['Відділення №1: вул. Подільська, 21', 'Відділення №7: вул. Медова, 3'],
  };

  List<String> getAddressesForCity(String city) {
    if (cityAddresses.containsKey(city)) {
      return cityAddresses[city]!;
    }
    return [
      'Відділення №1: вул. Central, 1',
      'Відділення №2: вул. Соборна, 15',
      'Відділення №3: пр-т Перемоги, 24',
    ];
  }

  void _checkFormValidity() {
    final nameOk = FormValidators.isValidName(_nameController.text);
    final phoneOk = FormValidators.isValidPhone(_phoneController.text);
    final cityOk = FormValidators.isValidCity(_cityController.text);
    final addressOk = _addressController.text.trim().isNotEmpty &&
        getAddressesForCity(_cityController.text.trim()).contains(_addressController.text.trim());
    final companyOk = FormValidators.isValidCompany(_companyController.text);
    final emailOk = FormValidators.isValidEmail(_emailController.text);
    final dateOk = FormValidators.isValidDate(_dateController.text);

    bool cardOk = true;
    if (payMethod == "card") {
      cardOk = FormValidators.isValidCardNumber(_cardNumberController.text) &&
               FormValidators.isValidExpiry(_expiryController.text) &&
               FormValidators.isValidCvc(_cvcController.text);
    }

    final valid = nameOk && phoneOk && cityOk && addressOk && companyOk && emailOk && dateOk && cardOk;
    if (valid != _isFormValid) {
      setState(() { _isFormValid = valid; });
    }
  }

  @override
  void initState() {
    super.initState();
    _cityController.addListener(() {
      if (_cityController.text != _lastCity) {
        _lastCity = _cityController.text;
        _addressController.clear();
      }
    });
    _nameController.addListener(_checkFormValidity);
    _companyController.addListener(_checkFormValidity);
    _phoneController.addListener(_checkFormValidity);
    _emailController.addListener(_checkFormValidity);
    _cityController.addListener(_checkFormValidity);
    _addressController.addListener(_checkFormValidity);
    _dateController.addListener(_checkFormValidity);
    _cardNumberController.addListener(_checkFormValidity);
    _expiryController.addListener(_checkFormValidity);
    _cvcController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  void _autofill() {
    setState(() {
      _nameController.text = "Марія Скрипник";
      _companyController.text = "Арома";
      _phoneController.text = "0951234567";
      _emailController.text = "maria@example.com";
      _cityController.text = "Київ";
      _addressController.text = "Відділення №1: вул. Пирогівський шлях, 135";
      _dateController.text = "03.06.2026";
      _cardNumberController.text = "4242424242424242";
      _expiryController.text = "12/27";
      _cvcController.text = "123";
    });
    _checkFormValidity();
  }

  void _submit() {
    // Simulated server-side validation check
    final nameOk = FormValidators.isValidName(_nameController.text);
    final phoneOk = FormValidators.isValidPhone(_phoneController.text);
    final cityOk = FormValidators.isValidCity(_cityController.text);
    final addressOk = _addressController.text.trim().isNotEmpty &&
        getAddressesForCity(_cityController.text.trim()).contains(_addressController.text.trim());
    final companyOk = FormValidators.isValidCompany(_companyController.text);
    final emailOk = FormValidators.isValidEmail(_emailController.text);
    final dateOk = FormValidators.isValidDate(_dateController.text);

    bool cardOk = true;
    if (payMethod == "card") {
      cardOk = FormValidators.isValidCardNumber(_cardNumberController.text) &&
               FormValidators.isValidExpiry(_expiryController.text) &&
               FormValidators.isValidCvc(_cvcController.text);
    }

    final isServerValid = nameOk && phoneOk && cityOk && addressOk && companyOk && emailOk && dateOk && cardOk;
    if (!isServerValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(FormValidators.universalError)),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() { isCompleted = true; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = getHorecaItem(widget.id);
    if (s == null) {
      return const Scaffold(body: Center(child: Text("Послугу не знайдено")));
    }

    final isDesktop = MediaQuery.of(context).size.width >= 768;

    if (isCompleted) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                  child: const Icon(LucideIcons.check, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 24),
                const Text("Дякуємо!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(
                  "Ваше замовлення на послугу «${s.name}» прийнято. Наш технолог зв'яжеться з вами найближчим часом.",
                  style: const TextStyle(fontSize: 14, color: AppColors.mutedForeground, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () => context.go('/horeca'),
                  child: const Text("До каталогу послуг", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Замовлення послуги", style: TextStyle(color: AppColors.foreground, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.foreground),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64.0 : 20.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service summary card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                          Container(
                            height: 60, width: 60,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(s.image, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(s.category.toUpperCase(), style: const TextStyle(fontSize: 8, color: AppColors.mutedForeground, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text(s.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text(s.price == 0 ? "Безкоштовно" : "${s.price.toInt()} ₴ / ${s.unit}", style: const TextStyle(fontSize: 11, color: AppColors.accent, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Autofill button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(LucideIcons.clipboardList, color: AppColors.foreground, size: 16),
                            SizedBox(width: 8),
                            Text("Контактні дані", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: _autofill,
                          icon: const Icon(LucideIcons.copy, size: 15),
                          label: const Text("Автозаповнення", style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Ім'я та прізвище
                    _buildField(
                      "Ім'я та прізвище *", _nameController, "Марія Скрипник",
                      validator: (value) => FormValidators.isValidName(value ?? "")
                          ? null
                          : FormValidators.universalError,
                    ),
                    _buildField(
                      "Назва закладу", _companyController, "Арома",
                      validator: (value) => FormValidators.isValidCompany(value ?? "")
                          ? null
                          : FormValidators.universalError,
                    ),

                    // Телефон + Email
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            "Телефон *", _phoneController, "0951234567", isPhone: true,
                            validator: (value) => FormValidators.isValidPhone(value ?? "")
                                ? null
                                : FormValidators.universalError,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildField(
                            "Email", _emailController, "you@example.com",
                            validator: (value) => FormValidators.isValidEmail(value ?? "")
                                ? null
                                : FormValidators.universalError,
                          ),
                        ),
                      ],
                    ),

                    // Місто — SearchableDropdown
                    SearchableDropdown(
                      label: "Місто *",
                      placeholder: "Введіть та оберіть місто",
                      items: ukraineLocations,
                      controller: _cityController,
                      validator: (value) => FormValidators.isValidCity(value ?? "")
                          ? null
                          : FormValidators.universalError,
                    ),

                    // Адреса — SearchableDropdown
                    SearchableDropdown(
                      label: "Адреса виконання *",
                      placeholder: "Введіть та оберіть адресу",
                      items: getAddressesForCity(_cityController.text),
                      controller: _addressController,
                      validator: (value) {
                        final cityVal = _cityController.text.trim();
                        final val = value?.trim() ?? "";
                        if (FormValidators.isValidCity(cityVal) &&
                            getAddressesForCity(cityVal).contains(val)) {
                          return null;
                        }
                        return FormValidators.universalError;
                      },
                    ),

                    _buildField(
                      "Бажана дата", _dateController, "ДД.ММ.РРРР",
                      validator: (value) => FormValidators.isValidDate(value ?? "")
                          ? null
                          : FormValidators.universalError,
                    ),
                    _buildField("Коментар", _notesController, "Деталі замовлення...", maxLines: 3),
                    const SizedBox(height: 24),

                    const Row(
                      children: [
                        Icon(LucideIcons.creditCard, color: AppColors.foreground, size: 18),
                        SizedBox(width: 8),
                        Text("Оплата", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => setState(() {
                              payMethod = "card";
                              _checkFormValidity();
                            }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: payMethod == "card" ? AppColors.secondary : Colors.white,
                                border: Border.all(color: payMethod == "card" ? AppColors.primary : AppColors.border, width: 2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(LucideIcons.creditCard, size: 16),
                                  SizedBox(width: 8),
                                  Text("Картка", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => setState(() {
                              payMethod = "apple";
                              _checkFormValidity();
                            }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: payMethod == "apple" ? AppColors.secondary : Colors.white,
                                border: Border.all(color: payMethod == "apple" ? AppColors.primary : AppColors.border, width: 2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(LucideIcons.apple, size: 16),
                                  SizedBox(width: 8),
                                  Text("Apple Pay", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (payMethod == "card") ...[
                      const SizedBox(height: 16),
                      _buildField(
                        "Номер картки", 
                        _cardNumberController, 
                        "4242 4242 4242 4242", 
                        isNum: true,
                        validator: (value) => FormValidators.isValidCardNumber(value ?? "")
                            ? null
                            : FormValidators.universalError,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildField(
                              "MM / YY", 
                              _expiryController, 
                              "12 / 27",
                              validator: (value) => FormValidators.isValidExpiry(value ?? "")
                                  ? null
                                  : FormValidators.universalError,
                            )
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildField(
                              "CVC", 
                              _cvcController, 
                              "123", 
                              isNum: true,
                              validator: (value) => FormValidators.isValidCvc(value ?? "")
                                  ? null
                                  : FormValidators.universalError,
                            )
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // Submit Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid ? AppColors.accent : AppColors.mutedForeground,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: _isFormValid ? _submit : null,
                    child: const Text("Підтвердити замовлення", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, String placeholder, {bool isPhone = false, bool isNum = false, int maxLines = 1, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.mutedForeground)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: isPhone ? TextInputType.phone : (isNum ? TextInputType.number : TextInputType.text),
            maxLines: maxLines,
            validator: validator ?? (value) {
              if (label.contains('*') && (value == null || value.trim().isEmpty)) {
                return "Невірно введені дані. Перевірте правильність заповнення поля.";
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(color: AppColors.mutedForeground, fontSize: 13),
              filled: true,
              fillColor: AppColors.secondary,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// 11. SUCCESS SCREEN
// ----------------------------------------------------
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.elasticOut,
                builder: (context, val, child) {
                  return Transform.scale(
                    scale: val,
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.check, color: Colors.white, size: 40),
                ),
              ),
              const SizedBox(height: 24),
              const Text("Замовлення прийнято", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                "Ми надіслали підтвердження на пошту.\nОчікуйте дзвінка кур'єра.",
                style: TextStyle(fontSize: 13, color: AppColors.mutedForeground, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () => context.go('/'),
                child: const Text("На головну", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchableDropdown extends StatefulWidget {
  final String label;
  final String placeholder;
  final List<String> items;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSelected;

  const SearchableDropdown({
    super.key,
    required this.label,
    required this.placeholder,
    required this.items,
    required this.controller,
    this.validator,
    this.onSelected,
  });

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    widget.controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(SearchableDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _filteredItems = widget.items;
      _overlayEntry?.markNeedsBuild();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _removeOverlay();
        }
      });
    }
  }

  void _onTextChanged() {
    if (!mounted) return;
    setState(() {
      final text = widget.controller.text.toLowerCase().trim();
      _filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(text))
          .toList();
    });
    _overlayEntry?.markNeedsBuild();
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  return ListTile(
                    title: Text(item, style: const TextStyle(fontSize: 13)),
                    dense: true,
                    onTap: () {
                      widget.controller.text = item;
                      if (widget.onSelected != null) {
                        widget.onSelected!(item);
                      }
                      _focusNode.unfocus();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.mutedForeground)),
            const SizedBox(height: 6),
            TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              validator: widget.validator,
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: const TextStyle(color: AppColors.mutedForeground, fontSize: 13),
                filled: true,
                fillColor: AppColors.secondary,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
