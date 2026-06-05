import 'dart:io';

void main() {
  var sPath = 'lib/presentation/screens/screens.dart';
  var sContent = File(sPath).readAsStringSync();
  
  // Replace the exact strings we know are there
  sContent = sContent.replaceAll('"Сучасна техніка та HoReCa обладнання"', '"Сучасна техніка та обладнання"');
  sContent = sContent.replaceAll('"Послуги HoReCa"', '"Послуги"');
  sContent = sContent.replaceAll('"Олександр Коваль"', '"Марія Скрипник"');
  sContent = sContent.replaceAll('"oleksandr@voltix.app"', '"maria@voltix.app"');
  sContent = sContent.replaceAll('Text("О",', 'Text("М",');
  
  // ChoiceChip padding fix
  sContent = sContent.replaceAll('child: ChoiceChip(', 'child: ChoiceChip(\n                        labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),');

  // Fix the corrupted symbol by matching the exact unicode character \uFFFD
  sContent = sContent.replaceAll('\uFFFD\uFFFD\uFFFD', 'грн');

  File(sPath).writeAsStringSync(sContent);
}
