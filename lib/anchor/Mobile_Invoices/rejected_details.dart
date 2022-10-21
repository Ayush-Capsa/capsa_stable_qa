import 'package:capsa/anchor/mobile_home_page.dart';
import 'package:capsa/anchor/Mobile_Invoices/Invoices_Page.dart';
import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:capsa/functions/call_api.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class rejectedDetails extends StatefulWidget {
  AcctTableData data;
  rejectedDetails({Key key,@required this.data}) : super(key: key);

  @override
  State<rejectedDetails> createState() => _rejectedDetailsState();
}

class _rejectedDetailsState extends State<rejectedDetails> {
  @override
  Widget build(BuildContext context) {
    selectedInvoiceTab = 3;

    bool invLoaded = false;
    var _pdfData;

    Future<Object> getInvFile(_body) async {
      return await callApi('dashboard/a/getInvFile', body: _body);
    }

    initialiseData() async{
      var _body = {'fName': widget.data.fileName};
      _pdfData = await getInvFile(_body);
      setState(() {
        invLoaded = true;
      });
    }

    Widget _pdfDialogScreen(BuildContext context,String url){
      capsaPrint('PDF URL : $url');

      return SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: SfPdfViewer.network(url));

    }

    @override
    void initState(){
      super.initState();
      initialiseData();
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height*0.08
        ),
        child: AppBar(
          backgroundColor: Color.fromRGBO(245, 251, 255, 1),
          leading: IconButton(
            color: Color.fromRGBO(0, 152, 219, 1),
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);},
          ),
          title: Text(
            'Invoice Details',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(51, 51, 51, 1)
            ),
          ),
        ),
      ),
      body: invLoaded?SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height*1.01,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 28),
                child: Card(
                  color: Color.fromRGBO(235, 87, 87, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Rejected',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(255, 255, 255, 1)
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text(
                  'Invoice Number',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(51, 51, 51, 1)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 15),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.92,
                  height: MediaQuery.of(context).size.height*0.07,
                  child: Card(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                          widget.data.invNo,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(51, 51, 51, 1)
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text(
                  'Vendor Name',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(51, 51, 51, 1)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 15),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.92,
                  height: MediaQuery.of(context).size.height*0.07,
                  child: Card(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                      widget.data.vendor,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(51, 51, 51, 1)
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text(
                  'Issue Date',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(51, 51, 51, 1)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 15),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.92,
                  height: MediaQuery.of(context).size.height*0.07,
                  child: Card(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        widget.data.invDate,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(51, 51, 51, 1)
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text(
                  'Tenure',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(51, 51, 51, 1)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 15),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.92,
                  height: MediaQuery.of(context).size.height*0.07,
                  child: Card(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        widget.data.tenure,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(51, 51, 51, 1)
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text(
                  'Rejected by',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(51, 51, 51, 1)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 15),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.92,
                  height: MediaQuery.of(context).size.height*0.07,
                  child: Card(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        widget.data.approvedBy,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(51, 51, 51, 1)
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text(
                  'Effective Due Date',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(51, 51, 51, 1)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 15),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.92,
                  height: MediaQuery.of(context).size.height*0.07,
                  child: Card(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        widget.data.invDueDate,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(51, 51, 51, 1)
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text(
                  'Payable Amount',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(51, 51, 51, 1)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 15),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.92,
                  height: MediaQuery.of(context).size.height*0.07,
                  child: Card(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'N '+ widget.data.invAmt,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(51, 51, 51, 1)
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  initialiseData();
                  setState(() {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                            backgroundColor: invLoaded
                                ? Color.fromRGBO(255, 255, 255, 1)
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            elevation: 5,
                            child: //_dialogScreen(context, widget.invoiceProvider, widget.fileName),
                            _pdfDialogScreen(
                                context, _pdfData['data']['url'])
                                ));
                  });
                },
                child: const Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: Text(
                    'Click here to view invoice',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 152, 219, 1)
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ):Center(child: SingleChildScrollView(),),
    );
  }
}