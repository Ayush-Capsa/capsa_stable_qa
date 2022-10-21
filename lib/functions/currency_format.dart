
import 'package:intl/intl.dart';

String formatCurrency(dynamic value,{ withIcon : false }) {
  if(value == null) return '';
  try {
    value = num.tryParse(value.toString());
    value = num.tryParse(value.toStringAsFixed(2));
  }catch (e) { return ''; }

  int _decimalDigits = 0;

  try {
    var dec = num.tryParse(value.toString().split('.')[1]);
    // capsaPrint('dec');
    // capsaPrint(dec.toString().length);
    _decimalDigits = dec.toString().length;
    if(_decimalDigits == 1 ) _decimalDigits = 2;
  } catch (e) {}

  final numberFormat = NumberFormat.currency(locale: "en_US", symbol: "", decimalDigits: _decimalDigits);
  if(withIcon)  return '₦ ${numberFormat.format(value)}';
  return '${numberFormat.format(value)}';
}

bool stringToBool(String s){
  try{
    int n = int.parse(s);
    if(n == 1) {
      return true;
    } else {
      return false;
    }
  }catch(e){
    return false;
  }
}