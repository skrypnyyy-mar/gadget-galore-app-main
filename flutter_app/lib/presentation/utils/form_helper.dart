import 'package:flutter/material.dart';
import 'form_validators.dart';

/// Returns a [Widget] that builds a [TextFormField] with the provided
/// [label], [controller] and optional validation.
Widget buildValidatedField({
  required String label,
  required TextEditingController controller,
  String? hint,
  bool isNum = false,
  bool isPhone = false,
  int? maxLines,
  String? Function(String?)? validator,
}) {
  return _buildField(
    label,
    controller,
    hint ?? '',
    isNum: isNum,
    isPhone: isPhone,
    maxLines: maxLines,
    validator: validator ?? (value) => FormValidators.universalError,
  );
}

Widget _buildField(
  String label,
  TextEditingController controller,
  String placeholder, {
  bool isPhone = false,
  bool isNum = false,
  int? maxLines,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: isPhone ? TextInputType.phone : (isNum ? TextInputType.number : TextInputType.text),
          maxLines: maxLines ?? 1,
          validator: validator,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 1.5),
            ),
          ),
        ),
      ],
    ),
  );
}
