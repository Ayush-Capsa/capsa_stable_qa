import 'package:capsa/common/app_theme.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';

// import 'package:capsa/investor/dialogs/investor_dialogs.dart';
import 'package:capsa/widgets/capsaapp/generatedframe111widget/GeneratedFrame111Widget.dart';
import 'package:capsa/widgets/capsaapp/generatedframe111widget/generated/GeneratedPresentedWidget.dart';
import 'package:capsa/widgets/capsaapp/generatedframe179widget/GeneratedFrame179Widget.dart';
import 'package:capsa/widgets/capsaapp/generatedvendorbidsdesktopwidget/GeneratedVendorBidsDesktopWidget.dart';
import 'package:capsa/vendor-new/model/bids_model.dart';
import 'package:capsa/vendor-new/provider/vendor_action_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/datatable_dynamic.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/popup_action_info.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';

// import 'dart:math' as math;
// import 'package:beamer/beamer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// import 'dart:math' as math;
class BidsDetailsPage extends StatefulWidget {
  final invoiceNum;

  const BidsDetailsPage(this.invoiceNum, {Key key}) : super(key: key);

  @override
  _StateBidsDetailsPage createState() => _StateBidsDetailsPage();
}

class _StateBidsDetailsPage extends State<BidsDetailsPage> {
  void justCallSetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
          child: FutureBuilder<Object>(
              future: Provider.of<VendorActionProvider>(context, listen: false).bidProposalDetails(Uri.decodeComponent(widget.invoiceNum)),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Text(
                    'There was an error :(',
                    style: Theme.of(context).textTheme.headline1,
                  );
                } else if (snapshot.hasData) {
                  List<BidsModel> _bidsModel = [];
                  dynamic result = snapshot.data;

                  if (result['res'] == 'success') {
                    List proposalsList = result['data']['Proposalslist'];

                    proposalsList.forEach((element) {
                      BidsModel _dessert = BidsModel(
                        element['cust_pan'],
                        element['lender_name'],
                        element['description'],
                        element['docID'],
                        element['due_date'],
                        element['eff_due_date'],
                        element['int_rate'].toString(),
                        element['invoice_number'],
                        element['invoice_value'].toString(),
                        element['lender_name'].toString(),
                        element['lender_pan'],
                        element['p_type'].toString(),
                        element['prop_amt'].toString(),
                        element['prop_stat'].toString(),
                        element['sign_stat'].toString(),
                        element['start_date'],
                        element['nofBids'].toString(),
                        element['highBid'].toString(),
                        element['customer_rc'],
                      );

                      _bidsModel.add(_dessert);
                    });

                    capsaPrint("bid details start");
                    int i = 0;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: Responsive.isMobile(context)?CrossAxisAlignment.center:CrossAxisAlignment.start,
                      children: [
                        if (!Responsive.isMobile(context))
                          SizedBox(
                            height: 22,
                          ),
                        if (!Responsive.isMobile(context)) TopBarWidget(_bidsModel[0].customer_name, ""),
                        if (!Responsive.isMobile(context))
                          SizedBox(
                            height: 10,
                          ),
                        // if (_bidsModel[0].prop_stat != '0') GeneratedFrame111Widget(_bidsModel[0]),
                        if (!Responsive.isMobile(context))
                          SizedBox(
                            height: 15,
                          ),
                        // Figma Flutter Generator Frame93Widget - FRAME - HORIZONTAL
                        if (Responsive.isMobile(context))
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(0),
                              ),
                              boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.10000000149011612), offset: Offset(5, 5), blurRadius: 20)],
                              color: Color.fromRGBO(245, 251, 255, 1),
                              // image: DecorationImage(image: AssetImage('assets/images/Frame93.png'), fit: BoxFit.fitWidth),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(),
                                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'Invoice Value',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Color.fromRGBO(51, 51, 51, 1),
                                              fontFamily: 'Poppins',
                                              fontSize: 10,
                                              letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ),
                                        SizedBox(height: 4),
                                        Container(
                                          decoration: BoxDecoration(),
                                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                '₦',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(0, 152, 219, 1),
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight: FontWeight.normal,
                                                    height: 1),
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                formatCurrency(_bidsModel[0].invoice_value),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(0, 152, 219, 1),
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight: FontWeight.normal,
                                                    height: 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 30),
                                  Container(
                                    decoration: BoxDecoration(),
                                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(),
                                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'Highest Bid',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(51, 51, 51, 1),
                                                    fontFamily: 'Poppins',
                                                    fontSize: 10,
                                                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight: FontWeight.normal,
                                                    height: 1),
                                              ),
                                              SizedBox(width: 4),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(6),
                                                    topRight: Radius.circular(6),
                                                    bottomLeft: Radius.circular(6),
                                                    bottomRight: Radius.circular(6),
                                                  ),
                                                  color: Color.fromRGBO(33, 150, 83, 1),
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Text(
                                                      'Accept Bid',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(242, 242, 242, 1),
                                                          fontFamily: 'Poppins',
                                                          fontSize: 8,
                                                          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                          fontWeight: FontWeight.normal,
                                                          height: 1),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Container(
                                          decoration: BoxDecoration(),
                                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                '₦',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(0, 152, 219, 1),
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight: FontWeight.normal,
                                                    height: 1),
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                formatCurrency(_bidsModel[0].highBid),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(0, 152, 219, 1),
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight: FontWeight.normal,
                                                    height: 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // SizedBox(width: 58),
                                  // Transform.rotate(
                                  //   angle: -90.00000250447523 * (math.pi / 180),
                                  //   child: Divider(color: Color.fromRGBO(130, 130, 130, 1), thickness: 1),
                                  // ),
                                  SizedBox(width: 30),
                                  Container(
                                    decoration: BoxDecoration(),
                                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'Invoice No',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Color.fromRGBO(51, 51, 51, 1),
                                              fontFamily: 'Poppins',
                                              fontSize: 10,
                                              letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ),
                                        SizedBox(height: 4),
                                        Container(
                                          decoration: BoxDecoration(),
                                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                _bidsModel[0].invoice_number,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(0, 152, 219, 1),
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                    letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight: FontWeight.normal,
                                                    height: 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          GeneratedFrame179Widget(_bidsModel[0]),
                        SizedBox(
                          height: 22,
                        ),
                        if (Responsive.isMobile(context))
                          bidDetailsCardWidget(context, _bidsModel, widget.invoiceNum)
                        else
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                                bottomRight: Radius.circular(0.0),
                                bottomLeft: Radius.circular(20.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(25, 0, 0, 0),
                                  offset: Offset(5.0, 5.0),
                                  blurRadius: 20.0,
                                ),
                                BoxShadow(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  offset: Offset(-5.0, -5.0),
                                  blurRadius: 0.0,
                                )
                              ],
                            ),
                            child: DataTable(
                              columns: dataTableColumn(["S/N", "Bid By", "Bid Amount", "Platform fee", "Net Amount", "Action"]),
                              rows: <DataRow>[
                                for (var bids in _bidsModel)
                                  DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(
                                        (++i).toString(),
                                        style: dataTableBodyTextStyle,
                                      )),
                                      DataCell(Text(
                                        bids.customer_name,
                                        style: dataTableBodyTextStyle,
                                      )),
                                      DataCell(Text(
                                        formatCurrency(bids.prop_amt),
                                        style: dataTableBodyTextStyle,
                                      )),
                                      DataCell(Builder(builder: (context) {
                                        //commented by Amitesh Sahu on Feb 17 2022
                                        //var pfee = ((num.parse(bids.invoice_value) - num.parse(bids.prop_amt)) / 100) * 10;

                                        var pfee = ((num.parse(bids.invoice_value)) / 100) * .85;


                                        return Text(
                                          formatCurrency(pfee),
                                          style: dataTableBodyTextStyle,
                                        );
                                      })),
                                      DataCell(Builder(builder: (context) {
                                        //commented by Amitesh Sahu on Feb 17 2022
                                        //var pfee = ((num.parse(bids.invoice_value) - num.parse(bids.prop_amt)) / 100) * 10;

                                        var pfee = ((num.parse(bids.invoice_value)) / 100) * .85;
                                        var netamt = num.parse(bids.prop_amt) - pfee;

                                        return Text(
                                          formatCurrency(netamt),
                                          style: dataTableBodyTextStyle,
                                        );
                                      })),
                                      DataCell(ButtonAction(bids, justCallSetState, widget.invoiceNum)),
                                    ],
                                  ),
                              ],
                            ),
                          )
                      ],
                    );
                  } else {
                    return Container(
                      child: Center(child: Text(result['messg'].toString())),
                    );
                  }
                } else if (!snapshot.hasData) {
                  return Container(
                    child: Center(child: Text("No bids found.")),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
    );
  }

  Widget bidDetailsCardWidget(BuildContext context, List<BidsModel> bidsModel, String invoiceNum) {
    return Column(
      children: [
        for (BidsModel bids in bidsModel)
          Padding(
            padding: const EdgeInsets.only(bottom: 22.0),
            child: GeneratedVendorBidsDesktopWidget(
              bids,
              actionWidget: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: false,
                      child: Container(
                        decoration: BoxDecoration(),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Platform fees:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color.fromRGBO(51, 51, 51, 1),
                                  // fontFamily: 'Poppins',
                                  fontSize: 14,
                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                            SizedBox(width: 4),
                            Container(
                              decoration: BoxDecoration(),
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    '₦',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 152, 219, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    bids.prop_amt,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 152, 219, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Flexible(child: ButtonAction(bids, justCallSetState, invoiceNum))
                  ],
                ),
              ),
              title: 'Investor',
            ),
          ),
      ],
    );
  }
}

