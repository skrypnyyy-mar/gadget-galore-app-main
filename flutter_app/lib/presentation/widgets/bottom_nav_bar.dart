import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/cart/cart_state.dart';
import '../../core/theme/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
        border: const Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: LucideIcons.home,
                label: "Головна",
                isActive: location == '/',
                onTap: () => context.go('/'),
              ),
              _NavItem(
                icon: LucideIcons.shoppingBag,
                label: "Кошик",
                isActive: location.startsWith('/cart'),
                onTap: () => context.go('/cart'),
                showBadge: true,
              ),
              _NavItem(
                icon: LucideIcons.heart,
                activeIcon: Icons.favorite,
                label: "Обране",
                isActive: location.startsWith('/favorites'),
                onTap: () => context.go('/favorites'),
              ),
              _NavItem(
                icon: LucideIcons.user,
                label: "Акаунт",
                isActive: location.startsWith('/account'),
                onTap: () => context.go('/account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool showBadge;

  const _NavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isActive ? theme.colorScheme.primary : AppColors.mutedForeground;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              isActive && activeIcon != null
                  ? Icon(activeIcon, color: AppColors.accent, size: 24)
                  : Icon(icon, color: color, size: 24),
              if (showBadge)
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    if (state.totalItems == 0) return const SizedBox.shrink();
                    return Positioned(
                      right: -6,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Center(
                          child: Text(
                            '${state.totalItems}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  const TopNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => context.go('/'),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                  ).createShader(bounds),
                  child: const Text(
                    "Voltix",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      letterSpacing: -1.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  _TopNavItem(
                    icon: LucideIcons.home,
                    label: "Головна",
                    isActive: location == '/',
                    onTap: () => context.go('/'),
                  ),
                  const SizedBox(width: 24),
                  _TopNavItem(
                    icon: LucideIcons.shoppingBag,
                    label: "Кошик",
                    isActive: location.startsWith('/cart'),
                    onTap: () => context.go('/cart'),
                    showBadge: true,
                  ),
                  const SizedBox(width: 24),
                  _TopNavItem(
                    icon: LucideIcons.heart,
                    activeIcon: Icons.favorite,
                    label: "Обране",
                    isActive: location.startsWith('/favorites'),
                    onTap: () => context.go('/favorites'),
                  ),
                  const SizedBox(width: 24),
                  _TopNavItem(
                    icon: LucideIcons.user,
                    label: "Акаунт",
                    isActive: location.startsWith('/account'),
                    onTap: () => context.go('/account'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _TopNavItem extends StatelessWidget {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool showBadge;

  const _TopNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isActive ? theme.colorScheme.primary : AppColors.mutedForeground;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              isActive && activeIcon != null
                  ? Icon(activeIcon, color: AppColors.accent, size: 18)
                  : Icon(icon, color: color, size: 18),
              if (showBadge)
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    if (state.totalItems == 0) return const SizedBox.shrink();
                    return Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Center(
                          child: Text(
                            '${state.totalItems}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
