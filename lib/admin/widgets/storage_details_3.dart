import 'package:capsa/functions/currency_format.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

import 'package:capsa/admin/common/constants.dart';

class StarageDetails3 extends StatelessWidget {
  const StarageDetails3({Key key, this.resultSet4, this.set}) : super(key: key);

  final resultSet4;
  final bool set;

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
          if (!set)
            Text(
              "Active",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          if (!set) SizedBox(height: 10),
          if (!set)
            StorageInfoCard(
              icon: Icons.list_alt,
              title: "Active Vendors ",
              numOfFiles: resultSet4['ActiveVendor'].toString(),
            ),
          if (!set)
            StorageInfoCard(
              icon: Icons.list_alt,
              title: "Active Investors ",
              numOfFiles: resultSet4['ActiveInvestor'].toString(),
            ),
          if (set)
            StorageInfoCard(
              icon: Icons.list_alt,
              title: "Conversion rate ",
              numOfFiles: resultSet4['ConversionRate'].toString(),
            ),
          if (set)
            StorageInfoCard(
              icon: Icons.list_alt,
              title: "Churn rate",
              numOfFiles: resultSet4['Churnrate'].toString(),
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
