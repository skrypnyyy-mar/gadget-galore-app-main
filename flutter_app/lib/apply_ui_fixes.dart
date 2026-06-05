import 'dart:io';

void main() {
  var sPath = 'lib/presentation/screens/screens.dart';
  var pPath = 'lib/presentation/widgets/product_card.dart';
  var bPath = 'lib/presentation/widgets/bottom_nav_bar.dart';
  
  var sContent = File(sPath).readAsStringSync();
  // 1. Text replacements
  sContent = sContent.replaceAll('"Сучасна техніка та HoReCa обладнання"', '"Сучасна техніка та обладнання"');
  sContent = sContent.replaceAll('"Послуги HoReCa"', '"Послуги"');
  sContent = sContent.replaceAll('"Олександр Коваль"', '"Марія Скрипник"');
  sContent = sContent.replaceAll('"oleksandr@voltix.app"', '"maria@voltix.app"');
  sContent = sContent.replaceAll('Text("О",', 'Text("М",');
  
  // 2. Price formats
  sContent = sContent.replaceAll(r'"\$${(product.price * quantity).toInt()}"', r'"${(product.price * quantity).toInt()} грн"');
  sContent = sContent.replaceAll(r'"\$${item.product.price.toInt()}"', r'"${item.product.price.toInt()} грн"');
  sContent = sContent.replaceAll(r'"\$${subtotal.toInt()}"', r'"${subtotal.toInt()} грн"');
  sContent = sContent.replaceAll(r'"\$15"', r'"15 грн"');
  sContent = sContent.replaceAll(r'"\$${total.toInt()}"', r'"${total.toInt()} грн"');
  sContent = sContent.replaceAll(r'"\$${s.price}"', r'"${s.price} грн"');
  sContent = sContent.replaceAll(r'"\$${s.price} / ${s.unit}"', r'"${s.price} грн / ${s.unit}"');
  
  // ChoiceChip padding fix
  sContent = sContent.replaceAll('child: ChoiceChip(', 'child: ChoiceChip(\n                        labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),');

  // GestureDetector to InkWell for hover
  sContent = sContent.replaceAll('GestureDetector(', 'InkWell(\nborderRadius: BorderRadius.circular(20),');
  
  File(sPath).writeAsStringSync(sContent);

  // Bottom Nav Bar fixes
  var bContent = File(bPath).readAsStringSync();
  bContent = bContent.replaceAll('GestureDetector(', 'InkWell(\nborderRadius: BorderRadius.circular(12),');
  File(bPath).writeAsStringSync(bContent);

  // Product Card fixes
  var pContent = File(pPath).readAsStringSync();
  pContent = pContent.replaceAll('GestureDetector(', 'InkWell(\nborderRadius: BorderRadius.circular(16),');
  pContent = pContent.replaceAll("NumberFormat.currency(symbol: '\\\$', decimalDigits: 0)", "NumberFormat.currency(symbol: ' грн', decimalDigits: 0, customPattern: '#,##0 \u00A4')");
  File(pPath).writeAsStringSync(pContent);
  
  print('Done');
}
