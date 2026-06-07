import 'package:flutter/material.dart';

Color parseHex(String hex) {
  try { return Color(int.parse(hex.replaceFirst('#', '0xff'))); } catch (_) { return Colors.grey; }
}

String getAvatarLetter(String? name, String? email) {
  if (name != null && name.trim().isNotEmpty) return name.trim()[0].toUpperCase();
  if (email != null && email.trim().isNotEmpty) return email.trim()[0].toUpperCase();
  return 'К';
}

Color getAvatarColor(String? identifier) {
  if (identifier == null || identifier.isEmpty) return Colors.blue;
  final palette = [Colors.red, Colors.pink, Colors.purple, Colors.deepPurple, Colors.indigo, Colors.blue, Colors.lightBlue, Colors.cyan, Colors.teal, Colors.green, Colors.lightGreen, Colors.amber, Colors.orange, Colors.deepOrange, Colors.brown];
  final hash = identifier.codeUnits.fold(0, (prev, elem) => prev + elem);
  return palette[hash % palette.length];
}

const Map<String, List<String>> cityAddresses = {
  'Київ': ['Відділення №1: вул. Пирогівський шлях, 135', 'Відділення №5: вул. Федорова, 32', 'Відділення №10: вул. Валерія Лобановського, 119'],
  'Львів': ['Відділення №1: вул. Городоцька, 355', 'Відділення №8: вул. Героїв УПА, 73'],
  'Одеса': ['Відділення №1: вул. Дальницька, 23/4', 'Відділення №15: вул. Тираспольська, 16'],
  'Харків': ['Відділення №1: вул. Польова, 67', 'Відділення №20: пр-т Гагаріна, 41/2'],
  'Дніпро': ['Відділення №1: вул. Маршала Малиновського, 114', 'Відділення №4: вул. Князя Ярослава Мудрого, 56'],
  'Запоріжжя': ['Відділення №1: вул. Аварійна, 11а', 'Відділення №3: вул. Айвазовського, 9'],
  'Івано-Франківськ': ['Відділення №1: вул. Мазепи, 175б', 'Відділення №5: вул. Галицька, 34б'],
  'Тернопіль': ['Відділення №1: вул. Подільська, 21', 'Відділення №7: вул. Медова, 3'],
};

List<String> getAddressesForCity(String city) {
  if (cityAddresses.containsKey(city)) return cityAddresses[city]!;
  return ['Відділення №1: вул. Центральна, 1', 'Відділення №2: вул. Соборна, 15', 'Відділення №3: пр-т Перемоги, 24'];
}
