import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/anchor/Components/nairaSymbol.dart';

Widget paymentCard({
  @required String name,
  @required String date,
  @required String amount,
  @required String invoiceNo,
  @required BuildContext context
}) {
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: Container(
      width: MediaQuery.of(context).size.width*0.92,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))
        ),
        color: Color.fromRGBO(201, 248, 255, 0.76),
        elevation: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(51, 51, 51, 1)
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 4, bottom: 2),
                        child: Text(
                          '${currency(context).currencySymbol}',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(51, 51, 51, 1)
                          ),
                        ),
                      ),
                      Text(
                        amount,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color.fromRGBO(51, 51, 51, 1)
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(51, 51, 51, 1)
                    ),
                  ),
                  Text(
                    invoiceNo,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
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