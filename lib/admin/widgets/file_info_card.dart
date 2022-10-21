// import 'package:admin/models/MyFiles.dart';
import 'package:capsa/admin/data/dashboard_data.dart';
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

// import 'package:flutter_svg/flutter_svg.dart';
import 'package:capsa/admin/common/constants.dart';

// import '../../../constants.dart';

class FileInfoCard extends StatelessWidget {
  const FileInfoCard({
    Key key,
    this.info,
  }) : super(key: key);

  final DashboardDataInfo info;

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
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  // padding: EdgeInsets.all(10),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    // color: info.color.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Icon(
                    info.icon,
                    color: info.color,
                    size: 40,
                  )

                  // SvgPicture.asset(
                  //   info.svgSrc,
                  //   color: info.color,
                  // ),
                  ),
              // Icon(Icons.more_vert, color: Colors.white54)
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Flexible(
            child: Text(
              info.title,
              maxLines: 2,
              // overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          if (info.percentage != null)
            SizedBox(
              height: 10,
            ),
          // if (info.percentage != null)
          //   ProgressLine(
          //     color: info.color,
          //     percentage: info.percentage,
          //   ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${info.numOfFiles}",
                style: Theme.of(context).textTheme.caption.copyWith(color: Colors.white),
              ),
              // Text(
              //   info.totalStorage,
              //   style: Theme.of(context).textTheme.caption.copyWith(color: Colors.white),
              // ),
            ],
          )
        ],
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key key,
    this.color = primaryColor,
    this.percentage,
  }) : super(key: key);

  final Color color;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
