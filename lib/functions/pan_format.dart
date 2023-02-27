
String panFormat(String pan){
  String result = '';
  for(int i = 0;i<pan.length;i++){
    if(pan[i]!='-') {
      result = result + pan[i];
    }else{
      i = pan.length + 1;
    }
  }
  return result;
}