import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/mock/horeca_data.dart';
import '../../core/theme/app_colors.dart';

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
