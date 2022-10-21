import 'package:capsa/functions/currency_format.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

import 'package:capsa/admin/common/constants.dart';

class StarageDetails extends StatelessWidget {
  const StarageDetails({
    Key key,
    this.resultSet2,
  }) : super(key: key);

  final resultSet2;

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
            "Metrics",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SizedBox(height: defaultPadding),
          StorageInfoCard(
            icon: Icons.list_alt,
            title: "Vendor volume traded",
            // amountOfFiles: "1.3GB",
            numOfFiles: resultSet2['VVT'].toString(),
          ),
          StorageInfoCard(
            icon: Icons.list_alt_outlined,
            title: "Investor volume",
            // amountOfFiles: "15.3GB",
            numOfFiles:  resultSet2['IVI'].toString(),
          ),
          StorageInfoCard(
            icon: Icons.list_alt_sharp,
            title: "Total Value of Invoice Traded",
            // amountOfFiles: "1.3GB",
            numOfFiles:  formatCurrency(resultSet2['TVITsum'],withIcon: true) ,
          ),
          StorageInfoCard(
            icon: Icons.list_alt,
            title: "Total Payment Volume",
            // amountOfFiles: "1.3GB",
            numOfFiles:    formatCurrency(resultSet2['TPV'],withIcon: true) ,
          ),
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
