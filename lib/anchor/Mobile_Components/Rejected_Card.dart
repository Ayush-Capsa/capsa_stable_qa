import 'package:capsa/anchor/Mobile_Invoices/rejected_details.dart';
import 'package:capsa/anchor/provider/anchor_action_providers.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

Widget rejectedCard({
  @required String compName,
  @required String invoiceNo,
  @required String date,
  @required String value,
  @required AcctTableData data,
  @required BuildContext context1
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      color: Color.fromRGBO(245, 251, 255, 1),
      child: InkWell(
        onTap: (){
          Navigator.of(context1).push(MaterialPageRoute(builder: (context) => rejectedDetails(data: data,)));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    invoiceNo,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(51, 51, 51, 1)
                    ),
                  ),
                  Text(
                    compName,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(130, 130, 130, 1)
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    value,
                    style: TextStyle(
                        color: Color.fromRGBO(51, 51, 51, 1),
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(130, 130, 130, 1)
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}