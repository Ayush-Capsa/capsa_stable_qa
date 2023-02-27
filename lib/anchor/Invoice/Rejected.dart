import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/export_to_csv.dart';
import 'package:csv/csv.dart';
import 'package:flutter/gestures.dart';
import 'package:capsa/anchor/Helpers/dialogHelper.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/anchor/Components/textStyles.dart';
import 'package:provider/provider.dart';

class rejectedScreen extends StatefulWidget {
  const rejectedScreen({Key key}) : super(key: key);

  @override
  _rejectedScreenState createState() => _rejectedScreenState();
}

class _rejectedScreenState extends State<rejectedScreen> {

  List<TableRow> rows = [];
  bool _dataLoaded = false;
  var _numberOfPages;
  var _currentIndex;
  List<AcctTableData> _acctTable = [];
  List<AcctTableData> _fetchedAcctTable = [];
  var anchorsActions;
  String search = "";

  void createCSV(){
    // final find = ',';
    // final replaceWith = '';
    List<List<dynamic>> csv_rows = [];
    csv_rows.add(["S/N", "Invoice No.", "Vendor Name", "Issue Date", "Invoice Amount (in Naira)", "Due Date","Tenure","Rejected By"]);
    for (int i = 0; i < _acctTable.length; i++) {
      List<dynamic> row = [];
      row.add((i + 1).toString());
      row.add(_acctTable[i].invNo!=null?_acctTable[i].invNo.toString():" ");
      row.add(_acctTable[i].vendor!=null?_acctTable[i].vendor.toString():" ");
      row.add(_acctTable[i].invDate!=null?_acctTable[i].invDate.toString():" ");
      row.add(_acctTable[i].invAmt!=null?formatCurrency(_acctTable[i].invAmt):" ");
      row.add(_acctTable[i].invDueDate!=null?_acctTable[i].invDueDate.toString():" ");
      row.add(_acctTable[i].tenure!=null?_acctTable[i].tenure.toString():" ");
      row.add(_acctTable[i].approvedBy!=null?_acctTable[i].approvedBy:" ");
      csv_rows.add(row);
    }
    String dataAsCSV = const ListToCsvConverter().convert(
      csv_rows,
    );
    exportToCSV(dataAsCSV, fName: "Rejected Invoice");
  }

