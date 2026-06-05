import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'app_button.dart';

/// Button representing a payment method (e.g., Apple Pay, Card).
class PaymentMethodButton extends StatelessWidget {
  final String method;
  final bool selected;
  final VoidCallback onTap;
  final IconData icon;

  const PaymentMethodButton({
    required this.method,
    required this.selected,
    required this.onTap,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: method,
      onPressed: onTap,
      icon: icon,
      backgroundColor:
          selected ? AppColors.accent : AppColors.background,
      foregroundColor:
          selected ? Colors.white : AppColors.mutedForeground,
      borderRadius: BorderRadius.circular(30),
    );
  }
}

/// Footer with a single submit button that respects form validity.
class CheckoutFooter extends StatelessWidget {
  final bool isFormValid;
  final VoidCallback onSubmit;

  const CheckoutFooter({
    required this.isFormValid,
    required this.onSubmit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: AppButton(
            label: 'Підтвердити замовлення',
            onPressed: isFormValid ? onSubmit : () {},
            backgroundColor: isFormValid
                ? AppColors.accent
                : AppColors.mutedForeground,
          ),
        ),
      ),
    );
  }
}

/// Dropdown widget with built‑in validation using the FormHelper.
class ValidatedDropdown extends StatelessWidget {
  final String label;
  final String placeholder;
  final List<String> items;
  final TextEditingController controller;
  final String? Function(String?) validator;

  const ValidatedDropdown({
    required this.label,
    required this.placeholder,
    required this.items,
    required this.controller,
    required this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SearchableDropdown(
      label: label,
      placeholder: placeholder,
      items: items,
      controller: controller,
      validator: validator,
    );
  }
}
