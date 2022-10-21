import 'package:capsa/admin/dialogs/topup_acct.dart';
import 'package:capsa/admin/screens/withdraw-amt/withdraw_amt_page.dart';
import 'package:capsa/admin/widgets/card_widget.dart';

import 'package:capsa/common/responsive.dart';
import 'package:capsa/widgets/add_bene.dart';
import 'package:capsa/widgets/withdraw_amt.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import 'package:capsa/admin/providers/profile_provider.dart';

import 'package:capsa/admin/data/capsa_table.dart';

// import 'package:capsa/investor/widgets/mobile/capsa_acct_transaction_card.dart';

import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class CapsaAccountFragment extends StatefulWidget {
  @override
  _CapsaAccountFragmentState createState() => _CapsaAccountFragmentState();
}

class _CapsaAccountFragmentState extends State<CapsaAccountFragment> {
  String value;

  var list = [
    "Topup Account",
    "Withdraw",
  ];

  bool load = true;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    // Provider.of<ProfileProvider>(context, listen: false)
    //     .queryProfile();
    Provider.of<ProfileProvider>(context, listen: false).queryBankTransaction();

    Future.delayed(const Duration(milliseconds: 10000), () {
      // Here you can write your code

      setState(() {
        // Here you can write your code for open new view
        load = false;
      });
    });
  }

  var list2 = [
    "Topup Account",
    "Add Beneficiary",
  ];

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final _getBankDetails = profileProvider.getBankDetails;
    final _transactionDetails = profileProvider.transactionDetails;
    // capsaPrint(profileProvider.totalBalance);

    if (_getBankDetails.bene_account_no.trim() == '') {
      list = list2;
    }

    return Container(
      child: Responsive.isMobile(context)
          ? Column(
              children: [
                Container(
                  margin: EdgeInsets.all(18),
                  padding: EdgeInsets.all(22),
                  color: Theme.of(context).accentColor.withOpacity(0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _getBankDetails?.bank_name ?? "",
                            style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 5),
                          Container(
                            color: Theme.of(context).primaryColor.withOpacity(0.2),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                _getBankDetails?.account_number ?? "",
                                style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          '₦ ' + profileProvider.totalBalance.toString(),
                          style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        subtitle: Text('Account Balance'),
                        trailing: Image.asset(
                          'assets/cowry.png',
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: MaterialButton(
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                            color: Color(0xFFb0eaed).withOpacity(0.5),
                            onPressed: () {
                              // same for investor & vendor
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider(
                                      create: (context) => ProfileProvider(),
                                      child: WithdrawPage()),
                                ),
                              );
                            },
                            child: Text(
                              '-  Withdraw',
                              style: TextStyle(color: Color(0xFF3ed2d9), fontWeight: FontWeight.bold),
                            ),
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                          flex: 3,
                          child: MaterialButton(
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                            color: Color(0xFF9bdff2),
                            onPressed: () {
                              showTopUpAct(context, _getBankDetails);
                            },
                            child: Text(
                              '+  Fund Account',
                              style: TextStyle(color: Color(0xFF2bb0d9), fontWeight: FontWeight.bold),
                            ),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transactions',
                        style: TextStyle(color: Colors.grey[700], fontSize: 18),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.download_rounded,
                            color: Colors.grey[700],
                          ),
                          onPressed: () {})
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 0, 18.0, 0),
                  child: SingleChildScrollView(
                    child: StreamBuilder<Object>(
                        stream: null,
                        builder: (context, snapshot) {
                          if (_transactionDetails.isEmpty) if (load)
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          else
                            return Text('No data found');
                          else
                            return Card(
                              child: Container(
                                //  margin: EdgeInsets.symmetric(horizontal: 18),
                                child: Column(
                                  children: [
                                    for (var details in _transactionDetails)
                                      Container(
                                        // child: MCapsaAcctTransactionCard(
                                        //   tDetails: details,
                                        // ),
                                      )
                                    // MCapsaAcctTransactionCard(
                                    //   title: 'Credit',
                                    // ),
                                    // MCapsaAcctTransactionCard(
                                    //   title: 'Credit',
                                    // ),
                                    // MCapsaAcctTransactionCard(
                                    //   title: 'Debit',
                                    // ),
                                    // MCapsaAcctTransactionCard(
                                    //   title: 'Credit',
                                    // ),
                                    // MCapsaAcctTransactionCard(
                                    //   title: 'Debit',
                                    // ),
                                    // MCapsaAcctTransactionCard(
                                    //   title: 'Debit',
                                    // ),
                                  ],
                                ),
                              ),
                            );
                        }),
                  ),
                )),
              ],
            )
          : LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                  child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            height: 180,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CardFragment(
                                  title: 'Total Transaction Value',
                                  subtitle: '33 Discounts',
                                  no: '0',
                                  width: 420,
                                  icon: LineAwesomeIcons.pie_chart,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                CardFragment(
                                  title: 'Total Returns',
                                  subtitle: '12%',
                                  no: '0',
                                  width: 420,
                                  icon: LineAwesomeIcons.line_chart,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                CardFragment(
                                  title: 'Upcoming Payment',
                                  subtitle: '01/04/2021',
                                  no: '0',
                                  width: 420,
                                  icon: LineAwesomeIcons.credit_card,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          subtitle: Text(
                                            '₦ ' + profileProvider.totalBalance.toString(),
                                            style: TextStyle(
                                              fontSize: 28,
                                            ),
                                          ),
                                          title: Text(
                                            'Your Capsa Account Balance',
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(28, 4, 28, 28),
                                        padding: EdgeInsets.fromLTRB(28, 10, 28, 28),
                                        color: Theme.of(context).colorScheme.secondary,
                                        child: Column(
                                          children: [
                                            for (var v in list)
                                              InkWell(
                                                onTap: () async {
                                                  if (v == 'Topup Account') {
                                                    await showTopUpAct(context, _getBankDetails);
                                                  } else if (v == 'Add Beneficiary') {
                                                    await showAddBeneficiaryDialog(
                                                        context, _getBankDetails, profileProvider.bankList, profileProvider);
                                                  } else {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) => ChangeNotifierProvider(
                                                            create: (context) => ProfileProvider(),
                                                            child: WithdrawPage()),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width * 0.7,
                                                  padding: const EdgeInsets.all(4.0),
                                                  margin: const EdgeInsets.all(8.0),
                                                  decoration:
                                                      BoxDecoration(color: Colors.blueGrey[900], borderRadius: BorderRadius.all(Radius.circular(20))),
                                                  child: Center(
                                                    child: Padding(
                                                        padding: const EdgeInsets.all(2.0),
                                                        child: Text(
                                                          v,
                                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                                        )

                                                        // DropdownButton(
                                                        //   underline: SizedBox(),
                                                        //   hint: Text(
                                                        //     'Account Action',
                                                        //     style: TextStyle(
                                                        //         color: Colors.white,
                                                        //         fontWeight:
                                                        //         FontWeight.bold,
                                                        //         fontSize: 22),
                                                        //   ),
                                                        //   value: value,
                                                        //   onTap: () {},
                                                        //   onChanged: (newValue) async {
                                                        //     if (newValue ==
                                                        //         'Topup Account') {
                                                        //       await showTopUpAct(
                                                        //           context,
                                                        //           _getBankDetails);
                                                        //     }else if (newValue == 'Add Beneficiary') {
                                                        //
                                                        //       showAddBeneficiaryDialog(
                                                        //           context,
                                                        //           _getBankDetails,profileProvider.bankList,profileProvider);
                                                        //
                                                        //     } else {
                                                        //       showWithdrawalDialog(
                                                        //           context,
                                                        //           _getBankDetails,profileProvider);
                                                        //     }
                                                        //   },
                                                        //   items: list.map((location) {
                                                        //     return DropdownMenuItem(
                                                        //       child: Text(
                                                        //         location,
                                                        //         style: TextStyle(
                                                        //             color: Colors.black,
                                                        //             fontWeight:
                                                        //             FontWeight.bold,
                                                        //             fontSize: 22),
                                                        //       ),
                                                        //       value: location,
                                                        //     );
                                                        //   }).toList(),
                                                        // ),
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              'The account number provided is unique to your Capsa account. You can fund your wallet by making a transfer to this account from any bank in Nigeria',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          subtitle: Text(
                                            _getBankDetails?.account_number ?? "",
                                            style: TextStyle(
                                              fontSize: 28,
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                          title: Text(
                                            'Your Capsa Bank Account',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 4,
                                fit: FlexFit.tight,
                                child: CapsaTable(
                                  title: "Last 5 transaction",
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Expanded(child: CapsaTable()),
                      ],
                    ),
                  ),
                ),
              ));
            }),
    );
  }
}
