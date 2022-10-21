import  'package:capsa/admin/data/buyer_vendor_list_data.dart';
import 'package:flutter/foundation.dart';

class EditTableDataProvider extends ChangeNotifier {
  BuyerVendorListDataSource l;
  void setData(BuyerVendorListDataSource data) {
    l = data;
    notifyListeners();
  }

  BuyerVendorListDataSource get listData => l;
}
