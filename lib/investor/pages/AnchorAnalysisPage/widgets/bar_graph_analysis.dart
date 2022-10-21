import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';
import 'package:capsa/investor/pages/AnchorAnalysisPage/widgets/bar_chart.dart';


class BarGraphWidget extends StatelessWidget {
  const BarGraphWidget({Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      elevation: 2,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('Revenue',style: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 24),),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('₦ 43,000,000',style: TextStyle(color: Colors.black,fontSize: 28,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    Icon(Icons.arrow_drop_up_sharp,color: Colors.green,),
                    Text('34.3%',style: TextStyle(color: Colors.green),),
                  ],
                ),
              ),
              Expanded(child: BarChart()),

              Row(
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                      height: 20,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 5,),
                  Text('Revenue (in millions of naira)')
                ],
              )

            ],
          ),
        ),

      ),
    );
  }
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}