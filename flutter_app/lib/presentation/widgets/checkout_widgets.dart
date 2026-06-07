import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../utils/form_validators.dart';

class CheckoutTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String placeholder;
  final bool isPhone;
  final bool isNum;
  final int maxLines;
  final String? Function(String?)? validator;

  const CheckoutTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.placeholder,
    this.isPhone = false,
    this.isNum = false,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: isPhone
                ? TextInputType.phone
                : (isNum ? TextInputType.number : TextInputType.text),
            maxLines: maxLines,
            validator: validator ??
                (value) {
                  if (label.contains('*') && (value == null || value.trim().isEmpty)) {
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
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

class PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => onChanged("card"),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: selectedMethod == "card" ? AppColors.secondary : Colors.white,
                border: Border.all(
                  color: selectedMethod == "card" ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
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
            onTap: () => onChanged("apple"),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: selectedMethod == "apple" ? AppColors.secondary : Colors.white,
                border: Border.all(
                  color: selectedMethod == "apple" ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
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
    );
  }
}

class CardDetailsForm extends StatelessWidget {
  final TextEditingController cardNumberController;
  final TextEditingController expiryController;
  final TextEditingController cvcController;

  const CardDetailsForm({
    super.key,
    required this.cardNumberController,
    required this.expiryController,
    required this.cvcController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        CheckoutTextField(
          label: "Номер картки",
          controller: cardNumberController,
          placeholder: "4242 4242 4242 4242",
          isNum: true,
          validator: (value) => FormValidators.isValidCardNumber(value ?? "")
              ? null
              : FormValidators.universalError,
        ),
        Row(
          children: [
            Expanded(
              child: CheckoutTextField(
                label: "MM / YY",
                controller: expiryController,
                placeholder: "12 / 27",
                validator: (value) => FormValidators.isValidExpiry(value ?? "")
                    ? null
                    : FormValidators.universalError,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CheckoutTextField(
                label: "CVC",
                controller: cvcController,
                placeholder: "123",
                isNum: true,
                validator: (value) => FormValidators.isValidCvc(value ?? "")
                    ? null
                    : FormValidators.universalError,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
