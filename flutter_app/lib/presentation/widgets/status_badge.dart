import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool isService;

  const StatusBadge({
    super.key,
    required this.status,
    this.isService = false,
  });

  String get _label {
    if (isService) return status;
    switch (status) {
      case 'PENDING': return 'Очікує';
      case 'PROCESSING': return 'Обробляється';
      case 'SHIPPED': return 'Відправлено';
      case 'DELIVERED': return 'Доставлено';
      case 'CANCELLED': return 'Скасовано';
      default: return status;
    }
  }

  Color get _color {
    if (isService) {
      if (status == 'Активне' || status == 'Завершено') return AppColors.accent;
      if (status == 'В процесі' || status == 'Обробляється') return Colors.blue;
      return AppColors.mutedForeground;
    }
    switch (status) {
      case 'PENDING': return Colors.orange;
      case 'PROCESSING': return Colors.blue;
      case 'SHIPPED': return AppColors.primary;
      case 'DELIVERED': return AppColors.accent;
      case 'CANCELLED': return Colors.red;
      default: return AppColors.mutedForeground;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
