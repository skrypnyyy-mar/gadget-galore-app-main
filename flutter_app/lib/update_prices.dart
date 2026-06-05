import 'dart:io';

void main() {
  var pPath = 'lib/data/mock/products_data.dart';
  var hPath = 'lib/data/mock/horeca_data.dart';

  // Update product prices
  var pContent = File(pPath).readAsStringSync();
  pContent = pContent.replaceAllMapped(RegExp(r'price: ([\\d\\.]+),'), (match) {
    var val = double.parse(match.group(1)!);
    var newVal = (val * 40).round();
    return 'price: $newVal,';
  });
  File(pPath).writeAsStringSync(pContent);

  // Update horeca service prices
  var hContent = File(hPath).readAsStringSync();
  hContent = hContent.replaceAllMapped(RegExp(r'price: ([\\d\\.]+),'), (match) {
    var val = double.parse(match.group(1)!);
    var newVal = (val * 40).round();
    return 'price: $newVal,';
  });
  File(hPath).writeAsStringSync(hContent);
}