class ButtonAction extends StatefulWidget {
  final BidsModel bids;
  final Function justCallSetState;
  final String invoiceNum;

  const ButtonAction(this.bids, this.justCallSetState, this.invoiceNum, {Key key}) : super(key: key);

  @override
  _ButtonAcceptState createState() => _ButtonAcceptState();
}

class _ButtonAcceptState extends State<ButtonAction> {
  bool _loading = false;

  String digitalName = "";

  bool processing = false;

  final titleStyle = TextStyle(
    color: Colors.green,
    fontWeight: FontWeight.bold,
    fontSize: 22,
  );

  final lableStyle = TextStyle(
    color: Colors.grey[600],
  );

  @override
  Widget build(BuildContext context) {
    if (_loading) return Center(child: CircularProgressIndicator());
    final actionProvider = Provider.of<VendorActionProvider>(context, listen: false);

    if (widget.bids.prop_stat == '0') {
      var _text = "You are about to accept a bid of ₦ " +
          formatCurrency(widget.bids.prop_amt) +
          " from " +
          widget.bids.customer_name +
          " Bank for your Invoice worth of ₦ " +
          formatCurrency(widget.bids.invoice_value) +
          ".  ";

      return Row(
        mainAxisAlignment: Responsive.isMobile(context) ?  MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              return showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                      backgroundColor: Color.fromRGBO(245, 251, 255, 1),
                      content: Container(
                        constraints: Responsive.isMobile(context)
                            ? BoxConstraints(
                                minHeight: 300,
                              )
                            : BoxConstraints(minHeight: 220, maxWidth: 400),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(245, 251, 255, 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _text,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 22,
                              ),
                              Text("Do you wish to proceed? ", textAlign: TextAlign.center),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Figma Flutter Generator YesWidget - TEXT
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true).pop();

                                      return showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(builder: (context, setState) {
                                            return AlertDialog(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                              insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                              title: Text(
                                                "Sale Agreement",
                                                style: titleStyle,
                                              ),
                                              content: Theme(
                                                data: appTheme,
                                                child: Padding(
                                                  padding: EdgeInsets.all(Responsive.isMobile(context) ? 1 : 8.0),
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 1 : 20),
                                                    constraints: Responsive.isMobile(context)
                                                        ? BoxConstraints(
                                                            minWidth: double.infinity,
                                                          )
                                                        : BoxConstraints(minWidth: 750),
                                                    child: Center(
                                                      child: FutureBuilder<Object>(
                                                          future: actionProvider.loadPurchaseAgreement(widget.bids),
                                                          builder: (context, snapshot) {
                                                            dynamic _data = snapshot.data;

                                                            if (snapshot.hasData) {
                                                              if (_data['res'] == 'success') {
                                                                var url = _data['data']['url'];
                                                                return Container(
                                                                  width: double.infinity,
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      Expanded(
                                                                        child: Container(
                                                                          // color: Theme.of(context).accentColor,
                                                                          child: Container(
                                                                            margin: EdgeInsets.all(5),
                                                                            child: SfPdfViewer.network(url),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: 15,
                                                                      ),
                                                                      Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(
                                                                          'Digital Signature',
                                                                          style: lableStyle.copyWith(color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                      OrientationSwitcher(
                                                                        children: [
                                                                          Flexible(
                                                                            flex: Responsive.isMobile(context) ? 1 : 3,
                                                                            child: TextFormField(
                                                                              inputFormatters: [
                                                                                UpperCaseTextFormatter(),
                                                                              ],
                                                                              onChanged: (value) => digitalName = value,
                                                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                              textCapitalization: TextCapitalization.characters,
                                                                              keyboardType: TextInputType.text,
                                                                              validator: (String value) {
                                                                                if (value.trim().isEmpty) {
                                                                                  return 'Cannot be empty';
                                                                                }
                                                                                return null;
                                                                              },
                                                                              decoration: InputDecoration(hintText: 'Enter First Name & Last Name'),
                                                                            ),
                                                                          ),
                                                                          if (Responsive.isMobile(context))
                                                                            SizedBox(
                                                                              height: 15,
                                                                            )
                                                                          else
                                                                            SizedBox(
                                                                              width: 20,
                                                                            ),
                                                                          if (processing) CircularProgressIndicator(),
                                                                          if (!processing)
                                                                            Flexible(
                                                                              flex: 1,
                                                                              child: MaterialButton(
                                                                                height: 56,
                                                                                color: Colors.green,
                                                                                child: Text(
                                                                                  'Accept',
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                                onPressed: () async {
                                                                                  setState(() {
                                                                                    processing = true;
                                                                                  });

                                                                                  if (digitalName.trim() == '' || digitalName == null) {
                                                                                    showToast('Please Enter Digital Name Field', context,
                                                                                        type: 'warning');
                                                                                    return;
                                                                                  }

                                                                                  if (widget.bids.prop_stat == '0') {
                                                                                    await actionProvider.actionOnProposal(
                                                                                        widget.bids, "ACCEPT", digitalName);

                                                                                    showToast('Bid Successfully accepted.', context);

                                                                                    widget.justCallSetState();

                                                                                    actionProvider..bidProposalDetails(Uri.decodeComponent(widget.invoiceNum));

                                                                                    Navigator.of(context, rootNavigator: true).pop();

                                                                                  }

                                                                                  return null;
                                                                                },
                                                                              ),
                                                                            ),
                                                                          if (Responsive.isMobile(context))
                                                                            SizedBox(
                                                                              height: 15,
                                                                            )
                                                                          else
                                                                            SizedBox(
                                                                              width: 20,
                                                                            ),
                                                                          if (!processing)
                                                                            Flexible(
                                                                                flex: 1,
                                                                                child: MaterialButton(
                                                                                  height: 56,
                                                                                  color: Colors.red,
                                                                                  child: Text(
                                                                                    'Cancel',
                                                                                    style: TextStyle(
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    Navigator.of(context, rootNavigator: true).pop();
                                                                                    return null;
                                                                                  },
                                                                                )),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              } else {
                                                                return Container();
                                                              }
                                                            } else {
                                                              return Center(
                                                                child: Container(
                                                                  child: Center(
                                                                      child: Row(
                                                                    children: [
                                                                      CircularProgressIndicator(),
                                                                      SizedBox(
                                                                        width: 15,
                                                                      ),
                                                                      Text('Loading...'),
                                                                    ],
                                                                  )),
                                                                ),
                                                              );
                                                            }
                                                          }),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                        },
                                      );
                                    },
                                    child: Text(
                                      'Yes',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color.fromRGBO(33, 150, 83, 1),
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true).pop();
                                    },
                                    child: // Figma Flutter Generator NoWidget - TEXT
                                        Text(
                                      'No',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color.fromRGBO(235, 87, 87, 1),
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
            child: !Responsive.isMobile(context)
                ? Text('Accept', style: TextStyle(color: Color.fromRGBO(33, 150, 83, 1), fontSize: 15))
                : Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                        bottomLeft: Radius.circular(6),
                        bottomRight: Radius.circular(6),
                      ),
                      color: Color.fromRGBO(33, 150, 83, 1),
                    ),

                    child: Center(
                      child: Text(
                        'Accept',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(242, 242, 242, 1),
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                    )),
          ),
          if (!Responsive.isMobile(context))
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(height: 18, child: VerticalDivider(color: Colors.black54, thickness: 2, width: 3)),
            ),
          InkWell(
            onTap: () {
              var _text = "You are about to reject a bid of ₦ " +
                  formatCurrency(widget.bids.prop_amt) +
                  " from " +
                  widget.bids.customer_name +
                  " Bank for your Invoice worth of ₦ " +
                  formatCurrency(widget.bids.invoice_value) +
                  ".  ";

              return showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                      backgroundColor: Color.fromRGBO(245, 251, 255, 1),
                      content: Container(
                        constraints: Responsive.isMobile(context)
                            ? BoxConstraints(
                                minHeight: 300,
                              )
                            : BoxConstraints(minHeight: 220, maxWidth: 400),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(245, 251, 255, 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _text,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 22,
                              ),
                              Text("Do you wish to proceed? ", textAlign: TextAlign.center),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Figma Flutter Generator YesWidget - TEXT
                                  InkWell(
                                    onTap: () async {
                                      await actionProvider.actionRejectProposal(widget.bids, "REJECT");

                                      showToast('Rejected! We will try to bring better deal next time.', context);
                                      // capsaPrint("Yes");
                                      widget.justCallSetState();
                                      actionProvider..bidProposalDetails(Uri.decodeComponent(widget.invoiceNum));
                                      Navigator.of(context, rootNavigator: true).pop();

                                    },
                                    child: Text(
                                      'Yes',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color.fromRGBO(33, 150, 83, 1),
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true).pop();
                                    },
                                    child: // Figma Flutter Generator NoWidget - TEXT
                                        Text(
                                      'No',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color.fromRGBO(235, 87, 87, 1),
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });

              // showPopupActionInfo(context,
              //     heading: "Are you Sure? ",
              //     onTap: () async {
              //       await actionProvider.actionRejectProposal(widget.bids, "REJECT");
              //
              //       showToast('Rejected! We will try to bring better deal next time.', context);
              //       capsaPrint("Yes");
              //       Navigator.of(context, rootNavigator: true).pop();
              //       widget.justCallSetState();
              //     },
              //     onTap2: () => {
              //           Navigator.of(context, rootNavigator: true).pop(),
              //         },
              //     barrierDismissible: true,
              //     buttonText: "Yes",
              //     buttonText2: "Cancel");
              //
            },
            child: !Responsive.isMobile(context)
                ? Text(
                    'Reject',
                    style: TextStyle(color: Colors.redAccent, fontSize: 15),
                  )
                : Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                        bottomLeft: Radius.circular(6),
                        bottomRight: Radius.circular(6),
                      ),
                      color: Colors.redAccent,
                    ),
                    child: Center(
                      child: Text(
                        'Reject',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(242, 242, 242, 1),
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                    )),
          ),
        ],
      );
    } else {
      var text12 = '';

      dynamic _color = Colors.white;
      if (widget.bids.prop_stat == '1') {
        _color = Colors.green[400];
        text12 = 'Accepted';
      } else if (widget.bids.prop_stat == '2') {
        _color = Colors.grey;
        text12 = 'Rejected';
      }

      return Container(
        child: !Responsive.isMobile(context)
            ? Text(
                text12,
                textAlign: TextAlign.center,
                style: TextStyle(color: _color, fontSize: 15),
              )
            : Container(
                height: 37,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                  color: _color,
                ),
                child: Center(
                  child: Text(
                    text12,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(242, 242, 242, 1),
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                )),
      );
    }
  }
}
