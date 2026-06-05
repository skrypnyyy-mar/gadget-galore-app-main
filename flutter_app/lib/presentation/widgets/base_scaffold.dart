import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A simple reusable scaffold used across the app.
///
/// - [title] – optional title displayed in the AppBar.
/// - [body] – main content of the screen.
/// - [floatingActionButton] – optional FAB.
/// - [bottomNavigationBar] – optional bottom navigation bar.
class BaseScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const BaseScaffold({
    this.title,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: title != null
          ? AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              title: Text(title!, style: const TextStyle(fontWeight: FontWeight.bold)),
            )
          : null,
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
