import 'package:capsa/admin/data/vendor_data.dart';
import 'package:capsa/admin/providers/action_model.dart';
import 'package:capsa/admin/widgets/vendor_list_card.dart';
import 'package:capsa/common/app_theme.dart';
import 'package:capsa/common/responsive.dart';

import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/admin/common/constants.dart';

import 'package:provider/provider.dart';

class VendorList extends StatefulWidget {
  final String title;

  const VendorList({Key key, this.title}) : super(key: key);

  @override
  _VendorListState createState() => _VendorListState();
}

class _VendorListState extends State<VendorList> {
  var searchInvoiceText = "" ;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Responsive.isMobile(context)
                ? AccountTable(): Padding(
              padding: Responsive.isMobile(context)
                  ? const EdgeInsets.fromLTRB(5, 0, 5, 0)
                  : const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              '${widget.title}',
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: <Widget>[
                              TextFormField(
                                // onFieldSubmitted: (value) {
                                //   // after pressing enter
                                //   capsaPrint(value);
                                // },
                                onChanged: (value) {
                                  searchInvoiceText = value;
                                  if (value == "") setState(() {});
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search by name, bvn, rc number & mobile',
                                  // suffixIcon: Icon(
                                  //   Icons.search,
                                  //   color: Colors.blueGrey.withOpacity(0.9),
                                  //
                                  // ),
                                ),
                                // onTap: () {

                                // capsaPrint("Invoice");

                                // },
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.blueGrey.withOpacity(0.9),
                                ),
                                onPressed: () {
                                  // do something

                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Responsive.isMobile(context) ? 5 : 30,
                  ),
                  Container(
                    color: Theme.of(context).primaryColor,
                    child: Divider(
                      height: 1,
                      color: Theme.of(context).primaryColor,
                      thickness: 0,
                    ),
                  ),
                  SizedBox(
                    height: Responsive.isMobile(context) ? 8 : 35,
                  ),
                  Expanded(child: AccountTable(filter:  searchInvoiceText,)),
                ],
              ),
            ),
          ),
        ));
      }),
    );
  }
}

class AccountTable extends StatefulWidget {
  final String title;
  final String filter;

  const AccountTable({Key key, this.title, this.filter}) : super(key: key);

  @override
  _AccountTableState createState() => _AccountTableState();
}

