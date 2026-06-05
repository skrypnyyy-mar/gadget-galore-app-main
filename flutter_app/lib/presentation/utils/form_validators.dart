import '../../data/mock/ukraine_locations.dart';

class FormValidators {
  static const String universalError = "Невірно введені дані. Перевірте правильність заповнення поля.";

  static final RegExp _nameRegex = RegExp(r"^[A-ZА-ЯІЄЇҐ][a-zа-яієїґ'\u2019`\x27\-]+$");
  static final RegExp _phoneRegex = RegExp(r'^0\d{9}$');
  static final RegExp _cardRegex = RegExp(r'^\d{16}$');
  static final RegExp _expiryRegex = RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$');
  static final RegExp _cvcRegex = RegExp(r'^\d{3}$');
  static final RegExp _companyRegex = RegExp(r'^[А-ЯІЄЇЄа-яіїє\s]+$');
  static final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final RegExp _dateRegex = RegExp(r'^(0[1-9]|[12][0-9]|3[01])\.(0[1-9]|1[0-2])\.\d{4}$');

  static bool isValidName(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));
    return parts.length == 2 && _nameRegex.hasMatch(parts[0]) && _nameRegex.hasMatch(parts[1]);
  }

  static bool isValidPhone(String value) => _phoneRegex.hasMatch(value.trim());

  static bool isValidCardNumber(String value) => _cardRegex.hasMatch(value.trim());

  static bool isValidExpiry(String value) => _expiryRegex.hasMatch(value.trim());

  static bool isValidCvc(String value) => _cvcRegex.hasMatch(value.trim());

  static bool isValidCompany(String value) {
    final val = value.trim();
    return val.isEmpty || _companyRegex.hasMatch(val);
  }

  static bool isValidEmail(String value) {
    final val = value.trim();
    return val.isEmpty || _emailRegex.hasMatch(val);
  }

  static bool isValidDate(String value) {
    final val = value.trim();
    return val.isEmpty || _dateRegex.hasMatch(val);
  }

  static bool isValidCity(String value) => ukraineLocations.contains(value.trim());
}
