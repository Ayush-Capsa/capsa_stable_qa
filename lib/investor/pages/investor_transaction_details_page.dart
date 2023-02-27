import 'package:capsa/admin/dialogs/investor_dialogs.dart';
import 'package:capsa/common/responsive.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/functions/show_toast.dart';
import 'package:capsa/functions/to_upper_case.dart';
import 'package:capsa/investor/models/opendeal_model.dart';
import 'package:capsa/investor/models/proposal_model.dart';
import 'package:capsa/investor/provider/invoice_providers.dart';
import 'package:capsa/investor/provider/proposal_provider.dart';
import 'package:capsa/investor/widgets/bid_details_widgets.dart';
import 'package:capsa/providers/profile_provider.dart';
import 'package:capsa/widgets/TopBarWidget.dart';
import 'package:capsa/widgets/orientation_switcher.dart';
import 'package:capsa/widgets/user_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:capsa/functions/custom_print.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class InvestorTransactionDetailsPage extends StatefulWidget {
  final String invNum;

  final bool onlyBid;
  final String amt;

  const InvestorTransactionDetailsPage(this.invNum,
      {Key key, this.onlyBid, this.amt})
      : super(key: key);

  @override
  State<InvestorTransactionDetailsPage> createState() =>
      _InvestorTransactionDetailsPageState();
}

