import 'package:capsa/functions/currency_format.dart';
import 'package:capsa/functions/hexcolor.dart';
import 'package:capsa/models/bid_history_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BidDetailsPage extends StatelessWidget {

  BidHistoryModel bid;

  BidDetailsPage({Key key, this.bid}) : super(key: key);

  Widget status(BidHistoryModel bids) {
    // return Text(bids.historyStatus);
    String _text = 'Pending';
    String _text2 = "";
    dynamic clr = HexColor('#F2994A');

    if (bids.paymentStatus == '1') {
      _text = 'Closed';
      _text2 = 'Payment Received';
      clr = HexColor("#EB5757");
    } else {
      if (bids.discount_status == 'true') {

        if (DateFormat("yyyy-MM-ddThh:mm:ss")
            .parse(bids.effectiveDueDate)
            .isBefore(DateTime.now())){
          _text = 'Overdue';
          _text2 = "Payment Overdue";
          clr = HexColor('#F2994A');
        } else{
          _text = 'Open';
          _text2 = "Awaiting anchor’s payment";
          clr = Colors.green;
        }
      } else {
        _text = 'Pending';
        _text2 = 'Payment Pending';
        clr = HexColor('#F2994A');
      }
    }

    // if (bids.paymentStatus == '1') {
    //   _text = 'Closed';
    //   _text2 = 'Payment Received';
    //   clr = HexColor("#EB5757");
    // } else {
    //   if (bids.discount_status == 'true') {
    //     _text = 'Open';
    //     _text2 = "Awaiting anchor’s payment";
    //     clr = Colors.green;
    //   } else if(DateFormat("yyyy-MM-ddThh:mm:ss").parse(bids.effectiveDueDate).isBefore(DateTime.now())){
    //     _text = 'OverDue';
    //     _text2 = "Payment Overdue";
    //     clr = HexColor('#F2994A');
    //   }
    //   //if(DataTime.parse(bids.effectiveDueDate))
    // }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _text,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: clr,
                // fontFamily: 'Poppins',
                fontSize: 15,
                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1),
          ),

          Text(
            _text2,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.black,
                // fontFamily: 'Poppins',
                fontSize: 12,
                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
        ],
      ),
    );
  }

  String gainPer(BidHistoryModel model) {
    double result =
        ((double.parse(gains(model)) / double.parse(model.discountVal))) * 100;
    return result.toStringAsFixed(2);
  }

  String gains(BidHistoryModel model) {
    double result =
        (double.parse(model.invoiceValue) - double.parse(model.discountVal)) * 0.9;
    return result.toString();
  }

  String netReturn(BidHistoryModel model) {
    double pltfee = 0.1 * double.parse((double.parse(model.invoiceValue) - double.parse(model.discountVal)).toString());
    double result = double.parse(model.invoiceValue) - pltfee;
    return result.toString();
  }


  Widget infoCard(String title, String content, BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 230, 243, 250),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),),
              SizedBox(height: 4,),
              Text(content,style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: HexColor('#0098DB')),)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(

      children: [

        SizedBox(height: 10,),

        status(bid),

        SizedBox(height: 10,),

        Material(
          elevation: 2,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  infoCard('Anchor Name', bid.customerName, context),

                  infoCard('Invoice Value', formatCurrency(bid.invoiceValue, withIcon: true,  ), context),

                  infoCard('Bid Amount', formatCurrency(bid.discountVal, withIcon: true, ), context),

                  infoCard('Gain %', gainPer(bid), context),

                  infoCard('Gain', formatCurrency(gains(bid), withIcon: true,  ), context),

                  infoCard('Net Returns', formatCurrency(netReturn(bid), withIcon: true,  ), context),

                  infoCard('Due Date', DateFormat('d MMM, y').format(bid.discountedDate).toString(), context),
                ],
              ),
            ),
          ),
        )



      ],

    );
  }
}