class _AccountTableState extends State<AccountTable> {
  int _rowsPerPage = 5;
  int _sortColumnIndex;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: MediaQuery.of(context).size.width < 800
          ? FutureBuilder<Object>(
              future: Provider.of<ActionModel>(context, listen: false)
                  .queryVendorList(filter : widget.filter ),
              builder: (BuildContext context, AsyncSnapshot<Object> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: Text('Loading...'),
                  );
                }
                if (snapshot.hasData) {
                  dynamic _data = snapshot.data;

                  List<VendorData> _enquiryData = <VendorData>[];

                  if (_data['res'] == 'success') {
                    var _results = _data['data']['results'];

                    // ACTIVE: 1
                    // ADDED_FOR: ""
                    // ADD_LINE: "Bhilai"
                    // CITY: "Bhilai"
                    // CONTACT: ""
                    // CONTACT_STATUS: 0
                    // COUNTRY: null
                    // EMAIL: ""
                    // EMAIL_STATUS: 0
                    // LANDING_LICENSE: 0
                    // LANDING_LICENSE_URL: ""
                    // NAME: "TestBuyer"
                    // OTP: null
                    // PAN_IMAGE: 0
                    // PAN_IMAGE_URL: null
                    // PAN_NO: "22244467661"
                    // PASSWORD: ""
                    // PROFILE_PIC: null
                    // REQ_PAN: "22244467661R"
                    // STATE: "Chhattisgarh"
                    // UID: "RC22244467661"
                    // UID_IMAGE: 0
                    // UID_IMAGE_URL: null
                    // about_company: ""
                    // account_number: "0036717289"
                    // company_invoice_url: "http://18.224.61.114/"
                    // diigital_signature: "HAFUTV"
                    // lender_priority: null
                    // secret_key: ""
                    // user_id: 190
                    // wallet_address: ""

                    _results.forEach((element) {
                      _enquiryData.add(VendorData(
                        element['req_name'],
                        element['NAME'],
                        element['PAN_NO'],
                        element['email'],
                        element['remarks'],
                        element['contact_number'],
                        element['role'],
                        element['role2'],
                        element['ADD_LINE'],
                        element['CITY'],
                        element['state'],
                        element['ACTIVE'].toString(),
                        element['modified_at'],
                        element['industry'],
                        element['keyPerson'],
                        element['founded'],
                        element['UID'],
                        element['account_number'],
                        element['AL_UPLOAD'].toString(),

                        element['KYC1'].toString(),
                        element['KYC2'].toString(),
                        element['KYC3'].toString(),

                        element['kyc1_doc'],
                        element['kyc2_doc'],
                        element['kyc3_doc'],


                      ));
                    });
                  } else {
                    return Center(
                      child: Text('Error Loading Data.'),
                    );
                  }
                  return VendorListCard(
                    enquiryData: _enquiryData,
                    title: widget.title,
                  );
                } else {
                  return Center(
                    child: Text('Loading...'),
                  );
                }
              })
          : ListView(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              children: <Widget>[
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  color: Colors.white,
                  child: FutureBuilder<Object>(
                      future: Provider.of<ActionModel>(context, listen: false)
                          .queryVendorList(filter : widget.filter),
                      builder: (BuildContext context,
                          AsyncSnapshot<Object> snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Center(
                            child: Text('Loading...'),
                          );
                        }
                        if (snapshot.hasData) {
                          dynamic _data = snapshot.data;

                          List<VendorData> _enquiryData = <VendorData>[];

                          if (_data['res'] == 'success') {
                            var _results = _data['data']['results'];

                            // ACTIVE: 1
                            // ADDED_FOR: ""
                            // ADD_LINE: "Bhilai"
                            // CITY: "Bhilai"
                            // CONTACT: ""
                            // CONTACT_STATUS: 0
                            // COUNTRY: null
                            // EMAIL: ""
                            // EMAIL_STATUS: 0
                            // LANDING_LICENSE: 0
                            // LANDING_LICENSE_URL: ""
                            // NAME: "TestBuyer"
                            // OTP: null
                            // PAN_IMAGE: 0
                            // PAN_IMAGE_URL: null
                            // PAN_NO: "22244467661"
                            // PASSWORD: ""
                            // PROFILE_PIC: null
                            // REQ_PAN: "22244467661R"
                            // STATE: "Chhattisgarh"
                            // UID: "RC22244467661"
                            // UID_IMAGE: 0
                            // UID_IMAGE_URL: null
                            // about_company: ""
                            // account_number: "0036717289"
                            // company_invoice_url: "http://18.224.61.114/"
                            // diigital_signature: "HAFUTV"
                            // lender_priority: null
                            // secret_key: ""
                            // user_id: 190
                            // wallet_address: ""

                            _results.forEach((element) {
                              _enquiryData.add(VendorData(
                                element['req_name'],
                                element['NAME'],
                                element['PAN_NO'],
                                element['email'],
                                element['remarks'],
                                element['contact_number'],
                                element['role'],
                                element['role2'],
                                element['ADD_LINE'],
                                element['CITY'],
                                element['state'],
                                element['ACTIVE'].toString(),
                                element['modified_at'],
                                element['industry'],
                                element['keyPerson'],
                                element['founded'],
                                element['UID'],
                                element['account_number'],
                                element['AL_UPLOAD'].toString(),
                                element['KYC1'].toString(),
                                element['KYC2'].toString(),
                                element['KYC3'].toString(),

                                element['kyc1_doc'],
                                element['kyc2_doc'],
                                element['kyc3_doc'],
                              ));
                            });
                          } else {
                            return Center(
                              child: Text('Error Loading Data.'),
                            );
                          }

                          final VendorListDataSource _investorListDataSource =
                              VendorListDataSource(
                                  context, _enquiryData, widget.title);
                          return Theme(
                            data: tableTheme,
                            child: PaginatedDataTable(
                                dataRowHeight: 60,
                                columnSpacing: 42,
                                onPageChanged: (value) {
                                  // capsaPrint('$value');
                                },
                                // columnSpacing: 110,
                                availableRowsPerPage: [5, 10, 20],
                                rowsPerPage: _rowsPerPage,
                                onRowsPerPageChanged: (int value) {
                                  _rowsPerPage = value;
                                },
                                sortColumnIndex: _sortColumnIndex,
                                sortAscending: _sortAscending,
                                columns: <DataColumn>[
                                  DataColumn(
                                    label: Text('S.No.',
                                        style: tableHeadlineStyle),
                                  ),
                                  DataColumn(
                                    label: Text('BVN No.',
                                        style: tableHeadlineStyle),
                                  ),
                                  DataColumn(
                                    label:
                                        Text('Name', style: tableHeadlineStyle),
                                  ),
                                  DataColumn(
                                    label: Text('Address',
                                        style: tableHeadlineStyle),
                                  ),
                                  DataColumn(
                                    label: Text('Account',
                                        style: tableHeadlineStyle),
                                  ),
                                  DataColumn(
                                    label: Text('Status',
                                        style: tableHeadlineStyle),
                                  ),
                                  DataColumn(
                                    label: Text('Action',
                                        style: tableHeadlineStyle),
                                  ),
                                ],
                                source: _investorListDataSource),
                          );
                        } else {
                          return Center(
                            child: Text('Loading...'),
                          );
                        }
                      }),
                )
              ],
            ),
    );
  }
}
