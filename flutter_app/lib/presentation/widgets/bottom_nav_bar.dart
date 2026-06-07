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
    final path = GoRouterState.of(context).uri.path;
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9), border: const Border(top: BorderSide(color: AppColors.border))),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Nav(icon: LucideIcons.home, label: "Головна", isActive: path == '/', onTap: () => context.go('/')),
              _Nav(icon: LucideIcons.shoppingBag, label: "Кошик", isActive: path.startsWith('/cart'), onTap: () => context.go('/cart'), showBadge: true),
              _Nav(icon: LucideIcons.heart, activeIcon: Icons.favorite, label: "Обране", isActive: path.startsWith('/favorites'), onTap: () => context.go('/favorites')),
              _Nav(icon: LucideIcons.user, label: "Акаунт", isActive: path.startsWith('/account'), onTap: () => context.go('/account')),
            ],
          ),
        ),
      ),
    );
  }
}

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  const TopNavBar({super.key});
  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    return Container(
      decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: AppColors.border))),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12), onTap: () => context.go('/'),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(colors: [Color(0xFF1976D2), Color(0xFF42A5F5)]).createShader(bounds),
                  child: const Text("Voltix", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, letterSpacing: -1.0, color: Colors.white)),
                ),
              ),
              Row(
                children: [
                  _Nav(icon: LucideIcons.home, label: "Головна", isActive: path == '/', onTap: () => context.go('/'), horizontal: true),
                  const SizedBox(width: 24),
                  _Nav(icon: LucideIcons.shoppingBag, label: "Кошик", isActive: path.startsWith('/cart'), onTap: () => context.go('/cart'), showBadge: true, horizontal: true),
                  const SizedBox(width: 24),
                  _Nav(icon: LucideIcons.heart, activeIcon: Icons.favorite, label: "Обране", isActive: path.startsWith('/favorites'), onTap: () => context.go('/favorites'), horizontal: true),
                  const SizedBox(width: 24),
                  _Nav(icon: LucideIcons.user, label: "Акаунт", isActive: path.startsWith('/account'), onTap: () => context.go('/account'), horizontal: true),
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

class _Nav extends StatelessWidget {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final bool isActive, showBadge, horizontal;
  final VoidCallback onTap;
  const _Nav({required this.icon, this.activeIcon, required this.label, required this.isActive, required this.onTap, this.showBadge = false, this.horizontal = false});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Theme.of(context).colorScheme.primary : AppColors.mutedForeground;
    final iconWidget = Stack(
      clipBehavior: Clip.none,
      children: [
        isActive && activeIcon != null ? Icon(activeIcon, color: AppColors.accent, size: horizontal ? 18 : 24) : Icon(icon, color: color, size: horizontal ? 18 : 24),
        if (showBadge)
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state.totalItems == 0) return const SizedBox.shrink();
              return Positioned(
                right: -6, top: horizontal ? -6 : -4,
                child: Container(
                  padding: EdgeInsets.all(horizontal ? 2 : 4),
                  decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                  constraints: BoxConstraints(minWidth: horizontal ? 12 : 16, minHeight: horizontal ? 12 : 16),
                  child: Center(child: Text('${state.totalItems}', style: TextStyle(color: Colors.white, fontSize: horizontal ? 8 : 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                ),
              );
            },
          ),
      ],
    );
    return InkWell(
      borderRadius: BorderRadius.circular(12), onTap: onTap,
      child: horizontal
          ? Row(mainAxisSize: MainAxisSize.min, children: [iconWidget, const SizedBox(width: 8), Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color))])
          : Column(mainAxisSize: MainAxisSize.min, children: [iconWidget, const SizedBox(height: 4), Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color))]),
    );
  }
}