  void getData(BuildContext context) async{
    rows = [];
    rows.add(
        TableRow(children: [
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text('S/N', style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text('Invoice No', style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text('Vendor Name', style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text('Issue Date', style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text('Invoice Amount', style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text('Due Date', style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text('Tenure', style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5, bottom: 16),
            child: Text('Rejected By', style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(' ', style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 152, 217, 1),
            )),
          )
        ])
    );

    anchorsActions = Provider.of<AnchorActionProvider>(context,listen: false);
    if(_fetchedAcctTable.isEmpty) {
      _fetchedAcctTable = await anchorsActions.queryInvoiceList(4);
    }
    _acctTable = anchorsActions.searchData(_fetchedAcctTable,search,context);

    var limit = 8<_acctTable.length?8:_acctTable.length;
    for(int i = 0;i<limit;i++){
      rows.add(
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text((i+1).toString()==null?" ":(i+1).toString(), style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text(_acctTable[i].invNo.toString()==null?" ":_acctTable[i].invNo.toString(), style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text(_acctTable[i].vendor.toString()==null?" ":_acctTable[i].vendor.toString(), style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text(_acctTable[i].invDate.toString()==null?" ":_acctTable[i].invDate.toString(), style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text("₦ "+_acctTable[i].invAmt.toString()==null?" ":"₦ " + formatCurrency(_acctTable[i].invAmt), style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text(_acctTable[i].invDueDate.toString()==null?" ":_acctTable[i].invDueDate.toString(), style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text(_acctTable[i].tenure.toString()==null?" ":_acctTable[i].tenure.toString(), style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text(_acctTable[i].approvedBy.toString()==null?" ":_acctTable[i].approvedBy.toString(), style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              )),
            ),
            Padding(
                padding: const EdgeInsets.only(right: 16,top: 8),
                child: PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        child: InkWell(
                          onTap: () {
                            capsaPrint('view Tapped');
                            setState(() {
                              dialogHelper.showPdf(context,anchorsActions, _acctTable[i].fileName);
                            });
                          },
                          child: Row(
                            children: [
                              Icon(Icons.remove_red_eye),
                              RichText(
                                text: TextSpan(
                                  text: 'View Invoice',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(51, 51, 51, 1)),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ],
                )
            )
          ])
      );
    }

    if(_acctTable.length%10 == 0){
      _numberOfPages = (_acctTable.length/10).toInt();
    }

    else {
      _numberOfPages = (_acctTable.length/10 + 1).floor();
    }

    _currentIndex = 1;


    setState(() {
      _dataLoaded = true;
    });

  }

  void _nextPage(){
    if(_currentIndex<_numberOfPages){
      setState(() {
        _dataLoaded = false;
      });
      rows = [];
      rows.add(
          TableRow(children: [
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text('S/N', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Invoice No', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Vendor Name', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Issue Date', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Invoice Amount', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Due Date', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Tenure', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
            ),
            Container(
              padding: const EdgeInsets.only(top: 5, bottom: 16),
              child: Text('Rejected By', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text(' ', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
            )
          ])
      );
      _currentIndex++;
      int limit = 8<(_acctTable.length - (_currentIndex - 1)*8)?8:(_acctTable.length - (_currentIndex - 1)*8);

      for(int i = (_currentIndex-1) * 8;i<((_currentIndex - 1)*8) + limit;i++){
        rows.add(
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Text((i+1).toString()==null?" ":(i+1).toString(), style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Text(_acctTable[i].invNo.toString()==null?" ":_acctTable[i].invNo.toString(), style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Text(_acctTable[i].vendor.toString()==null?" ":_acctTable[i].vendor.toString(), style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Text(_acctTable[i].invDate.toString()==null?" ":_acctTable[i].invDate.toString(), style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Text("₦ "+_acctTable[i].invAmt.toString()==null?" ":"₦ " + formatCurrency(_acctTable[i].invAmt), style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Text(_acctTable[i].invDueDate.toString()==null?" ":_acctTable[i].invDueDate.toString(), style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Text(_acctTable[i].tenure.toString()==null?" ":_acctTable[i].tenure.toString(), style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(_acctTable[i].approvedBy.toString()==null?" ":_acctTable[i].approvedBy.toString(), style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 16,top: 8),
                  child: PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          child: InkWell(
                            onTap: () {
                              capsaPrint('view Tapped');
                              setState(() {
                                dialogHelper.showPdf(context,anchorsActions, _acctTable[i].fileName);
                              });
                            },
                            child: Row(
                              children: [
                                Icon(Icons.remove_red_eye),
                                RichText(
                                  text: TextSpan(
                                    text: 'View Invoice',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromRGBO(51, 51, 51, 1)),
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                    ],
                  )
              )
            ])
        );
      }
      setState(() {
        _dataLoaded = true;
      });

    }
  }

  void _previousPage(){
    if(_currentIndex>1){
      setState(() {
        _dataLoaded = false;
      });
      rows = [];
      rows.add(
          TableRow(children: [
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text('S/N', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Invoice No', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Vendor Name', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Issue Date', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Invoice Amount', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Due Date', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Tenure', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
            ),
            Container(
              padding: const EdgeInsets.only(top: 5, bottom: 16),
              child: Text('Rejected By', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text(' ', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(0, 152, 217, 1),
              )),
            )
          ])
      );
      _currentIndex--;
      for(int i = (_currentIndex-1) * 8;i<((_currentIndex - 1) * 8 ) + 8;i++){
        rows.add(
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Text((i+1).toString()==null?" ":(i+1).toString(), style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Text(_acctTable[i].invNo.toString()==null?" ":_acctTable[i].invNo.toString(), style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Text(_acctTable[i].vendor.toString()==null?" ":_acctTable[i].vendor.toString(), style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Text(_acctTable[i].invDate.toString()==null?" ":_acctTable[i].invDate.toString(), style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Text("₦ "+_acctTable[i].invAmt.toString()==null?" ":"₦ " + formatCurrency(_acctTable[i].invAmt), style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Text(_acctTable[i].invDueDate.toString()==null?" ":_acctTable[i].invDueDate.toString(), style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Text(_acctTable[i].tenure.toString()==null?" ":_acctTable[i].tenure.toString(), style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(_acctTable[i].approvedBy.toString()==null?" ":_acctTable[i].approvedBy.toString(), style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(51, 51, 51, 1),
                )),
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 16,top: 8),
                  child: PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          child: InkWell(
                            onTap: () {
                              capsaPrint('view Tapped');
                              setState(() {
                                dialogHelper.showPdf(context,anchorsActions, _acctTable[i].fileName);
                              });
                            },
                            child: Row(
                              children: [
                                Icon(Icons.remove_red_eye),
                                RichText(
                                  text: TextSpan(
                                    text: 'View Invoice',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromRGBO(51, 51, 51, 1)),
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                    ],
                  )
              )
            ])
        );
      }
      setState(() {
        _dataLoaded = true;
      });

    }
  }



  @override
  void initState(){
    super.initState();
    getData(context);
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.9,
      child: _dataLoaded?SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // padding: EdgeInsets.all((!Responsive.isMobile(context)) ? 12 : 1.0),
              // color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      // width: 200,
                      height: (!Responsive.isMobile(context)) ? 65 : 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        color: Colors.white,
                      ),
                      padding: Responsive.isMobile(context)
                          ? EdgeInsets.symmetric(horizontal: 5, vertical: 2)
                          : EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: TextFormField(
                        // autofocus: false,
                        onChanged: (v) {
                          search = v;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          // fillColor: Color.fromRGBO(234, 233, 233, 1.0),
                          // filled: true,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,

                          // contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                          suffixIcon: IconButton(
                            onPressed: () {
                              // type
                              capsaPrint('Search Tapped $search');
                              getData(context);
                            },
                            icon: Icon(Icons.search),
                          ),
                          // isDense: true,
                          // focusedBorder: InputBorder.none,
                          // enabledBorder: InputBorder.none,
                          // errorBorder: InputBorder.none,
                          // disabledBorder: InputBorder.none,
                          // contentPadding: EdgeInsets.only(left: 15, bottom: 15, top: 15, right: 15),
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(130, 130, 130, 1),
                              fontFamily: 'Poppins',
                              fontSize: (!Responsive.isMobile(context)) ? 18 : 15,
                              letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                          hintText: Responsive.isMobile(context) ? "Search by invoice number" : "Search by invoice number, Anchor name",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40,),
                  InkWell(
                    onTap: ()=>createCSV(),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Export',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                // fontFamily: 'Poppins',
                                fontSize: 22,
                                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                        ),
                        SizedBox(width: 3),
                        Image.asset(
                          "assets/images/download.png",
                          height: 20,
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.fromLTRB(29, 24, 36, 33),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Table(
                      columnWidths: {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(4.2),
                        2: FlexColumnWidth(3.2),
                        3: FlexColumnWidth(3.2),
                        4: FlexColumnWidth(3.2),
                        5: FlexColumnWidth(3.2),
                        6: FlexColumnWidth(2.8),
                        7: FlexColumnWidth(4.3)
                      },
                      border: TableBorder(verticalInside: BorderSide.none),
                      children: rows,
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(900, 10, 15, 16),
                    child: Card(
                      color: Color.fromRGBO(245, 251, 255, 1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        width: 290,
                        height: 56,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(24, 17.5, 24, 17.5),
                              child: Text(
                                'Page',
                                style: TextStyle(fontSize: 14, color: Color.fromRGBO(51, 51, 51, 1)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 17.5, 30, 17.5),
                              child: Text(
                                '$_currentIndex of $_numberOfPages',
                                style: TextStyle(fontSize: 14, color: Color.fromRGBO(51, 51, 51, 1)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 22, 30, 22),
                              child: IconButton(onPressed: () {_previousPage();}, icon: Icon(Icons.arrow_back_ios), iconSize: 14, color: Color.fromRGBO(130, 130, 130, 1), padding: EdgeInsets.all(0)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 22, 14, 22),
                              child: IconButton(onPressed: () {_nextPage();}, icon: Icon(Icons.arrow_forward_ios), iconSize: 14, color: Color.fromRGBO(130, 130, 130, 1), padding: EdgeInsets.all(0)),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ):Center(child: Padding(
        padding: EdgeInsets.all(24),
        child: CircularProgressIndicator(),
      ),),
    );
  }
}
