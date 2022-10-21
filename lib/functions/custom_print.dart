
import 'package:flutter/foundation.dart';

capsaPrint(Object object){
  if(kDebugMode){
    print(object);
  }
  else {
    return null;
  }
}