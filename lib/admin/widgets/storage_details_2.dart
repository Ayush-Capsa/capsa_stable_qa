import 'package:capsa/functions/currency_format.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

import 'package:capsa/admin/common/constants.dart';

class StarageDetails2 extends StatelessWidget {
  const StarageDetails2({
    Key key,
    this.resultSet3,
  }) : super(key: key);

  final resultSet3;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Average",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          StorageInfoCard(
            icon: Icons.list_alt,
            title: "Average Invoice value traded",
            // amountOfFiles: "1.3GB",
            numOfFiles: formatCurrency(resultSet3['AIVTavg'], withIcon: true),
          ),
          StorageInfoCard(
            icon: Icons.list_alt_outlined,
            title: "Average discount rate for traded invoices",
            // amountOfFiles: "15.3GB",
            numOfFiles: resultSet3['ADIVTavg'].toString() + ' %',
          ),
          StorageInfoCard(
            icon: Icons.list_alt_sharp,
            title: "Average tenor of invoices traded",
            // amountOfFiles: "1.3GB",
            numOfFiles: resultSet3['ATIT'].toString(),
          ),
          // StorageInfoCard(
          //   icon: Icons.list_alt,
          //   title: "Total Payment Volume",
          //   // amountOfFiles: "1.3GB",
          //   numOfFiles:    formatCurrency(resultSet3['TPV'],withIcon: true) ,
          // ),
        ],
      ),
    );
  }
}

class StorageInfoCard extends StatelessWidget {
  StorageInfoCard({
    Key key,
    this.title,
    this.icon,
    this.amountOfFiles,
    this.numOfFiles,
  }) : super(key: key);

  final String title, amountOfFiles;
  final String numOfFiles;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: defaultPadding),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.white.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
              height: 30,
              width: 30,
              child: Icon(
                icon,
                color: Colors.white,
                size: 30,
              )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "$numOfFiles",
                    style: Theme.of(context).textTheme.caption.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          // Text(amountOfFiles)
        ],
      ),
    );
  }
}