class _InvestorTransactionDetailsPageState
    extends State<InvestorTransactionDetailsPage> {
  OpenDealModel openInvoices;
  ProposalModel _proposalModel;
  String dName = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void downloadCall(BuildContext context, ProposalProvider proposalProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool processing = false;

        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
              "Sale Agreement",
              style: titleStyle,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            backgroundColor: Color.fromRGBO(245, 251, 255, 1),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<Object>(
                  future: proposalProvider.loadPurchaseAgreement(
                      _proposalModel, 'false'),
                  builder: (context, snapshot) {
                    dynamic _data = snapshot.data;

                    if (snapshot.hasData) {
                      if (_data['res'] == 'success') {
                        var url = _data['data']['url'];
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          constraints: BoxConstraints(minWidth: 750),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: SfPdfViewer.network(
                                  url,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              if (_proposalModel.digital_name_buyer == null ||
                                  _proposalModel.digital_name_buyer.trim() ==
                                      '')
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Digital Signature',
                                    style: lableStyle.copyWith(
                                        color: Colors.black),
                                  ),
                                ),
                              if (_proposalModel.digital_name_buyer == null ||
                                  _proposalModel.digital_name_buyer.trim() ==
                                      '')
                                SizedBox(
                                  height: 5,
                                ),
                              Row(
                                children: [
                                  if (_proposalModel.digital_name_buyer ==
                                          null ||
                                      _proposalModel.digital_name_buyer
                                              .trim() ==
                                          '')
                                    Expanded(
                                      flex: 3,
                                      child: UserTextFormField(
                                        label: '',
                                        hintText: 'Type here your full name',
                                        inputFormatters: [
                                          UpperCaseTextFormatter(),
                                        ],
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        // textCapitalization: TextCapitalization.characters,
                                        keyboardType: TextInputType.text,
                                        onChanged: (value) => dName = value,
                                        validator: (String value) {
                                          if (value.trim().isEmpty) {
                                            return 'Cannot be empty';
                                          }
                                          return null;
                                        },
                                      ),
                                      // child: TextFormField(
                                      //   inputFormatters: [
                                      //     UpperCaseTextFormatter(),
                                      //   ],
                                      //   autovalidateMode: AutovalidateMode.onUserInteraction,
                                      //   textCapitalization: TextCapitalization.characters,
                                      //   keyboardType: TextInputType.text,
                                      //   onChanged: (value) => dName = value,
                                      //   validator: (String value) {
                                      //     if (value.trim().isEmpty) {
                                      //       return 'Cannot be empty';
                                      //     }
                                      //     return null;
                                      //   },
                                      //   decoration: InputDecoration(hintText: 'Enter First Name & Last Name'),
                                      // ),
                                    ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  // if (widget.proposal.digital_name_buyer_accept_time == null || widget.proposal.digital_name_buyer.trim() == '')
                                  if (!processing)
                                    SizedBox(
                                      width: 100,
                                      child: MaterialButton(
                                        height: 50,
                                        color: Colors.green,
                                        child: Text(
                                          'Download',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (dName.trim() == '' ||
                                              dName == null) {
                                            showToast(
                                                'Please Enter Digital Name Field',
                                                context,
                                                type: 'warning');
                                            return;
                                          }

                                          setState(() {
                                            processing = true;
                                          });

                                          dynamic _response =
                                              await proposalProvider
                                                  .loadPurchaseAgreement(
                                                      _proposalModel, 'true',
                                                      dName: dName);
                                          if (_response['res'] == 'success') {
                                            var url = _response['data']['url'];
                                            // capsaPrint(url);
                                            showToast(
                                                'Downloading please wait...',
                                                context,
                                                type: 'info');
                                            await proposalProvider
                                                .downloadFile(url);
                                            setState(() {
                                              // openInvoices.digital_name_buyer_accept_time = dName;
                                              // openInvoices.digital_name_buyer = dName;
                                              // widget.proposal.digital_name_buyer = dName;
                                              // processing = false;
                                            });
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                    )
                                  else
                                    Center(child: CircularProgressIndicator()),
                                ],
                              )
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    } else {
                      return Center(
                        child: Container(
                          height: 200,
                          width: 500,
                          child: Center(
                              child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
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
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final profileProvider = Provider.of<ProfileProvider>(context);

    final proposalProvider =
        Provider.of<ProposalProvider>(context, listen: false);

    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Responsive.isMobile(context) ? 15 : 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!Responsive.isMobile(context))
                SizedBox(
                  height: 22,
                ),
              TopBarWidget(
                  widget.onlyBid ? "Bid Details" : "Transaction Details", ""),
              if (!Responsive.isMobile(context))
                SizedBox(
                  height: 18,
                ),
              FutureBuilder(
                  future: Provider.of<InvoiceProvider>(context, listen: false)
                      .loadInVData(widget.invNum, widget.amt),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'There was an error :(\n' + snapshot.error.toString(),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      );
                    } else if (snapshot.hasData) {
                      dynamic data = snapshot.data;
                      var _data;
                      if (data['res'] == 'success') {
                        _data = data['data'];
                        var element = _data['ilplist'].isEmpty
                            ? null
                            : _data['ilplist'][0];

                        openInvoices = element != null
                            ? OpenDealModel(
                                invoice_value:
                                    element['invoice_value'].toString(),
                                isRevenue: element['isRevenue'].toString(),
                                start_date: element['start_date'],
                                due_date: element['due_date'],
                                eff_due_date: element['eff_due_date'],
                                minimum_investment:
                                    element['minimum_investment'].toString(),
                                invoice_number: element['invoice_number'],
                                trans_his: element['trans_his'],
                                description: element['description'],
                                customer_name: element['customer_name'],
                                comp_contract_address:
                                    element['comp_contract_address'],
                                child_address: element['child_address'],
                                discount_percentage:
                                    element['discount_percentage'].toString(),
                                discount_status:
                                    element['discount_status'].toString(),
                                companyName: element['companyName'],
                                companyPAN: element['companyPAN'],
                                companySafePercentage:
                                    element['companySafePercentage'].toString(),
                                customerCIN: element['customerCIN'],
                                industry: element['industry'],
                                founded: element['founded'],
                                key_person: element['key_person'],
                                about: element['about'],
                                colour: element['colour'],
                                city: element['city'],
                                state: element['state'],
                                website: element['website'],
                                linkedin: element['linkedin'],
                                fb: element['fb'],
                                twitter: element['twitter'],
                                insta: element['insta'],
                                customer_pan:
                                    element['customer_pan'].toString(),
                                sel_CIN: element['sel_CIN'],
                                sel_industry: element['sel_industry'],
                                sel_founded: element['sel_founded'],
                                sel_key_person: element['sel_key_person'],
                                sel_about: element['sel_about'],
                                sel_website: element['sel_website'],
                                sel_linkedin: element['sel_linkedin'],
                                sel_fb: element['sel_fb'],
                                sel_twitte: element['sel_twitte'],
                                sel_insta: element['sel_insta'],
                                ask_amt: element['ask_amt'].toString(),
                                ask_rate: element['ask_rate'].toString(),
                                totalDiscount:
                                    element['totalDiscount'].toString(),
                                alcptdy: element['alcptdy'].toString(),
                                prop_amt: element['prop_amt'].toString())
                            : null;

                        print('pass 1 $openInvoices');

                        if (_data['digital'] != null &&
                            _data['digital'].length > 0) {
                          var element2 = _data['digital'][0];
                          _proposalModel = openInvoices != null
                              ? ProposalModel(
                                  ask_amt: openInvoices.ask_amt.toString(),
                                  invoice_value: openInvoices.invoice_value,
                                  p_type: element2['p_type'].toString(),
                                  start_date: openInvoices.start_date,
                                  due_date: openInvoices.due_date,
                                  eff_due_date: openInvoices.eff_due_date,
                                  minimum_investment:
                                      openInvoices.minimum_investment,
                                  invoice_number: openInvoices.invoice_number,
                                  description: openInvoices.description,
                                  customer_name: openInvoices.customer_name,
                                  comp_contract_address:
                                      openInvoices.comp_contract_address,
                                  child_address: openInvoices.child_address,
                                  discount_percentage:
                                      openInvoices.discount_percentage,
                                  discount_status: openInvoices.discount_status,
                                  companyName: openInvoices.companyName,
                                  lender_pan: element2['inv_pan'],
                                  cust_pan: openInvoices.customer_pan,
                                  comp_pan: openInvoices.companyPAN,
                                  prop_amt: element2['prop_amt'].toString(),
                                  int_rate: element2['int_rate'].toString(),
                                  prop_stat: element2['prop_stat'].toString(),
                                  docID: '',
                                  sign_stat: element2['sign_stat'].toString(),
                                  digital_name: element2['digital_name'],
                                  digital_name_accept_time:
                                      element2['digital_name_accept_time'],
                                  digital_name_buyer:
                                      element2['digital_name_buyer'],
                                  digital_name_buyer_accept_time: element2[
                                      'digital_name_buyer_accept_time'],
                                )
                              : null;
                          print('pass 2');
                        }
                      } else {
                        return Container();
                      }
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            bidDetailsFrameStatus(context, _data,
                                isDetails: widget.onlyBid),
                            SizedBox(
                              height: Responsive.isMobile(context) ? 15 : 20,
                            ),
                            Builder(builder: (context) {
                              var paymentRec = _data['paymentRec'];
                              var payDone = _data['payDone'];
                              var isAccepted = _data['isAccepted'];
                              var ispending = _data['ispending'];
                              var isdownload = false;
                              if (widget.onlyBid) {
                                if (ispending) {
                                } else {
                                  if (isAccepted) {
                                    isdownload = true;
                                  } else {}
                                }
                              } else {
                                if (paymentRec) {
                                  isdownload = true;
                                } else {
                                  if (!payDone) {
                                  } else {
                                    isdownload = true;
                                  }
                                }
                              }

                              return Row(
                                children: [
                                  openInvoices != null
                                      ? Flexible(
                                          flex: 4,
                                          child: bidDetailsFrameTopInfo(
                                              context, openInvoices,
                                              isDetails: widget.onlyBid))
                                      : Container(),
                                  if (!Responsive.isMobile(context))
                                    if (isdownload)
                                      SizedBox(
                                        width: 25,
                                      ),
                                  if (!Responsive.isMobile(context))
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        //height : 400,
                                        width: 250,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (ispending)
                                              InkWell(
                                                onTap: () async {
                                                  //capsaPrint(_proposalModel.invoice_number);
                                                  await showEditBidDialog(
                                                    context,
                                                    openInvoices,
                                                    openInvoices.prop_amt,
                                                  );
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(15),
                                                      topRight:
                                                          Radius.circular(15),
                                                      bottomLeft:
                                                          Radius.circular(15),
                                                      bottomRight:
                                                          Radius.circular(15),
                                                    ),
                                                    color: HexColor('#F2994A'),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 15),
                                                  child: Center(
                                                    child: Text(
                                                      'Edit Bid',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              242, 242, 242, 1),
                                                          fontSize: 16,
                                                          letterSpacing:
                                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          height: 1),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            if (ispending)
                                              SizedBox(
                                                height: 20,
                                              ),
                                            if (ispending)
                                              InkWell(
                                                onTap: () async {
                                                  //capsaPrint(_proposalModel.invoice_number);
                                                  await showDeleteBidDialog(
                                                    context,
                                                    openInvoices,
                                                    openInvoices.prop_amt,
                                                  );
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(15),
                                                      topRight:
                                                          Radius.circular(15),
                                                      bottomLeft:
                                                          Radius.circular(15),
                                                      bottomRight:
                                                          Radius.circular(15),
                                                    ),
                                                    border: Border.all(
                                                        color: Colors.red,
                                                        width: 3),
                                                    color: Colors.transparent,
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 15),
                                                  child: Center(
                                                    child: Text(
                                                      'Cancel Bid',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 16,
                                                          letterSpacing:
                                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          height: 1),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            if (isdownload)
                                              Container(
                                                child: Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        downloadCall(context,
                                                            proposalProvider);
                                                      },
                                                      child: Container(
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    15),
                                                            topRight:
                                                                Radius.circular(
                                                                    15),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    15),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    15),
                                                          ),
                                                          color: Color.fromRGBO(
                                                              0, 152, 219, 1),
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 15,
                                                                vertical: 15),
                                                        child: Center(
                                                          child: Text(
                                                            'Download Contract',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        242,
                                                                        242,
                                                                        242,
                                                                        1),
                                                                fontSize: 16,
                                                                letterSpacing:
                                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                height: 1),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    )
                                ],
                              );
                            }),
                            SizedBox(
                              height: 20,
                            ),
                            openInvoices != null
                                ? bidDetailsInfo(openInvoices, context)
                                : Container(),
                            SizedBox(
                              height: 20,
                            ),
                            if (Responsive.isMobile(context))
                              Builder(builder: (context) {
                                var paymentRec = _data['paymentRec'];
                                var payDone = _data['payDone'];
                                var isAccepted = _data['isAccepted'];
                                var ispending = _data['ispending'];
                                var isdownload = false;
                                if (widget.onlyBid) {
                                  if (ispending) {
                                  } else {
                                    if (isAccepted) {
                                      isdownload = true;
                                    } else {}
                                  }
                                } else {
                                  if (paymentRec) {
                                    isdownload = true;
                                  } else {
                                    if (!payDone) {
                                    } else {
                                      isdownload = true;
                                    }
                                  }
                                }

                                return Column(
                                  children: [
                                    if (ispending)
                                      InkWell(
                                        onTap: () async {
                                          //capsaPrint(_proposalModel.invoice_number);
                                          await showEditBidDialog(
                                            context,
                                            openInvoices,
                                            openInvoices.prop_amt,
                                          );
                                          setState(() {});
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(15),
                                            ),
                                            color: HexColor('#F2994A'),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                          child: Center(
                                            child: Text(
                                              'Edit Bid',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      242, 242, 242, 1),
                                                  fontSize: 16,
                                                  letterSpacing:
                                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (ispending)
                                      SizedBox(
                                        height: 20,
                                      ),
                                    if (ispending)
                                      InkWell(
                                        onTap: () async {
                                          //capsaPrint(_proposalModel.invoice_number);
                                          await showDeleteBidDialog(
                                            context,
                                            openInvoices,
                                            openInvoices.prop_amt,
                                          );
                                          setState(() {});
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(15),
                                            ),
                                            border: Border.all(
                                                color: Colors.red, width: 3),
                                            color: Colors.transparent,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                          child: Center(
                                            child: Text(
                                              'Cancel Bid',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 16,
                                                  letterSpacing:
                                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (!isdownload)
                                      Container()
                                    else
                                      Container(
                                        child: InkWell(
                                          onTap: () {
                                            downloadCall(
                                                context, proposalProvider);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15),
                                                bottomLeft: Radius.circular(15),
                                                bottomRight:
                                                    Radius.circular(15),
                                              ),
                                              color: Color.fromRGBO(
                                                  0, 152, 219, 1),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 15),
                                            child: Center(
                                              child: Text(
                                                'Download',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        242, 242, 242, 1),
                                                    fontSize: 16,
                                                    letterSpacing:
                                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                );
                              })
                          ],
                        ),
                      );
                    } else if (!snapshot.hasData) {
                      return Center(child: Text("No data found."));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
