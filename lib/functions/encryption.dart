

import 'custom_print.dart';

String encryptList(List<dynamic> list){

  String encryptedString = '';
  for(int i = 0;i<list.length;i++){
    if(i == 0){
      encryptedString += list[i].toString();
    }else{
      encryptedString += '-' + list[i].toString();
    }
  }

  return encryptedString;

}

List<String> decryptList(String encryptedString){

  capsaPrint('Encrypted String $encryptedString');

  List<String> decryptedString = [];
  String s = '';
  for(int i = 0;i<encryptedString.length;i++){
    String c = encryptedString[i];
   if(c!='-'){
     s += c;
   }else{
     decryptedString.add(s);
     s = '';
   }


  }
  decryptedString.add(s);


  capsaPrint('Decrypted String : $decryptedString');

  return decryptedString;

}