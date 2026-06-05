import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 768;
        return Scaffold(
          appBar: isDesktop ? const TopNavBar() : null,
          body: child,
          bottomNavigationBar: isDesktop ? null : const BottomNavBar(),
        );
      },
    );
  }
}
