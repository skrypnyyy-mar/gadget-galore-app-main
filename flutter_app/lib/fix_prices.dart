import 'dart:io';

void main() {
  var pPath = 'lib/data/mock/products_data.dart';
  var hPath = 'lib/data/mock/horeca_data.dart';
  
  var pContent = File(pPath).readAsStringSync();
  var pPrices = [44999, 79999, 12499, 15999, 8999, 32999, 49999, 25999, 54999, 39999, 28999, 41999, 18999, 11999, 65999, 94999, 14599, 8599];
  for (var p in pPrices) {
    pContent = pContent.replaceFirst('price: 34999,', 'price: ${p.toDouble()},');
  }
  File(pPath).writeAsStringSync(pContent);

  var hContent = File(hPath).readAsStringSync();
  var hPrices = [1200, 2500, 1500, 18000, 4500, 2500, 0, 3000];
  for (var p in hPrices) {
    hContent = hContent.replaceFirst('price: 1500,', 'price: ${p.toDouble()},');
  }
  File(hPath).writeAsStringSync(hContent);
}
