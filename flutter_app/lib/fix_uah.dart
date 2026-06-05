import 'dart:io';

void main() {
  var sPath = 'lib/presentation/screens/screens.dart';
  var sContent = File(sPath).readAsStringSync();
  
  // Replace the broken cyrillic string inserted by the last script
  sContent = sContent.replaceAll('\uFFFD\uFFFD\uFFFD', '\u0433\u0440\u043D');
  
  // Remove double padding and fix height
  sContent = sContent.replaceAll(
    'labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),\n                        labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),', 
    'labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),'
  );
  sContent = sContent.replaceAll('height: 38,', 'height: 48,'); // Fix chip height
  
  // Replace $ with грн
  sContent = sContent.replaceAll(r'"\$${(product.price * quantity).toInt()}"', r'"${(product.price * quantity).toInt()} \u0433\u0440\u043D"');
  sContent = sContent.replaceAll(r'"\$${item.product.price.toInt()}"', r'"${item.product.price.toInt()} \u0433\u0440\u043D"');
  sContent = sContent.replaceAll(r'"\$${subtotal.toInt()}"', r'"${subtotal.toInt()} \u0433\u0440\u043D"');
  sContent = sContent.replaceAll(r'"\$15"', r'"15 \u0433\u0440\u043D"');
  sContent = sContent.replaceAll(r'"\$${total.toInt()}"', r'"${total.toInt()} \u0433\u0440\u043D"');
  sContent = sContent.replaceAll(r'"\$${s.price}"', r'"${s.price} \u0433\u0440\u043D"');
  sContent = sContent.replaceAll(r'"\$${s.price} / ${s.unit}"', r'"${s.price} \u0433\u0440\u043D / ${s.unit}"');

  // "Сучасна техніка та HoReCa обладнання"
  sContent = sContent.replaceAll('\u0421\u0443\u0447\u0430\u0441\u043D\u0430 \u0442\u0435\u0445\u043D\u0456\u043A\u0430 \u0442\u0430 HoReCa \u043E\u0431\u043B\u0430\u0434\u043D\u0430\u043D\u043D\u044F', '\u0421\u0443\u0447\u0430\u0441\u043D\u0430 \u0442\u0435\u0445\u043D\u0456\u043A\u0430 \u0442\u0430 \u043E\u0431\u043B\u0430\u0434\u043D\u0430\u043D\u043D\u044F');
  
  // "Послуги HoReCa" -> "Послуги"
  sContent = sContent.replaceAll('\u041F\u043E\u0441\u043B\u0443\u0433\u0438 HoReCa', '\u041F\u043E\u0441\u043B\u0443\u0433\u0438');
  
  // "Олександр Коваль" -> "Марія Скрипник"
  sContent = sContent.replaceAll('\u041E\u043B\u0435\u043A\u0441\u0430\u043D\u0434\u0440 \u041A\u043E\u0432\u0430\u043B\u044C', '\u041C\u0430\u0440\u0456\u044F \u0421\u043A\u0440\u0438\u043F\u043D\u0438\u043A');
  
  // oleksandr@voltix.app -> maria@voltix.app
  sContent = sContent.replaceAll('oleksandr@voltix.app', 'maria@voltix.app');
  
  // Text("О", -> Text("М", 
  sContent = sContent.replaceAll('Text("\u041E",', 'Text("\u041C",');

  File(sPath).writeAsStringSync(sContent);
}
