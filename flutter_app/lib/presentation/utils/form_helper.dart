import 'package:flutter/material.dart';
import '../screens/screens.dart'; // For FormValidators

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
